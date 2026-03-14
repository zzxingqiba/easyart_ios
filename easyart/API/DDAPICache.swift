//
//  DDAPICache.swift
//  Menses
//
//  Created by Damon on 2020/9/7.
//  Copyright © 2020 Damon. All rights reserved.
//

import Foundation

enum DDAPICacheType {
    case never              //不使用缓存
    case cacheOnly          //只使用缓存数据，没有缓存数据时返回为空
    case cachePriority      //优先使用缓存，然后再使用网络请求配置，会回调两次
    case cacheUsedInError   //网络错误时使用上次缓存数据
}
