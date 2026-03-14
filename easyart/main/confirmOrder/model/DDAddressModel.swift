//
//  DDAddressModel.swift
//  easyart
//
//  Created by Damon on 2024/9/19.
//

import UIKit
import KakaJSON

class DDAddressModel: BaseModel {
    required override init() {}
    
    var id: String = ""
    var consignee = ""
    var surname = ""
    var phone_number = ""
    var country_id = ""
    var country_name = ""
    var province = ""
    var city = ""
    var area = ""
    var full_address = ""
    var zip_code = ""
    var is_default: Bool = false
}

extension DDAddressModel: Convertible {
  
}

extension DDAddressModel {
    func getName() -> String {
        return consignee + " " + surname
    }
    
    func getFullAddress() -> String {
        return country_name + " " + province + "\n" + city + " " + area + " " + full_address
    }
}
