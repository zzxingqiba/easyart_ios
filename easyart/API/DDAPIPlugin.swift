//
//  DDAPIPlugin.swift
//  Menses
//
//  Created by Damon on 2020/9/7.
//  Copyright © 2020 Damon. All rights reserved.
//

import Foundation
import Moya
import DDLoggerSwift
import KakaJSON

class DDAPIPlugin: PluginType {
    func willSend(_ request: RequestType, target: TargetType) {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }

    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        switch result {
            case .success(let response):
                if target.path == "" {
                    printLog("请求数据返回path:\(target.baseURL)\(target.path)")
                    print(response)
                    return
                }
                //返回的code有问题
                do {
                    _ = try response.filterSuccessfulStatusCodes()
                } catch {
                    let errorMessage = "Status Code错误. path: \(target.path), headers: \(String(describing: target.headers)), request: \(target.task), response: \(response)"
                    printError(errorMessage)
                }

                // Response数据格式错误，无法parse
                guard let jsonResponse = try? response.mapJSON() as? [String : AnyObject] else {
                    var errorMessage = "数据格式错误. path: \(target.path), headers: \(String(describing: target.headers)), request: \(target.task), response: "
                    if let string = try? response.mapString() {
                        errorMessage = errorMessage + string
                    } else {
                        errorMessage = errorMessage + "\(response)"
                    }
                    printError(errorMessage)
                    return
                }
                let responseModel = jsonResponse.kj.model(DDAPIResponse.self)
                if responseModel.ok != 1 {
                    let errorMessage = "请求返回状态错误. path:\(target.baseURL)\(target.path), headers: \(String(describing: target.headers)), request: \(target.task), response: \(responseModel)"
                    printError(errorMessage)
                } else {
                    let prettyData = try! JSONSerialization.data(withJSONObject: jsonResponse, options: .prettyPrinted)
                    let info = String(data: prettyData, encoding: .utf8)!.dd.unicodeDecode()
                    printInfo("Successful response. path: \(target.path), request: \(target.task), response: \(info)")
                }
            case .failure(let error):
                let errorMessage = "请求出现其他错误. path: \(target.path), headers: \(String(describing: target.headers)), request: \(target.task), response: \(error)"
                printError(errorMessage)
                break
        }

    }
}
