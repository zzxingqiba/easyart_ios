//
//  DDUserTools.swift
//  Menses
//
//  Created by Damon on 2020/7/1.
//  Copyright © 2020 Damon. All rights reserved.
//

import UIKit
import DDUtils
import DDLoggerSwift
import RxSwift
import RxCocoa
import HDHUD
import SwiftyJSON
import KakaJSON

class DDUserTools: NSObject {
    private(set) lazy var userInfo = BehaviorRelay<DDUserModel>(value: self.userModel)
    private(set) lazy var readRuleInfo = BehaviorRelay<Bool>(value: self.hasReadRule)

    private override init() {
        super.init()
        self._bindView()
    }
    
    static let shared: DDUserTools = {
        let tShared = DDUserTools()
        return tShared
    }()

    private var userModel: DDUserModel {
        get {
            if let jsonString = DDCacheTools.shared.string(forKey: UserDefaultKey.userInfo.keyValue()) {
                return jsonString.kj.model(DDUserModel.self) ?? DDUserModel()
            }
            return DDUserModel()
        }
    }

    private var hasReadRule: Bool {
        get {
            return DDCacheTools.shared.bool(forKey: UserDefaultKey.readRule.keyValue(), defaultValue: false)
        }
    }

    var isLogin: Bool {
        return self.userModel.user_id > 0 && self.userModel.user_id != 9999
    }
}

private extension DDUserTools {
    func _bindView() {
        _ = self.userInfo.subscribe(onNext: { userModel in
            let jsonString = userModel.kj.JSONString()
            DDCacheTools.shared.set(jsonString, forKey: UserDefaultKey.userInfo.keyValue())
        })
        
        _ = self.readRuleInfo.subscribe(onNext: { readInfo in
            DDCacheTools.shared.set(readInfo, forKey: UserDefaultKey.readRule.keyValue())
        })
    }
}

//收藏
extension DDUserTools {
    func updateCollect(isNew: Bool, number: String? = nil) {
        let userModel = self.userInfo.value
        userModel.collect_new = isNew
        if let number = number {
            userModel.collect_num = number
        }
        self.userInfo.accept(userModel)
    }
}

//登录和登出
extension DDUserTools {
    
    /// 获取UID并更新用户信息
    /// - Parameters:
    ///   - complete: 更新用户信息完毕
    @discardableResult
    func updateUserInfo(getRoleInfo: Bool = false) -> Single<Bool> {
        //已经登录并且有用户id，直接刷新数据
        return DDAPI.shared.request("home/user", autoShowError: false).flatMap { [weak self] (response) -> Single<Bool> in
            guard response.ok == 1, let self = self else { return Single.error(DDAPIResponseError.badResponseCode(response: response))}
            if !self.isLogin {
                return Single.just(false)
            }
            guard let data = response.data as? [String: AnyObject] else { return Single.error(DDAPIResponseError.badResponseContent) }
            let userModel = data.kj.model(DDUserModel.self)
            if getRoleInfo && (userModel.role.user_role == 2 || userModel.role.user_role == 3) {
                return DDAPI.shared.request("settled/getRoleInfo", data: ["id": userModel.role.id, "type": userModel.role.user_role, "getContent": 0]).flatMap { [weak self] roleResponse in
                    guard roleResponse.ok == 1, let self = self else { return Single.error(DDAPIResponseError.badResponseCode(response: response))}
                    guard let roleData = roleResponse.data as? [String: AnyObject] else { return Single.error(DDAPIResponseError.badResponseContent) }
                    userModel.userRoleDetail = roleData.kj.model(UserRoleDetail.self)
                    self.userInfo.accept(userModel)
                    return Single.just(true)
                }
            } else {
                self.userInfo.accept(userModel)
                return Single.just(true)
            }
        }
    }
    
    ///账号密码登录
    @discardableResult
    func login(email: String?, code: String?) -> Single<Bool> {
        guard email != nil else {
            return Single.error(DDError.string("Invalid email address".localString))
        }
        guard String.isAvailable(code) else {
            return Single.error(DDError.string("Invalid verification code".localString))
        }
        
        let data = ["email": email!, "code": code!, "pName": APP_NAME] as [String : Any]
        return DDAPI.shared.request("login/email", data: data).flatMap { [weak self] (response) -> Single<Bool> in
            guard response.ok == 1 else { return Single.error(DDAPIResponseError.badResponseCode(response: response))}
            guard let data = response.data as? [String: AnyObject] else { return Single.error(DDAPIResponseError.badResponseContent) }
            let userModel = data.kj.model(DDUserModel.self)
            self?.userInfo.accept(userModel)
            DDCacheTools.shared.set("\(userModel.user_id)", forKey: UserDefaultKey.lastUserID.keyValue())
            return Single.just(true)
        }
    }
    
    @discardableResult
    func appleLogin(code: String, token: String) -> Single<Bool> {
        var data = ["openid": code, "id_token": token, "pName": APP_NAME] as [String : Any]
        if let lastID = DDCacheTools.shared.string(forKey: UserDefaultKey.lastUserID.keyValue()) {
            data["before_uid"] = lastID
        }
        return DDAPI.shared.request("login/apple", data: data).flatMap { [weak self] (response) -> Single<Bool> in
            guard response.ok == 1 else { return Single.error(DDAPIResponseError.badResponseCode(response: response))}
            guard let data = response.data as? [String: AnyObject] else { return Single.error(DDAPIResponseError.badResponseContent) }
            let userModel = data.kj.model(DDUserModel.self)
            self?.userInfo.accept(userModel)
            DDCacheTools.shared.set("\(userModel.user_id)", forKey: UserDefaultKey.lastUserID.keyValue())
            return Single.just(true)
        }
    }
    
    ///账号密码登录
    @discardableResult
    func googleLogin(email: String?, userID: String?, name: String?, avatar: String?) -> Single<Bool> {
        guard String.isAvailable(userID) else {
            return Single.error(DDError.string("User information is invalid".localString))
        }
        
        var data = ["email": email!, "userid": userID!, "name": name ?? "", "avatar": avatar ?? "", "pName": APP_NAME] as [String : Any]
        if let lastID = DDCacheTools.shared.string(forKey: UserDefaultKey.lastUserID.keyValue()) {
            data["before_uid"] = lastID
        }
        return DDAPI.shared.request("login/google", data: data).flatMap { [weak self] (response) -> Single<Bool> in
            guard response.ok == 1 else { return Single.error(DDAPIResponseError.badResponseCode(response: response))}
            guard let data = response.data as? [String: AnyObject] else { return Single.error(DDAPIResponseError.badResponseContent) }
            let userModel = data.kj.model(DDUserModel.self)
            self?.userInfo.accept(userModel)
            DDCacheTools.shared.set("\(userModel.user_id)", forKey: UserDefaultKey.lastUserID.keyValue())
            return Single.just(true)
        }
    }
    
    ///twitter登陆
    func twitterLogin(oauth_token: String?, oauth_verifier: String?) -> Single<Bool> {
        guard oauth_token != nil else {
            return Single.error(DDError.string("token invalid".localString))
        }
        guard String.isAvailable(oauth_verifier) else {
            return Single.error(DDError.string("code invalid".localString))
        }
        
        var data = ["oauth_token": oauth_token!, "oauth_verifier": oauth_verifier!] as [String : Any]
        if let lastID = DDCacheTools.shared.string(forKey: UserDefaultKey.lastUserID.keyValue()) {
            data["before_uid"] = lastID
        }
        return DDAPI.shared.request("login/registerTwitter", data: data).flatMap { [weak self] (response) -> Single<Bool> in
            guard response.ok == 1 else { return Single.error(DDAPIResponseError.badResponseCode(response: response))}
            guard let data = response.data as? [String: AnyObject] else { return Single.error(DDAPIResponseError.badResponseContent) }
            let userModel = data.kj.model(DDUserModel.self)
            self?.userInfo.accept(userModel)
            DDCacheTools.shared.set("\(userModel.user_id)", forKey: UserDefaultKey.lastUserID.keyValue())
            return Single.just(true)
        }
    }

    ///跳转到登陆页面
    @discardableResult
    func login() -> Single<Bool> {
        if DDUtils.shared.getCurrentVC() is LoginVC {
            return Single.just(false)
        }
        let vc = LoginVC(bottomPadding: 20)
        vc.modalPresentationStyle = .fullScreen
        DDUtils.shared.getCurrentVC()?.present(vc, animated: true)
        return vc.loginResult.asSingle()
    }

    ///退出软件
    @discardableResult
    func logout() -> Single<Bool>{
        print("退出登录========")
        let userModel = DDUserModel()
        self.userInfo.accept(userModel)
        return Single.just(true)
    }
}
