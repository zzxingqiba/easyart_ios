//
//  DDError.swift
//  Menses
//
//  Created by Damon on 2020/7/1.
//  Copyright © 2020 Damon. All rights reserved.
//

import UIKit

struct DDErrorProvider {

    static func localizedDescription(_ error: Error) -> String {
        var errorCode = -999
        var errorMsg = ""

        if error is DDAPIResponseError {
            switch error as! DDAPIResponseError {
                case DDAPIResponseError.badStatusCode(code: let code):
                    errorCode = code
                    errorMsg = "网络状态出错，请稍后再试"
                case DDAPIResponseError.badResponseCode(response: let response):
                    errorCode = response.ok
                    errorMsg = response.msg
                case DDAPIResponseError.badResponseContent:
                    errorMsg = "返回数据结构出错，请检查网络稍后重试"
                case DDAPIResponseError.authorizationExpired:
                    errorMsg = "用户信息失效或者登陆过期"
            }
        } else if error is DDError {
            switch error as! DDError {
                case .string(let string):
                    errorMsg = string
            }
        } else {
            errorMsg = error.localizedDescription
        }
        return "\(errorMsg)"
    }
}

enum DDError: Error{
    case string(_ string: String)
}
