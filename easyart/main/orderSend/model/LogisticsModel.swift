//
//  LogisticsModel.swift
//  easyart
//
//  Created by Damon on 2025/6/24.
//

import UIKit

enum LogisticsType {
    case shunfeng   //顺丰
    case debang     //德邦
    case ups
}

extension LogisticsType {
    func title() -> String {
        switch self {
        case .shunfeng:
            return "SF"
        case .debang:
            return "DHL"
        case .ups:
            return "UPS"
        }
    }
}

class LogisticsModel: NSObject {
    var type: LogisticsType? = nil
    var number = ""
    
    func isAvailable() -> Bool {
        return type != nil && String.isAvailable(self.number)
    }
}
