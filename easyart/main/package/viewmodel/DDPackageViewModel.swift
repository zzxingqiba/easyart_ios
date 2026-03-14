//
//  DDPackageViewModel.swift
//  easyart
//
//  Created by Damon on 2024/11/14.
//

import Foundation
import RxRelay
import SwiftyJSON
import DDLoggerSwift

class DDPackageViewModel: NSObject {
    var width: Float = 0
    var height: Float = 0
    //选择的款式列表
    let packageConfigList = BehaviorRelay(value: [JSON]())
    let packageIndex = BehaviorRelay<Int?>(value: nil)
    //选中的样式
    let colorIndex = BehaviorRelay<Int>(value: 0)
    let paperWIndex = BehaviorRelay<Int>(value: 0)
    let borderWIndex = BehaviorRelay<Int>(value: 0)
    let styleIndex = BehaviorRelay<Int>(value: 0)
    let paddingIndex = BehaviorRelay<Int>(value: 0)
    let acrylicIndex = BehaviorRelay<Int>(value: 0)
    
    override init() {
        super.init()
        self._bindView()
        self._loadData()
    }
}

extension DDPackageViewModel {
    func showColorList(packageIndex: Int?) -> Bool {
        guard let packageIndex = packageIndex else { return false }
        let item = self.packageConfigList.value[packageIndex]
        return item["borderConfig"]["color"]["isShow"].boolValue
    }
    
    func showPaperWList(packageIndex: Int?) -> Bool {
        guard let packageIndex = packageIndex else { return false }
        let item = self.packageConfigList.value[packageIndex]
        return item["paperWConfig"]["isShow"].boolValue
    }
    
    func showBorderWList(packageIndex: Int?) -> Bool {
        guard let packageIndex = packageIndex else { return false }
        let item = self.packageConfigList.value[packageIndex]
        return item["borderConfig"]["borderW"]["isShow"].boolValue
    }
    
    func showStyleList(packageIndex: Int?) -> Bool {
        guard let packageIndex = packageIndex else { return false }
        let item = self.packageConfigList.value[packageIndex]
        return item["borderConfig"]["style"]["isShow"].boolValue
    }
    
    func showPaddingList(packageIndex: Int?) -> Bool {
        guard let packageIndex = packageIndex else { return false }
        let item = self.packageConfigList.value[packageIndex]
        return item["paddingWConfig"]["isShow"].boolValue
    }
    
    func showAcrylicList(packageIndex: Int?) -> Bool {
        guard let packageIndex = packageIndex else { return false }
        let item = self.packageConfigList.value[packageIndex]
        return item["acrylicBoardConfig"]["isShow"].boolValue
    }
}

extension DDPackageViewModel {
    func getPackageString() -> String {
        if let index = self.packageIndex.value {
            var packageString = self.packageConfigList.value[index]["title"].stringValue
            //款式
            let styleList = getStyleList(packageIndex: index)
            if self.styleIndex.value < styleList.count, self.showStyleList(packageIndex: index) {
                packageString = packageString + ", " + styleList[self.styleIndex.value]["text"].stringValue
            }
            //borderW
            let borderWList = getBorderWList(packageIndex: index)
            if self.borderWIndex.value < borderWList.count, self.showBorderWList(packageIndex: index) {
                packageString = packageString + ", " + borderWList[self.borderWIndex.value]["text"].stringValue
            }
            //颜色
            let colorList = getColorList(packageIndex: index)
            if self.colorIndex.value < colorList.count, self.showColorList(packageIndex: index) {
                packageString = packageString + ", " + colorList[self.colorIndex.value]["text"].stringValue + "Frame".localString
            }
            //卡纸
            let paperList = getPaperWList(packageIndex: index)
            if let paperW = self.getPaperW(), paperW > 0, self.paperWIndex.value < paperList.count, self.showPaperWList(packageIndex: index) {
                packageString = packageString + ", " + paperList[self.paperWIndex.value]["text"].stringValue + " " + "Cardboard".localString
            } else {
                packageString = packageString + ", " + "No cardboard".localString
            }
            //边距
            let paddingList = getPaddingList(packageIndex: index)
            if self.paddingIndex.value < paddingList.count, self.showPaddingList(packageIndex: index) {
                packageString = packageString + ", " + paddingList[self.paddingIndex.value]["text"].stringValue + " " + "Margins".localString
            }
            //亚克力
            let acrylicList = getAcrylicList(packageIndex: index)
            if self.acrylicIndex.value < acrylicList.count, self.showAcrylicList(packageIndex: index) {
                packageString = packageString + ", " + acrylicList[self.acrylicIndex.value]["text"].stringValue + " " + "Acrylic".localString
            }
            return packageString
        } else {
            return "无装裱 装裱费：0元".localString
        }
    }
}

extension DDPackageViewModel {
    func getColorList(packageIndex: Int) -> [JSON] {
        let item = self.packageConfigList.value[packageIndex]
        let list = item["borderConfig"]["color"]["list"].arrayValue
        return list
    }
    
    func getColor(packageIndex: Int, index: Int) -> UIColor? {
        let list = getColorList(packageIndex: packageIndex)
        if (list.count > index) {
            let item = list[index]
            return UIColor.dd.color(hexString: item["color"].stringValue)
        }
        return nil
    }
    
    func getColor() -> UIColor? {
        guard let index = self.packageIndex.value else { return nil }
        return self.getColor(packageIndex: index, index: self.colorIndex.value)
    }
    
    func getNormalRadiusColor() -> UIColor? {
        switch self.colorIndex.value {
        case 0:
            return UIColor.dd.color(hexValue: 0xC7C7C7)
        case 1:
            return UIColor.dd.color(hexValue: 0x939393)
        case 2:
            return UIColor.dd.color(hexValue: 0x404040)
        default:
            return UIColor.dd.color(hexValue: 0xeeeeee)
        }
        
    }
    
    func getRadiusColor() -> UIColor? {
        switch self.colorIndex.value {
        case 0:
            return UIColor.dd.color(hexValue: 0xE7E7E7)
        case 1:
            return UIColor.dd.color(hexValue: 0xE1E1E1)
        case 2:
            return UIColor.dd.color(hexValue: 0x838383)
        default:
            return UIColor.dd.color(hexValue: 0xeeeeee)
        }
        
    }
    
    func getPaperWList(packageIndex: Int) -> [JSON] {
        let item = self.packageConfigList.value[packageIndex]
        let list = item["paperWConfig"]["list"].arrayValue
        return list
    }
    
    func getPaperW(packageIndex: Int, index: Int) -> Float? {
        let list = getPaperWList(packageIndex: packageIndex)
        if (list.count > index) {
            let item = list[index]
            return item["value"].floatValue
        }
        return nil
    }
    
    func getPaperW() -> Float? {
        guard let index = self.packageIndex.value else { return nil }
        return self.getPaperW(packageIndex: index, index: self.paperWIndex.value)
    }
    
    func getBorderWList(packageIndex: Int) -> [JSON] {
        let item = self.packageConfigList.value[packageIndex]
        let list = item["borderConfig"]["borderW"]["list"].arrayValue
        return list
    }
    
    func getBorderW(packageIndex: Int, index: Int) -> Float? {
        let list = getBorderWList(packageIndex: packageIndex)
        if (list.count > index) {
            let item = list[index]
            return item["value"].floatValue
        }
        return nil
    }
    
    func getBorderW() -> Float? {
        guard let index = self.packageIndex.value else { return nil }
        return self.getBorderW(packageIndex: index, index: self.borderWIndex.value)
    }
    
    func getStyleList(packageIndex: Int) -> [JSON] {
        let item = self.packageConfigList.value[packageIndex]
        let list = item["borderConfig"]["style"]["list"].arrayValue
        return list
    }
    
    func getStyle(packageIndex: Int, index: Int) -> Int? {
        let list = getStyleList(packageIndex: packageIndex)
        if (list.count > index) {
            let item = list[index]
            return item["id"].intValue
        }
        return nil
    }
    
    func getStyle() -> Int? {
        guard let index = self.packageIndex.value else { return nil }
        return self.getStyle(packageIndex: index, index: self.styleIndex.value)
    }
    
    func getPaddingList(packageIndex: Int) -> [JSON] {
        let item = self.packageConfigList.value[packageIndex]
        let list = item["paddingWConfig"]["list"].arrayValue
        return list
    }
    
    func getPadding(packageIndex: Int, index: Int) -> Float? {
        let list = getPaddingList(packageIndex: packageIndex)
        if (list.count > index) {
            let item = list[index]
            return item["value"].floatValue
        }
        return nil
    }
    
    func getPadding() -> Float? {
        guard let index = self.packageIndex.value else { return nil }
        return self.getPadding(packageIndex: index, index: self.paddingIndex.value)
    }
    
    func getAcrylicList(packageIndex: Int) -> [JSON] {
        let item = self.packageConfigList.value[packageIndex]
        let list = item["acrylicBoardConfig"]["list"].arrayValue
        return list
    }
    
    func getAcrylic(packageIndex: Int, index: Int) -> Bool {
        let list = getAcrylicList(packageIndex: packageIndex)
        if (list.count > index) {
            let item = list[index]
            return item["id"].intValue == 1
        }
        return false
    }
    
    func getAcrylic() -> Bool {
        guard let index = self.packageIndex.value else { return false }
        return self.getAcrylic(packageIndex: index, index: self.acrylicIndex.value)
    }
}

//价格
extension DDPackageViewModel {
    func getBGBoardPrice(packageIndex: Int) -> Float {
        let item = self.packageConfigList.value[packageIndex]
        let list = item["bgBoardConfig"]["list"].arrayValue
        return list.first?["price"].floatValue ?? 0
    }
    
    func getPaperPrice(packageIndex: Int, index: Int) -> Float {
        let list = getPaperWList(packageIndex: packageIndex)
        if (list.count > index) {
            let item = list[index]
            return item["price"].floatValue
        }
        return 0
    }
    
    func getPaperPriceID() -> Int {
        let packageIndex = self.packageIndex.value ?? 0
        let packageID = self.packageConfigList.value[packageIndex]["id"].intValue
        if packageID == 1 || packageID == 2 {
            let list = getPaperWList(packageIndex: packageIndex)
            if (list.count > self.paperWIndex.value) {
                let item = list[self.paperWIndex.value]
                return item["id"].intValue
            }
        } else if packageID == 3 || packageID == 4 {
            let list = getPaperWList(packageIndex: packageIndex)
            if (list.count > self.paddingIndex.value) {
                let item = list[self.paddingIndex.value]
                return item["id"].intValue
            }
        }
        return 0
    }
    
    func getBorderPrice(packageIndex: Int, colorIndex: Int, index: Int) -> Float {
        let item = self.packageConfigList.value[packageIndex]
        let list = item["borderConfig"]["priceList"].arrayValue
        return list[colorIndex][index]["price"].floatValue
    }
    
    func getBorderPriceID() -> Int {
        let packageIndex = self.packageIndex.value ?? 0
        let item = self.packageConfigList.value[packageIndex]
        let list = item["borderConfig"]["priceList"].arrayValue
        return list[self.colorIndex.value][self.borderWIndex.value]["id"].intValue
    }
    
    func getPaddingID() -> Int {
        let packageIndex = self.packageIndex.value ?? 0
        let list = getPaddingList(packageIndex: packageIndex)
        if (list.count > self.paddingIndex.value) {
            let item = list[self.paddingIndex.value]
            return item["id"].intValue
        }
        return 0
    }
    
    func getStylePrice(packageIndex: Int, styleIndex: Int, isAddtion: Bool) -> Float {
        let item = self.packageConfigList.value[packageIndex]
        let list = item["borderConfig"]["style"]["list"].arrayValue
        if isAddtion{
            return list[styleIndex]["price2"].floatValue
        } else {
            return list[styleIndex]["price"].floatValue
        }
        
    }
    
    func getAcrylicPrice(packageIndex: Int, index: Int) -> Float {
        let list = getAcrylicList(packageIndex: packageIndex)
        if (list.count > index) {
            let item = list[index]
            return item["price"].floatValue
        }
        return 0
    }
    
    func getTotalPrice() -> String {
        guard let index = self.packageIndex.value else { return "0" }
        let packageID = self.packageConfigList.value[index]["id"].intValue
        //单位米
        let pictureW = self.width * 0.01
        let pictureH = self.height * 0.01
        //周长
        var perimeter: Float = 0
        //面积
        var area: Float = 0
        //卡纸价格
        var paperPrice: Float = 0
        if packageID == 1 {
            //面积一律预留0.01
            let totalPaperW = (self.getPaperW() ?? 0) * 2 * 0.01
            area = (pictureW + Float(totalPaperW) + 0.01) * (pictureH + Float(totalPaperW) + 0.01)
            paperPrice = area * self.getPaperPrice(packageIndex: index, index: self.paperWIndex.value)
        } else if packageID == 2 {
            //算面积，选卡纸预留0.01，且面积分别和1对比取大的
            let totalPaperW = (self.getPaperW() ?? 0) * 2 * 0.01
            area = max(1, pictureW * pictureH)
            if totalPaperW > 0 {
                area = max(1, (pictureW + Float(totalPaperW) + 0.01) * (pictureH + Float(totalPaperW) + 0.01))
            }
            paperPrice = area * self.getPaperPrice(packageIndex: index, index: self.paperWIndex.value)
        } else if packageID == 3 || packageID == 4 {
            //算面积，预留0.05，且面积和1对比取大的
            let totalPaperW = (self.getPadding() ?? 0) * 2 * 0.01
            area = max(1, pictureW * pictureH)
            if totalPaperW > 0 {
                area = max(1, (pictureW + Float(totalPaperW) + 0.05) * (pictureH + Float(totalPaperW) + 0.05))
            }
            //边距大于1时才收卡纸费用
            if let padding = self.getPadding(), padding > 1 {
                paperPrice = area * self.getPaperPrice(packageIndex: index, index: self.paddingIndex.value)
            }
        }
        
        //border框价格
        var borderPrice: Float = 0
        if packageID == 1 {
            //按周长，预留0.03
            let addPaperW: Float = (self.getPaperW() ?? 0) * 2 * 0.01
            perimeter = (pictureW + Float(addPaperW) + 0.03 + pictureH + Float(addPaperW) + 0.03) * 2
            borderPrice = perimeter * self.getBorderPrice(packageIndex: index, colorIndex: self.colorIndex.value, index: self.borderWIndex.value)
        } else if packageID == 2 {
            //按面积
            let price = self.getBorderPrice(packageIndex: index, colorIndex: self.colorIndex.value, index: self.borderWIndex.value)
            borderPrice = area * price
        } else if packageID == 3 || packageID == 4 {
            //按周长，预留0.03，且周长和1对比取大的
            let addPaperW: Float = (self.getPadding() ?? 0) * 2 * 0.01
            perimeter = max(1, (pictureW + Float(addPaperW) + 0.03 + pictureH + Float(addPaperW) + 0.03) * 2)
            borderPrice = perimeter * self.getBorderPrice(packageIndex: index, colorIndex: self.colorIndex.value, index: self.borderWIndex.value)
        }
        
        //亚克力板
        var acrylicPrice: Float = 0
        var acryArea: Float = area
        if self.getAcrylic() {
            if packageID == 1 {
                //按面积
                acrylicPrice = acryArea * self.getAcrylicPrice(packageIndex: index, index: self.acrylicIndex.value)
            } else if packageID == 2 {
                //按面积
                acrylicPrice = acryArea * self.getAcrylicPrice(packageIndex: index, index: self.acrylicIndex.value)
            } else if packageID == 3 || packageID == 4 {
                //算面积，选卡纸预留0.01，且面积和1对比取大的
                let totalPaperW = (self.getPadding() ?? 0) * 2 * 0.01
                acryArea = max(1, pictureW * pictureH)
                if totalPaperW > 0 {
                    acryArea = max(1, (pictureW + Float(totalPaperW) + 0.01) * (pictureH + Float(totalPaperW) + 0.01))
                }
                acrylicPrice = acryArea * self.getAcrylicPrice(packageIndex: index, index: self.acrylicIndex.value)
            }
        }
        
        //样式价格
        if let style = self.getStyle() {
            if packageID == 5 {
                borderPrice = pictureW * pictureH * self.getStylePrice(packageIndex: index, styleIndex: self.styleIndex.value, isAddtion: false)
                if style == 32 {
                    //铝塑板
                    let styleArea = (pictureW * 0.85 + pictureH * 0.85) * 2
                    let stylePrice = styleArea * self.self.getStylePrice(packageIndex: index, styleIndex: self.styleIndex.value, isAddtion: true)
                    borderPrice = borderPrice + stylePrice
                    if borderPrice < 200 {
                        //铝塑板装裱总价不足200元，按200计算
                        borderPrice = 200
                    }
                } else if style == 33 {
                    //三明治
                    if borderPrice <= 1000 {
                        borderPrice = borderPrice + 150
                    } else if borderPrice > 1000 && borderPrice <= 1600 {
                        borderPrice = borderPrice + 100
                    }
                }
            }
        }
        
        
        //背景板价格
        var bgBoardPrice: Float = 0
        if packageID == 1 {
            //按亚克力面积
            bgBoardPrice = acryArea * self.getBGBoardPrice(packageIndex: index)
        } else if packageID == 2 {
            bgBoardPrice = acryArea * self.getBGBoardPrice(packageIndex: index)
        } else if packageID == 3 || packageID == 4 {
            bgBoardPrice = acryArea * self.getBGBoardPrice(packageIndex: index)
        }
            
        return String(format: "%0.1f", paperPrice + borderPrice + acrylicPrice + bgBoardPrice)
    }
}

extension DDPackageViewModel {
    func _bindView() {
        _ = self.packageIndex.subscribe(onNext: { [weak self] index in
            guard let self = self else { return }
            self.colorIndex.accept(0)
            self.paperWIndex.accept(0)
            self.borderWIndex.accept(0)
            self.styleIndex.accept(0)
            self.paddingIndex.accept(0)
            self.acrylicIndex.accept(0)
        })
        
        
    }
    
    func _loadData() {
        _ = DDServerConfigTools.shared.configInfo.subscribe(onNext: { [weak self] json in
            guard let self = self else { return }
            let priceConfig = json["priceConfig"].arrayValue
            self.packageConfigList.accept(priceConfig)
            self.packageIndex.accept(nil)
        })
    }
    
    
}
