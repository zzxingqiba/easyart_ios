//
//  MineArtistModel.swift
//  easyart
//
//  Created by 崭新的旧刀 on 2026/3/20.
//

import UIKit
import KakaJSON

class MineArtistModel: BaseModel, Convertible {
    required override init() { }
    var id: Int = 0
    var show_status: Int = 0    //作品显示状态 2: 已售 5:待审核,6:审核拒绝,10:草稿,其他正常
    var status: Int = 0     //1已下架 5未发布
    var photo_url = ""
    var name = ""
    var category_name = ""
    var pay_price = ""
    var price = ""
    var is_collect = false
    var collect_num: Int = 0
}

