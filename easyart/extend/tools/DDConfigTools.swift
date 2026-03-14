//
//  DDConfigTools.swift
//  HiTalk
//
//  Created by Damon on 2024/5/30.
//

import UIKit
import RxRelay
import KakaJSON
import SwiftyJSON

class UserConfig: NSObject, Convertible {
    required override init() {}
    var language: String?       //用户语言
}


class DDConfigTools: NSObject {
    private(set) lazy var userConfigInfo = BehaviorRelay<UserConfig>(value: self.userConfig)
    private var languages: [String: JSON] = [:]
    private let languageList  = ["en"]
    //不写缓存
    private var userConfig: UserConfig = UserConfig()
    
    var userUUID: String {
        if let uuid = DDCacheTools.shared.string(forKey: UserDefaultKey.userUUID.keyValue()) {
            return uuid
        } else {
            let uuid = UUID().uuidString
            DDCacheTools.shared.set(uuid, forKey: UserDefaultKey.userUUID.keyValue())
            return uuid
        }
    }
    
    private override init() {
        super.init()
        self._bindView()
    }
    
    static let shared: DDConfigTools = {
        let tShared = DDConfigTools()
        return tShared
    }()
}

extension DDConfigTools {
    func setLanguage(_ language: String) {
        let lang = languageFilter(language: language)
        let config = self.userConfigInfo.value
        config.language = lang
        self.userConfigInfo.accept(config)
    }
    
    func getLanguage() -> String {
        var language = self.userConfig.language ?? Locale.preferredLanguages.first ?? "en"
        language = languageFilter(language: language)
        //写入缓存
        self.userConfig.language = language
        self.userConfigInfo.accept(self.userConfig)
        return language
    }
    
    func languageFilter(language: String) -> String {
        var lang = "en"
        let _lang = language.lowercased()
        if !_lang.isEmpty {
            if (_lang == "zh-hant" || _lang == "zh-tw" || _lang == "zh-hk" || _lang == "zh-mo") {
                lang = "zh-Hant"
            } else {
                let arr = _lang.components(separatedBy: "-")
                lang = arr[0]
            }
        }
        if (self.languageList.contains(lang)) {
            return lang
        } else {
            return "en"
        }
    }
    
    func languageJSON(language: String) -> JSON? {
        if let json = self.languages[language] {
            return json
        } else if let jsonURL = Bundle.main.url(forResource: "\(language).json", withExtension: nil), let data = try? Data(contentsOf: jsonURL), let json = try? JSON(data: data) {
            self.languages[language] = json
            return json
        }
        return nil
    }
}

private extension DDConfigTools {
    func _bindView() {
//        _ = self.userConfigInfo.subscribe(onNext: { config in
//            let jsonString = config.kj.JSONString()
//            DDCacheTools.shared.set(jsonString, forKey: UserDefaultKey.userConfig.rawValue)
//        })
    }
}

