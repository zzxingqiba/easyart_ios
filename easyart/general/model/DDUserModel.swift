//
//  DDUserModel.swift
//  Menses
//
//  Created by Damon on 2020/7/1.
//  Copyright © 2020 Damon. All rights reserved.
//

import UIKit
import KakaJSON

enum AccountLoginType: Int, ConvertibleEnum {
    case email = 1
    case google = 2
    case apple = 3
}

class DDUserModel: BaseModel {
    required override init() {}
    
    var user_id: Int = 0
    var openid: String = ""
    var login_access_token: String = ""
    var secret_key: String = ""
    var name = ""                   //昵称
    var face_url = ""                //头像
    var area = ""
    var is_bind_phone = false
    var collect_num: String = ""
    var collect_new = false
    var role: UserRole = UserRole()
    var app_type: AccountLoginType = .apple
    var new_sys_msg = false //是否有新通知消息
    var new_follow_msg = false //是否有新关注消息
    var phone = ""
    var follow_num: Int = 0 // 用户关注艺术家数
    var order_num: Int = 0 // 用户订单数
    var order_new: Bool = false // 用户订单是否有新订单
    var sellout_num: Int = 0    //卖出订单数
    var sellout_new: Bool = false   //是否有新卖出订单
    //详情
    var userRoleDetail = UserRoleDetail()
    
}
extension DDUserModel: Convertible {
  
}

//用户角色
class UserRole: BaseModel, Convertible {
    required override init() {}
    var id: Int = 0         //机构或者艺术家id
    var user_role: Int = 1  // 1普通用户 2作家 3机构
    var status: Int = 1     //1正常，2:删除，3等待基础审核，4基础审核通过，5基础审核拒绝 6等待详细审核 7 等待详细拒绝  8拉黑  9修改
    
}

//用户角色审核详情
class UserRoleDetail: BaseModel, Convertible {
    required override init() {}
    var real_name: String = ""  //真实姓名
    var name: String = ""       //显示名字
    var intro: String = ""      //简介
    var imgUrl: SettleInFileModel = SettleInFileModel()
    var passport_info: SettleInFileModel = SettleInFileModel()
    var other_passport_info: SettleInFileModel = SettleInFileModel()
    var phone: String = ""
    var country_id: String = ""
    var country_name: String = ""
    var address: String = ""
    var use_update_num: Int = 0
    var status: Int = 0
    var is_over: Bool = false
    var is_red: Bool = false
    var is_role_first: Bool = false
    var remark: String = ""
    var bankInfo: UserRoleBankInfo = UserRoleBankInfo()
    var is_show_cny: Bool = false
    var id_number: String = ""
}

class UserRoleBankInfo: BaseModel, Convertible {
    required override init() {}
    
    var account_name: String = ""
    var account_type: String = ""
    var account_type_name: String = ""
    var swift_code: String = ""
    var account_number: String = ""
}
