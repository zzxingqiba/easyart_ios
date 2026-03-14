//
//  MessageModel.swift
//  easyart
//
//  Created by Damon on 2025/6/20.
//

import UIKit
import KakaJSON

class MessageModel: NSObject, Convertible {
    required override init() {}
    var content = ""
    var id: Int = 0
    var url_type: Int = 0
    var msg_type: Int = 0
    var create_time = ""
    var is_read: Bool = false
    var url_param = MessageUrlParam()
}

struct MessageUrlParam: Convertible {
    var role_type: Int = 0
    var status: Int = 0
    var is_sign: Bool = false
    var role_id = ""
    var remark = ""
    var order_id = ""
    var goods_id = ""
}
