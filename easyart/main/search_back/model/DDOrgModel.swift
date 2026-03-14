//
//  DDOrgModel.swift
//  easyart
//
//  Created by Damon on 2024/9/23.
//

import UIKit
import KakaJSON

class DDOrgModel: BaseModel {
    required override init() {}
    
    var institute_id = ""
    var photo_url = ""
    var title = ""
}

extension DDOrgModel: Convertible {
  
}
