//
//  DDCacheTools.swift
//  Menses
//
//  Created by Damon on 2020/8/21.
//  Copyright © 2020 Damon. All rights reserved.
//

import UIKit
import MMKV

class DDCacheTools: MMKV {
    
    override init() {
        super.init()
    }
    
    static func setup() {
        MMKV.initialize(rootDir: nil)
    }

    //使用该单例进行操作
    static var shared: MMKV {
        if let mmkv = MMKV.default() {
            return mmkv
        } else {
            return MMKV.init()
        }
    }
}
