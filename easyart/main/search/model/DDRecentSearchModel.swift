//
//  DDRecentSearchModel.swift
//  easyart
//
//  Created by Damon on 2024/11/21.
//

import UIKit
import KakaJSON

enum RecentSearchModelType: Int, ConvertibleEnum {
    case author = 1    //作者
    case goods = 2     //商品
}

class DDRecentSearchModel: NSObject {
    required override init() {}
    var type: RecentSearchModelType = .author
    var id: Int = 0
    var image: String = ""
    var title: String = ""
    var des: String = ""
}

extension DDRecentSearchModel: Convertible {
  
}

