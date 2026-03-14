//
//  SettleInProfileModel.swift
//  easyart
//
//  Created by Damon on 2024/12/17.
//

import Foundation
import KakaJSON

class SettleInFileModel: Convertible {
    required init() {}
    var filename: String = ""
    var fileurl: String = ""
}

class SettleInProfileModel {
    var name: String = ""
    var IDNumber = ""
    var IDFile = SettleInFileModel()
    var otherIDFile = SettleInFileModel()
    var mobile: String = ""
    var country: AddressCountryInfo = AddressCountryInfo()
    var address: String = ""
    var bankInfo = SettleBankInfo()
}

extension SettleInProfileModel {
    func isAvailable() -> Bool {
        return String.isAvailable(name) && String.isAvailable(IDNumber) && String.isAvailable(IDFile.filename) && String.isAvailable(mobile) && String.isAvailable(country.id) && String.isAvailable(address) && self.bankInfo.isAvailable()
    }
    
    func update(model: UserRoleDetail) {
        self.name = model.real_name
        self.IDNumber = model.id_number
        self.IDFile.fileurl = model.passport_info.fileurl
        self.IDFile.filename = model.passport_info.filename
        self.otherIDFile.fileurl = model.other_passport_info.fileurl
        self.otherIDFile.filename = model.other_passport_info.filename
        self.mobile = model.phone
        self.country.id = model.country_id
        self.country.name = model.country_name
        self.address = model.address
        self.bankInfo.name = model.bankInfo.account_name
        self.bankInfo.bankType.id = model.bankInfo.account_type
        self.bankInfo.bankType.name = model.bankInfo.account_type_name
        self.bankInfo.swiftCode = model.bankInfo.swift_code
        self.bankInfo.number = model.bankInfo.account_number
    }
}

//银行信息
class SettleBankInfo {
    var name: String = ""
    var bankType: SettleBankInfoType = SettleBankInfoType()
    var swiftCode: String = ""
    var number: String = ""
    
    func isAvailable() -> Bool {
        return String.isAvailable(name) && String.isAvailable(bankType.id) && String.isAvailable(swiftCode) && String.isAvailable(number)
    }
}

class SettleBankInfoType: Convertible {
    required init() {}
    
    var id: String = ""
    var name: String = ""
}
