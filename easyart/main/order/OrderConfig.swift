//
//  OrderConfig.swift
//  easyart
//
//  Created by Damon on 2024/10/15.
//

enum DDOrderButtonTag: Int {
    case contact = 1    //联系客服
    case cancel = 2     //取消订单
    case pay = 3        //立即支付
    case delete = 4     //删除订单
    case send = 5       //发货
    case recieve = 6     //收货
    case copyright = 7      //数字版权
    case hasPay = 8     //已支付，检测状态
    case checkInvoice = 9   //查看发票
    case requestInvoice = 10 //开票
}
