//
//  DDRecentSearchTools.swift
//  easyart
//
//  Created by Damon on 2024/11/28.
//

import UIKit
import KakaJSON
import RxSwift
import RxCocoa

class DDRecentSearchTools: NSObject {
    private(set) lazy var searchHistoryList = BehaviorRelay<[DDRecentSearchModel]>(value: self.searchList)
    
    private override init() {
        super.init()
        self._bindView()
    }
    
    static let shared: DDRecentSearchTools = {
        let tShared = DDRecentSearchTools()
        return tShared
    }()
    
    private var searchList: [DDRecentSearchModel] {
        get {
            if let jsonString = DDCacheTools.shared.string(forKey: UserDefaultKey.recentSearch.keyValue()) {
                return jsonString.kj.modelArray(DDRecentSearchModel.self)
            }
            return [DDRecentSearchModel]()
        }
    }
}

extension DDRecentSearchTools {
    func addSearchModel(model: DDRecentSearchModel) {
        self.removeSearchModel(model: model)
        var list = self.searchHistoryList.value
        list.append(model)
        self.searchHistoryList.accept(list)
    }
    
    func removeSearchModel(model: DDRecentSearchModel) {
        var list = self.searchHistoryList.value
        list.removeAll { searchModel in
            return searchModel.type == model.type && searchModel.id == model.id
        }
        self.searchHistoryList.accept(list)
    }
}

private extension DDRecentSearchTools {
    func _bindView() {
        _ = self.searchHistoryList.subscribe(onNext: { searchList in
            let jsonString = searchList.kj.JSONString()
            DDCacheTools.shared.set(jsonString, forKey: UserDefaultKey.recentSearch.keyValue())
        })
    }
}
