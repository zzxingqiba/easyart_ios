//
//  DDConfig.swift
//  Menses
//
//  Created by Damon on 2020/7/1.
//  Copyright © 2020 Damon. All rights reserved.
//

import Foundation
import UIKit
import DDUtils

let APP_DEBUG = true    //是否是测试服

let APP_VERSION = "2.2.4"     //开发版本
let APP_NAME = "art"    //包名
let APP_REQUEST_Secret = "21meNQbscvLvpT8A"  //某些接口验证的秘钥


let APP_ID = "1587139641" //软件的apple的appid
let APP_SCHEME = "qinlianmenses" //app的回调


/** 第三方配置 **/


let WWWUrl_Base = APP_DEBUG ? "https://dev-www.speakpal.ai/" : "https://www.speakpal.ai/"
let TalkUrl_Base = APP_DEBUG ? "https://dev-talk.speakpal.ai/" : "https://talk.speakpal.ai/"


/** 头条广告配置 **/
let kBUADAppID = "5224037"
let kBUSpalshID = "887587221"   //开屏广告
let kBUVideoID = "946854758"    //激励视频
/** 腾讯广告配置 **/
let kTencentADAppID = "1200299268"
let kTencentSpalshID = "9052746369899332"   //开屏广告
let kTencentVideoID = "8022140319694398"    //激励视频


/** 本地保存信息 **/
enum UserDefaultKey: String {
    case userInfo       //用户信息
    case userConfig     //用户配置信息
    case userUUID       //用户uuid
    case userLanguage   //用户浏览器语言
    case readRule       //已经阅读新手规则
    case lastUserID     //最后的用户id
    case recentSearch   //最近搜索
}

extension UserDefaultKey {
    func keyValue() -> String {
        return (APP_DEBUG ? "debug_" : "release") + self.rawValue
    }
}

//默认样式
//let blackColor = UIColor.dd.color(hexValue: 0x000000)

//对齐方式
enum DDAlignmentType {
    case left
    case centerX
    case right
}

enum ThemeColor {
    case main
    case lighBG
    case black
    case gray
    case lightGray
    case line
    case red
    case white
    case textPlaceholder
}

extension ThemeColor {
    func color() -> UIColor {
        switch self {
        case .main:
            _ = #colorLiteral(red: 0.06274509804, green: 0.3254901961, blue: 1, alpha: 1)
            return UIColor.dd.color(hexValue: 0x1053FF)
        case .lighBG:
            _ = #colorLiteral(red: 1, green: 0.9999999404, blue: 0.9999999404, alpha: 1)
            return UIColor.dd.color(hexValue: 0xffffff)
        case .black:
            _ = #colorLiteral(red: 0.09019607843, green: 0.0862745098, blue: 0.09803921569, alpha: 1)
            return UIColor.dd.color(hexValue: 0x171619)
        case .gray:
            _ = #colorLiteral(red: 0.5215686275, green: 0.5019607843, blue: 0.5607843137, alpha: 1)
            return UIColor.dd.color(hexValue: 0x85808F)
        case .lightGray:
            _ = #colorLiteral(red: 0.6392156863, green: 0.6235294118, blue: 0.6745098039, alpha: 1)
            return UIColor.dd.color(hexValue: 0xa39fac)
        case .line:
            _ = #colorLiteral(red: 0.5215686275, green: 0.5019607843, blue: 0.5607843137, alpha: 1)
            return UIColor.dd.color(hexValue: 0xE6E6E6)
        case .textPlaceholder:
            return UIColor.dd.color(hexValue: 0xc3c2c2)
        case .red:
            _ = #colorLiteral(red: 0.9607843137, green: 0, blue: 0.2705882353, alpha: 1)
            return UIColor.dd.color(hexValue: 0xF50045)
        case .white:
            return UIColor.dd.color(hexValue: 0xffffff)
        }
    }
}

var BottomSafeAreaHeight: CGFloat = -1

enum GoodsShowStatus: Int {
    case normal = 0     //正常可购买状态
    case inOrder = 1    //交易中
    case sold = 2       //已售
    case third = 3      //未知
    case fout = 4       //未知
    case waitReview = 5 //待审核
    case reviewFail = 6 //审核被拒
    case seven = 7      //未知
    case new = 8        //新发布，刚发布十分钟
    case nine = 9       //未知
    case draf = 10      //草稿箱未送审
}
