//
//  DDSearchAuthorModel.swift
//  easyart
//
//  Created by Damon on 2024/10/24.
//

import UIKit
import KakaJSON

class DDSearchAuthorModel: BaseModel {
    required override init() {}
    
    var id = ""
    var category = ""
    var head = ""
    var jigou_id = ""
    var name = ""
    var status: Int = 0
}

extension DDSearchAuthorModel: Convertible {
  
}

class DDSearchAuthorListModel: BaseModel {
    required override init() {}
    
    var name = ""
    var list = [DDSearchAuthorModel]()
}

extension DDSearchAuthorListModel: Convertible {
  
}
