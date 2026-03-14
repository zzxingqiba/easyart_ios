//
//  DDPlaceOrderModel.swift
//  easyart
//
//  Created by Damon on 2024/9/19.
//

import UIKit
import SwiftyJSON

class DDPlaceOrderModel: BaseModel {
    var goodsID = ""
    var skuInfo = JSON()
    var numberID: String?
    var numberVal: Int?
    var packageViewModel: DDPackageViewModel
    
    init(goodsID: String, packageViewModel: DDPackageViewModel) {
        self.goodsID = goodsID
        self.packageViewModel = packageViewModel
        super.init()
    }
}
