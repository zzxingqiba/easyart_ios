//
//  ArtModel.swift
//  easyart
//
//  Created by Damon on 2024/9/11.
//

import UIKit
import KakaJSON

class ArtModel: BaseModel {
    required override init() {}
    
    var ant_chain = false
    var artist_id = ""
    var artist_name = ""
    var collect_num: Int = 0
    var goods_id = ""
    var is_collect = false
    var is_not_sell = false
    var is_pg = false
    var jigou_id = ""
    var name = ""
    var pay_price: String = ""
    var photo_url = ""
    var price: String = ""
    var publish_err = ""
    var show_status: Int = 2
    var status = "1"
}

extension ArtModel: Convertible {
  
}
