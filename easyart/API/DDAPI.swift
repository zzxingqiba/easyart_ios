//
//  DDAPI.swift
//  Menses
//
//  Created by Damon on 2020/9/7.
//  Copyright © 2020 Damon. All rights reserved.
//

import Foundation
import Alamofire
import Moya
import RxSwift
import DDLoggerSwift
import RxCocoa
import HDHUD
import RxRelay

enum DDNetStatus {
    case unknown        //未知网络条件
    case notReachable   //断网
    case ethernetOrWiFi //wifi
    case cellular       //流量
}

class DDAPI {
    static let shared: DDAPI = DDAPI()
    var retryDelay = 3   //重试时间间隔
    private(set) var netStatusInfo = BehaviorRelay<DDNetStatus>(value: .cellular)   //当前网络环境

    private let provider = MoyaProvider<DDAPIType>(plugins: [DDAPIPlugin()])
    /// 通过url发起请求
    /// - Parameters:
    ///   - url: 请求的url
    ///   - data: 请求的data
    ///   - cacheType: 缓存类型
    ///   - maxRetry: 发生错误时重试次数
    ///   - autoShowError: 报错时是否自动hud显示
    /// - Returns: 发起请求的对象
    func request(_ url: String, data: [String: Any] = [:], cacheType: DDAPICacheType = .never, maxRetry: Int = 4,  autoShowError: Bool = true) -> Single<DDAPIResponse> {
        let api = DDAPIType.request(urlStr: url, data: data, method: Moya.Method.post)
        return self.request(api, cacheType: cacheType, maxRetry: maxRetry, autoShowError: autoShowError)
    }


    /// 通过APIType发起请求
    /// - Parameters:
    ///   - api: 请求的api
    ///   - data: 请求的data
    ///   - cacheType: 缓存类型
    ///   - maxRetry: 发生错误时重试次数
    ///   - autoShowError: 报错时是否自动hud显示
    /// - Returns: 发起请求的对象
    func request(_ api: DDAPIType, cacheType: DDAPICacheType = .never, maxRetry: Int = 4, autoShowError: Bool = true) -> Single<DDAPIResponse> {

        if cacheType == .cacheOnly || cacheType == .cachePriority {
            let response = self.getResponseFromCache(api: api) ?? DDAPIResponse()
            return Single.just(response)
        }

        return self.provider.rx.request(api)
            .observe(on: MainScheduler.asyncInstance)
            .timeout(RxTimeInterval.seconds(30), scheduler: MainScheduler.asyncInstance)
            .flatMap({ (response) -> Single<DDAPIResponse> in
                //检测请求状态码是否正确
                do {
                    _ = try response.filterSuccessfulStatusCodes()
                } catch {
                    throw DDAPIResponseError.badStatusCode(code: response.statusCode)
                }

                // Response数据格式错误，无法parse
                guard let jsonResponse = try? response.mapJSON() as? [String : AnyObject] else {
                    throw DDAPIResponseError.badResponseContent
                }

                let responseModel = jsonResponse.kj.model(DDAPIResponse.self)
                //token过期
                if responseModel.ok == -4 || responseModel.ok == -6 || responseModel.ok == -13 || responseModel.ok == 107 {
                    throw DDAPIResponseError.authorizationExpired
                }
                //其他错误
                if responseModel.ok != 1 {
                    throw DDAPIResponseError.badResponseCode(response: responseModel)
                }

                //请求成功，缓存数据
                if (cacheType == .cacheOnly || cacheType == .cachePriority || cacheType == .cacheUsedInError) {
                    self.setResponseCache(api: api, response: responseModel)
                }

                return Single.just(responseModel)
                
        }).catch { error in
            // 如果上面抛出任何错误，尝试使用缓存
            if cacheType == .cacheUsedInError {
                if let responseFromCache = self.getResponseFromCache(api: api) {
                    return Single.just(responseFromCache)
                } else {
                    throw error
                }
            } else {
                throw error
            }
        }.retry { [weak self] (rxError) -> Observable<Int> in
            return rxError.enumerated().flatMap({ (index, error) -> Observable<Int> in
                //如果是自己服务器返回的状态错误，则不重试
                switch error {
                    case DDAPIResponseError.badResponseCode(_):
                        if autoShowError {
                            HDHUD.show(error: error)
                        }
                        return Observable.error(error)
                    case DDAPIResponseError.authorizationExpired:
                        guard index < maxRetry else {
                            if autoShowError {
                                HDHUD.show(error: error)
                            }
                            return Observable.error(error)
                        }
                    return DDUserTools.shared.logout().asObservable().flatMap { (_) -> Observable<Int> in
                        printLog(api.path)
                        return DDUserTools.shared.login().asObservable().flatMap { (isLogin) -> Observable<Int> in
                            if isLogin {
                                return Observable.timer(DispatchTimeInterval.seconds(0), scheduler: MainScheduler.instance)
                            } else {
                                return Observable.error(error)
                            }
                        }
                    }
                    default:
                        guard let self = self, index < maxRetry else {
                            if autoShowError {
                                HDHUD.show(error: error)
                            }
                            return Observable.error(error)
                        }
//                        HDHUD.show("网络失败，正在自动重试(第\(index + 1)次)……", icon: .loading)
                        return Observable.timer(DispatchTimeInterval.seconds(self.retryDelay), scheduler: MainScheduler.instance)
                }
            })
        }
    }
    
    ///请求数据，直接返回data数据流
    func requestData(_ url: String, data: [String: Any] = [:], autoShowError: Bool = true) -> Single<Data> {
        var urlStr = "https://api.speakpal.ai/\(url)"
        if APP_DEBUG {
            urlStr = "https://dev-api.speakpal.ai/\(url)"
        }
        let api = DDAPIType.requestGeneral(urlStr: urlStr, data: data)
        return self.provider.rx.request(api)
            .observe(on: MainScheduler.asyncInstance)
            .timeout(RxTimeInterval.seconds(30), scheduler: MainScheduler.asyncInstance)
            .flatMap({ (response) -> Single<Data> in
                //检测请求状态码是否正确
                do {
                    _ = try response.filterSuccessfulStatusCodes()
                } catch {
                    throw DDAPIResponseError.badStatusCode(code: response.statusCode)
                }
                print(response)
                return Single.just(response.data)
                
        }).catch { error in
            throw error
        }.retry { (rxError) -> Observable<Int> in
            return rxError.enumerated().flatMap({ (index, error) -> Observable<Int> in
                //如果是自己服务器返回的状态错误，则不重试
                switch error {
                    case DDAPIResponseError.badResponseCode(_):
                        if autoShowError {
                            HDHUD.show(error: error)
                        }
                        return Observable.error(error)
                    case DDAPIResponseError.authorizationExpired:
                    return DDUserTools.shared.logout().asObservable().flatMap { (_) -> Observable<Int> in
                        printLog(api.path)
                        return DDUserTools.shared.login().asObservable().flatMap { (isLogin) -> Observable<Int> in
                            if isLogin {
                                return Observable.timer(DispatchTimeInterval.seconds(0), scheduler: MainScheduler.instance)
                            } else {
                                return Observable.error(error)
                            }
                        }
                    }
                    default:
                    if autoShowError {
                        HDHUD.show(error: error)
                    }
                    return Observable.error(error)
                }
            })
        }
    }


    /// 上传文件接口
    /// - Parameters:
    ///   - urlStr: 请求的接口
    ///   - params: 请求的参数
    ///   - data: 上传的图片数组
    ///   - fileKey: 上传的文件的key值
    ///   - autoShowError: 是否自动显示报错信息
    /// - Returns: 发起请求的对象
    func upload(_ urlStr:String, params: [String: Any], data: Data, fileKey: String = "file", fileFormat: String = "png", maxRetry: Int = 3, autoShowError: Bool = true) -> Observable<DDAPIProgressResponse> {
        let api: DDAPIType = .upload(urlStr: urlStr, params: params, data: data, key: fileKey, fileFormat: fileFormat)

        return self.provider.rx.requestWithProgress(api)
            .observe(on: MainScheduler.asyncInstance)
                .map { (progressResponse) in
                    if let response = progressResponse.response {
                        //上传完毕，服务器返回内容
                        //检测请求状态码是否正确
                        do {
                            _ = try response.filterSuccessfulStatusCodes()
                        } catch {
                            throw DDAPIResponseError.badStatusCode(code: response.statusCode)
                        }

                        // Response数据格式错误，无法parse
                        guard let jsonResponse = try? response.mapJSON() as? [String : AnyObject] else {
                            throw DDAPIResponseError.badResponseContent
                        }

                        var responseModel = jsonResponse.kj.model(DDAPIProgressResponse.self)
                        //token过期
                        if responseModel.ok == -4 || responseModel.ok == -6 || responseModel.ok == -13 || responseModel.ok == 107 {
                            throw DDAPIResponseError.authorizationExpired
                        }
                        if responseModel.ok != 1 {
                            throw DDAPIResponseError.badResponseCode(response: DDAPIResponse(ok: responseModel.ok, msg: responseModel.msg, data: responseModel.data))
                        }
                        responseModel.progress = progressResponse.progress
                        responseModel.completed = progressResponse.completed
                        return responseModel
                    } else {
                        //正在上传的过程中
                        var responseModel = DDAPIProgressResponse()
                        responseModel.progress = progressResponse.progress
                        responseModel.completed = progressResponse.completed
                        return responseModel
                    }
                }.retry { [weak self] (rxError) -> Observable<Int> in
                    return rxError.enumerated().flatMap({ (index, error) -> Observable<Int> in
                        //如果是自己服务器返回的状态错误，则不重试
                        switch error {
                            case DDAPIResponseError.badResponseCode(_):
                                if autoShowError {
                                    HDHUD.show(error: error)
                                }
                                return Observable.error(error)
                            case DDAPIResponseError.authorizationExpired:
                                guard index < maxRetry else {
                                    if autoShowError {
                                        HDHUD.show(error: error)
                                    }
                                    return Observable.error(error)
                                }
                            return DDUserTools.shared.logout().asObservable().flatMap { (_) -> Observable<Int> in
                                return DDUserTools.shared.login().asObservable().flatMap { (isLogin) -> Observable<Int> in
                                    if isLogin {
                                        return Observable.timer(DispatchTimeInterval.seconds(0), scheduler: MainScheduler.instance)
                                    } else {
                                        return Observable.error(error)
                                    }
                                }
                            }
                            default:
                                guard let self = self, index < maxRetry else {
                                    if autoShowError {
                                        HDHUD.show(error: error)
                                    }
                                    return Observable.error(error)
                                }
//                                HDHUD.show("网络失败，正在自动重试(第\(index + 1)次)……", icon: .loading)
                                return Observable.timer(DispatchTimeInterval.seconds(self.retryDelay), scheduler: MainScheduler.instance)
                        }
                    })
                }
    }


    //MARK: 缓存处理
    private func getResponseFromCache(api: DDAPIType) -> DDAPIResponse? {
        let key = api.path.replacingOccurrences(of: "/", with: ".")
        if let jsonString = DDCacheTools.shared.string(forKey: key) {
            return jsonString.kj.model(DDAPIResponse.self)
        }
        return nil
    }

    private func setResponseCache(api: DDAPIType, response: DDAPIResponse?) {
        let key = api.path.replacingOccurrences(of: "/", with: ".")
        if let response = response {
            DDCacheTools.shared.set(response.kj.JSONString(), forKey: key)
        }
    }

    //MARK: 网络状态监测
    private func currentNetReachability() {
        let manager = NetworkReachabilityManager()
        manager?.startListening(onUpdatePerforming: { [weak self] (status) in
            switch status {
                case .unknown:
                    self?.netStatusInfo.accept(.unknown)
                case .notReachable:
                    self?.netStatusInfo.accept(.notReachable)
                case .reachable(let type):
                    switch type {
                        case .ethernetOrWiFi:
                            self?.netStatusInfo.accept(.ethernetOrWiFi)
                        case .cellular:
                            self?.netStatusInfo.accept(.cellular)
                }
            }
        })
    }
}
