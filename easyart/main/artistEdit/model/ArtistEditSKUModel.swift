//
//  ArtistEditSKUModel.swift
//  easyart
//
//  Created by Damon on 2025/2/5.
//

import UIKit
import SwiftyJSON

enum ArtistNumberType: Int {
    case unique = 0     //唯一
    case limit = 1      //有限
    case open = 11      //无限量
    case pp = 2
    case ap = 3
}

extension ArtistNumberType {
    func title() -> String {
        switch self {
        case .unique:
            return "Unique".localString
        case .limit:
            return "Limited Edition".localString
        case .open:
            return "Open Edition".localString
        case .pp:
            return "PP".localString
        case .ap:
            return "AP".localString
        }
    }
}

class ArtistEditSKUModel: NSObject {
    required override init() {}
    var id: Int = 0
    var workPrice: Int = 0
    var meterialIDList = Set<Int>()
    var customMeterial = ArtistEditCustomMeterialModel()
    var hasSignature = true
    var year: Int? = nil
    var width: Int = 0
    var height: Int = 0
    var length: Int = 0
    var weight: Int = 0
    var width_mount: Int = 0    //装潢
    var height_mount: Int = 0
    var length_mount: Int = 0
    var frameType: ArtistEditFrameType? = nil
    var realStockNumber: Int? = nil //库存
    var stockNumber: Int = 0  //版号总数
    var numberType: ArtistNumberType? = nil  //编号类型 (0:Unique独版 1:有编号 2:PP 3:AP 11:无限量)
    var numberList: [String] = []   //版号列表，数量和库存一致
}

extension ArtistEditSKUModel {
    func copySKU() -> ArtistEditSKUModel {
        let sku = ArtistEditSKUModel()
        sku.workPrice = self.workPrice
        sku.meterialIDList = Set(self.meterialIDList)
        sku.customMeterial.isSelected = self.customMeterial.isSelected
        sku.customMeterial.title = self.customMeterial.title
        sku.hasSignature = self.hasSignature
        sku.year = self.year
        sku.width = self.width
        sku.height = self.height
        sku.length = self.length
        sku.width_mount = self.width_mount
        sku.height_mount = self.height_mount
        sku.length_mount = self.length_mount
        sku.weight = self.weight
        sku.frameType = self.frameType
        sku.stockNumber = self.stockNumber
        sku.realStockNumber = self.realStockNumber
        sku.numberType = self.numberType
        sku.numberList = Array(self.numberList)
        return sku
    }
}

extension ArtistEditSKUModel {
    func resetNumberList() {
        self.numberList = []
        if let realStockNumber = self.realStockNumber {
            self.stockNumber = realStockNumber
            for i in 0..<realStockNumber {
                self.numberList.append(String(format: "%03d", i + 1))
            }
        }
    }
    
    func meterialString() -> String? {
        if self.meterialIDList.isEmpty && !self.customMeterial.isSelected {
            return nil
        }
        var text = self.meterialIDList.compactMap { id in
            if let json = DDServerConfigTools.shared.getMaterial(id: id) {
                return json["title"].stringValue
            }
            return nil
        }.joined(separator: ",")
        if self.customMeterial.isSelected {
            if text.isEmpty {
                text = self.customMeterial.title
            } else {
                text = text + "," + self.customMeterial.title
            }
        }
        return text
    }
    
    func isAvailable() -> Bool {
        return workPrice > 0
        && String.isAvailable(self.meterialString())
        && self.year != nil
        && width > 0
        && length > 0
        && frameType != nil
        && numberType != nil
    }
    
    func update(json: JSON) {
        self.id = json["sku_id"].intValue
        self.weight = json["weight"].intValue
        self.workPrice = json["pay_price"].intValue
        self.meterialIDList = Set(json["material_ids"].stringValue.components(separatedBy: ",").compactMap({ text in
            return Int(text)
        }))
        if String.isAvailable(json["material"].stringValue) {
            self.customMeterial.isSelected = true
            self.customMeterial.title = json["material"].stringValue
        }
        self.hasSignature = json["is_number"].boolValue
        self.year = json["years"].intValue
        self.width = json["width"].intValue
        self.height = json["height"].intValue
        self.length = json["length"].intValue
        self.width_mount = json["width_mount"].intValue
        self.height_mount = json["height_mount"].intValue
        self.length_mount = json["length_mount"].intValue
        self.frameType = ArtistEditFrameType(rawValue: json["mount_type"].intValue)
        self.stockNumber = json["stock_num"].intValue
        self.realStockNumber = json["real_stock_num"].intValue
        self.numberType = ArtistNumberType(rawValue: json["number_type"].intValue)
        self.numberList = json["number_list"].arrayValue.map({ number in
            return number["number_val"].stringValue
        })
    }
}
