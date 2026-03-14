//
//  DDAPIResponse.swift
//  Menses
//
//  Created by Damon on 2020/9/7.
//  Copyright © 2020 Damon. All rights reserved.
//

import Foundation
import KakaJSON

struct DDAPIResponse: Convertible {
    var ok: Int = -999
    var msg = ""
    var data: AnyObject = [String: Any]() as AnyObject
}

struct DDAPIProgressResponse: Convertible {
    var ok: Int = -999
    var msg = ""
    var data: AnyObject = [String: Any]() as AnyObject
    var progress: Double = 0
    var completed = false
}

enum DDAPIResponseError: Error {
    case badStatusCode(code: Int)                   //网络系统请求返回状态出粗
    case badResponseCode(response: DDAPIResponse)   //服务器返回ok值状态出错
    case badResponseContent                         //服务器返回内容结构出错
    case authorizationExpired                       //授权过期
}

