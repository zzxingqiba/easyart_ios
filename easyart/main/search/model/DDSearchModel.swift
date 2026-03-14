//
//  DDSearchModel.swift
//  easyart
//
//  Created by Damon on 2024/11/21.
//

import UIKit
import KakaJSON

class DDSearchModel: NSObject {
    required override init() {}
    
    var keyword = ""
    var artist_ids = Set<Int>()
    var number_types = Set<Int>()
    var category_ids = Set<Int>()
    var min_price: Int? = nil
    var max_price: Int? = nil
    var sizeList: [DDSearchSizeRange] = []
}

extension DDSearchModel {
    func isAvailble() -> Bool {
        return !keyword.isEmpty || !artist_ids.isEmpty || !number_types.isEmpty || !category_ids.isEmpty || !sizeList.isEmpty || min_price != nil || max_price != nil
    }
    
    func reset() {
        artist_ids = Set<Int>()
        number_types = Set<Int>()
        category_ids = Set<Int>()
        min_price = nil
        max_price = nil
        sizeList = []
    }
    
    func addSizeRange(size: DDSearchSizeRange) {
        if size.id() == 4 {
            //添加的自定义类型
            self.sizeList = []
            self.sizeList.append(size)
        } else if let range = self.sizeList.first, range.id() == 4 {
            //原类型是自定义类型，则清空
            self.sizeList = []
            self.sizeList.append(size)
        } else if !self.sizeList.contains(where: { range in
            return range.id() == size.id()
        }) {
            self.sizeList.append(size)
        }
    }
    
    func removeSizeRange(size: DDSearchSizeRange) {
        if let index = self.sizeList.firstIndex(where: { range in
            return range.id() == size.id()
        }) {
            self.sizeList.remove(at: index)
        }
    }
}

extension DDSearchModel {
    func getArtistIDs() -> String {
        return self.artist_ids.map { String($0) }.joined(separator: ",")
    }
    
    func getNumberTypes() -> String {
        return self.number_types.map { String($0) }.joined(separator: ",")
    }
    
    func getCategoryIDs() -> String {
        return self.category_ids.map { String($0) }.joined(separator: ",")
    }
    
    func getSize() -> Any {
        if sizeList.isEmpty {
            return ""
        } else {
            return sizeList.map { range in
                return [range.range().0, range.range().1]
            }
        }
    }
    
    func getPriceTag() -> Int {
        var count = 0
        if let price = min_price, price > 0 {
            count = count + 1
        }
        if let price = max_price, price > 0 {
            count = count + 1
        }
        return count
    }
    
    func getSizeTag() -> Int {
        return self.sizeList.count
    }
    
    func getTotalCount() -> Int {
        return self.artist_ids.count + self.number_types.count + self.category_ids.count + self.getPriceTag() + self.getSizeTag()
    }
}

extension DDSearchModel: Convertible {
  
}
