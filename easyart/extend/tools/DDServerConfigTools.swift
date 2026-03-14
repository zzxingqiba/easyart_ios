//
//  DDServerConfigTools.swift
//  easyart
//
//  Created by Damon on 2024/9/10.
//

import UIKit
import SwiftyJSON
import RxRelay
import RxSwift
import RxCocoa


class DDServerConfigTools: NSObject {
    let configInfo = BehaviorRelay<JSON>(value: JSON())
    
    static let shared: DDServerConfigTools = {
        let tShared = DDServerConfigTools()
        return tShared
    }()
    
    private override init() {
        super.init()
    }
}

extension DDServerConfigTools {
    @discardableResult
    func updateConfig() -> Single<JSON> {
        //已经登录并且有用户id，直接刷新数据
        return DDAPI.shared.request("config/base", autoShowError: false).flatMap { [weak self] (response) -> Single<JSON> in
            guard response.ok == 1, let self = self else { return Single.error(DDAPIResponseError.badResponseCode(response: response))}
            guard let data = response.data as? [String: AnyObject] else { return Single.error(DDAPIResponseError.badResponseContent) }
            let json = JSON(data)
            self.configInfo.accept(json)
            return Single.just(json)
        }
    }
    
    
    //获取分类
    func getCategory(id: Int) -> JSON? {
        let numberList = self.configInfo.value["category_list"].arrayValue
        return numberList.first { model in
            return id == model["id"].intValue
        }
    }
    
    //获取材质
    func getMaterial(id: Int) -> JSON? {
        let numberList = self.configInfo.value["material_list"].arrayValue
        return numberList.first { model in
            return id == model["id"].intValue
        }
    }
}
