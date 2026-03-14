//
//  FollowMessageModel.swift
//  easyart
//
//  Created by Damon on 2025/6/20.
//

import UIKit
import KakaJSON

class FollowMessageModel: NSObject, Convertible {
    required override init() {}
    var goods_num: Int = 0
    var id: Int = 0
    var date_desc = ""
    var photo_list = [String]()
    var artist_id = ""
    var desc = ""
    var is_read: Bool = false
}
