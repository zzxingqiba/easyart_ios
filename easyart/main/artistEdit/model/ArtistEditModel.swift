//
//  ArtistEditModel.swift
//  easyart
//
//  Created by Damon on 2025/1/16.
//

import UIKit
import SwiftyJSON
import KakaJSON

class ArtistEditCustomMeterialModel {
    var isSelected = false
    var title = ""
}

enum ArtistEditFrameType: Int {
    case noInclude = 1      //不包含装裱（平台提供）
    case include = 2        //已装裱
    case none = 3
}

extension ArtistEditFrameType {
    func title() -> String {
        switch self {
        case .include:
            return "Frame included".localString
        case .noInclude:
            return "Not included（Platform provides framing services.）".localString
        case .none:
            return "Not applicable".localString
        }
    }
}

class ArtistEditModel: NSObject {
    required override init() {}
    var id: Int? = nil
    var primaryImage = SettleInFileModel()
    var imageList = [SettleInFileModel]()
    var name = ""
    var intro = ""
    var categoryID: Int = 0
    var show_status: Int = 10
    var status: Int = 0
    //SKU
    var skuList = [ArtistEditSKUModel]()
}

extension ArtistEditModel {
    func firstSKU() -> ArtistEditSKUModel {
        if self.skuList.isEmpty {
            self.skuList.append(ArtistEditSKUModel())
        }
        return self.skuList.first!
    }
    
    func isAvailable() -> Bool {
        return String.isAvailable(self.name) && categoryID > 0 && !primaryImage.filename.isEmpty && !imageList.isEmpty && !skuList.isEmpty
    }
    
    func update(json: JSON) {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.intro = json["intro"].stringValue
        self.categoryID = json["category_id"].intValue
        self.primaryImage = json["photo_info"].dictionaryObject?.kj.model(SettleInFileModel.self) ?? SettleInFileModel()
        self.imageList = json["detail_pic_list"].arrayObject?.kj.modelArray(SettleInFileModel.self) ?? []
        self.show_status = json["show_status"].intValue
        self.status = json["status"].intValue
    }
}
