//
//  MeSettingModel.swift
//  easyart
//
//  Created by Damon on 2024/9/24.
//

import UIKit

class MeSettingModel: BaseModel {
    var title = ""
    var des = ""
    
    init(title: String = "", des: String = "") {
        self.title = title
        self.des = des
        super.init()
    }
}
