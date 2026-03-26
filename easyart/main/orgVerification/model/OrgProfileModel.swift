//
//  Untitled.swift
//  easyart
//
//  Created by 崭新的旧刀 on 2026/3/24.
//

import Foundation
import KakaJSON

class OrgFileModel: Convertible {
    required init() {}
    var filename: String = ""
    var fileurl: String = ""
}

class OrgProfileModel {
    var name: String = ""
    var idNumber: String = ""
    var mobile: String = ""
    var idFile = OrgFileModel()
    var otherIDFile = OrgFileModel()
    var country: AddressCountryInfo = .init()
    var address: String = ""
    var bankInfo = OrgBankInfo()
}

extension OrgProfileModel{
    func isAvailable() -> Bool {
        return String.isAvailable(name) && String.isAvailable(idNumber) && String.isAvailable(idFile.filename) && String.isAvailable(mobile) && String.isAvailable(country.id) && String.isAvailable(address) && self.bankInfo.isAvailable()
    }
    func update(model: UserRoleDetail) {
        self.name = model.real_name
        self.idNumber = model.id_number
        self.idFile.fileurl = model.passport_info.fileurl
        self.idFile.filename = model.passport_info.filename
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

/// 银行信息
class OrgBankInfo {
    var name: String = ""
    var bankType: OrgBankInfoType = .init()
    var swiftCode: String = ""
    var number: String = ""

    func isAvailable() -> Bool {
        return String.isAvailable(name) && String.isAvailable(bankType.id) && String.isAvailable(swiftCode) && String.isAvailable(number)
    }
}

class OrgBankInfoType: Convertible {
    required init() {}

    var id: String = ""
    var name: String = ""
}
