//
//  DDAPIType.swift
//  Menses
//
//  Created by Damon on 2020/9/7.
//  Copyright © 2020 Damon. All rights reserved.
//

import Foundation
import Moya
import DDUtils

enum DDAPIType {
    case request(urlStr: String, data: [String: Any], method: Moya.Method = .post)
    case requestGeneral(urlStr: String, data: [String: Any], method: Moya.Method = .post)
    case upload(urlStr: String, params: [String: Any], data: Data, key: String, fileFormat: String = "png")
}

extension DDAPIType: TargetType {
    var baseURL: URL {
        switch self {
            case .requestGeneral(let urlStr, _, _):
                return URL(string: urlStr)!
            default:
                if APP_DEBUG {
                    return URL(string: "https://dev-xapi.easyartonline.com/")!
                } else {
                    return URL(string: "https://xapi.easyartonline.com/")!
                }
        }

    }

    var path: String {
        switch self {
            case .request(let urlStr, _, _):
                return urlStr
            case .upload(let urlStr, _ ,  _, _, _):
                return urlStr
            default:
                return ""
        }
    }

    var method: Moya.Method {
        switch self {
            case .request(_, _, let method):
                return method
            case .requestGeneral(_, _, let method):
                return method
            case .upload(_ , _ ,  _, _, _):
                return .post
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
            case .request(_, let requestData, _):
                return .requestParameters(parameters: requestData, encoding: URLEncoding.default)
            case .upload(_ , let parameters, let data, let key, let fileFormat):
                let formDataArray: NSMutableArray = NSMutableArray()
                //根据当前时间设置图片上传时候的名字
                let date:Date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd-HH:mm:ss"
                var dateStr:String = formatter.string(from: date as Date)
                dateStr = dateStr.appendingFormat(".\(fileFormat)")

                let formData = MultipartFormData(provider: .data(data), name: key, fileName: dateStr)
                formDataArray.add(formData)
                return .uploadCompositeMultipart(formDataArray as? [MultipartFormData] ?? [MultipartFormData](), urlParameters: parameters)
            case .requestGeneral(_,  let requestData, _):
                return .requestParameters(parameters: requestData, encoding: URLEncoding.default)
        }

    }

    var headers: [String : String]? {
        let userID = DDUserTools.shared.userInfo.value.user_id
        let loginAccessToken = DDUserTools.shared.userInfo.value.login_access_token

        let timeStmp: String = "\(Int(Date().timeIntervalSince1970))"
        let combineStr: String = "\(userID)" + APP_REQUEST_Secret + timeStmp
        let signStr: String = combineStr.dd.hashString(hashType: .md5) ?? ""

        let completeStr: String = "ios|" +  DDUtils.shared.getIOSVersionString() + "|" + APP_VERSION + "|" + APP_NAME + "|" + "3" + "|" + "\(UIScreenWidth)" + "|" + "\(UIScreenHeight)" + "|" + "0" + "|" + "\(userID)" + "|" + timeStmp + "|" + signStr + "|" + loginAccessToken + "|" +  DDUtils.shared.getSystemHardware() + "|" + DDConfigTools.shared.getLanguage() + "|" + "CNY"
        return ["ua": completeStr, "Content-type": "application/x-www-form-urlencoded"]
    }
}
