//
//  StripeTools.swift
//  easyart
//
//  Created by Damon on 2024/10/8.
//

import UIKit
import StripePaymentSheet
import RxSwift
import RxRelay
import DDUtils
import DDLoggerSwift
import SwiftyJSON
import HDHUD

enum StripePayResult {
    case completed
    case canceled
    case failed
}

class StripeTools: NSObject {
    var disposeBag = DisposeBag()
    var resultPublish = PublishRelay<StripePayResult>()
    var paymentSheet: PaymentSheet?
    
    static let shared: StripeTools = {
        let tShared = StripeTools()
        return tShared
    }()
    
    private override init() {
        super.init()
    }
}

extension StripeTools {
    func startPay(orderID: String) {
        HDHUD.show(icon: .loading, duration: -1)
        _ = DDAPI.shared.request("goods/orderPay", data: ["order_id": orderID]).subscribe(onSuccess: { [weak self] response in
            HDHUD.hide()
            guard let self = self else { return }
            let data = JSON(response.data)
            let stripeInfo = data["stripe_info"]
            self.startPay(publishableKey: stripeInfo["publishableKey"].stringValue, customerID: stripeInfo["customer"].stringValue, ephemeralKey: stripeInfo["ephemeralKey"].stringValue, paymentIntent: stripeInfo["paymentIntent"].stringValue, productName: stripeInfo["description"].stringValue)
        }, onFailure: { error in
            HDHUD.hide()
            self.resultPublish.accept(.failed)
        })
    }
    
    func startPay(publishableKey: String, customerID: String, ephemeralKey: String, paymentIntent: String, productName: String) {
        STPAPIClient.shared.publishableKey = publishableKey
        var configuration = PaymentSheet.Configuration()
        configuration.returnURL = "easyart-stripe://payment-completed"
        configuration.merchantDisplayName = productName
        configuration.customer = .init(id: customerID, ephemeralKeySecret: ephemeralKey)
//        configuration.allowsDelayedPaymentMethods = true
        self.paymentSheet = PaymentSheet(paymentIntentClientSecret: paymentIntent, configuration: configuration)
        self.paymentSheet?.present(from: DDUtils.shared.getCurrentVC()!, completion: { result in
            switch result {
            case .completed:
                self.resultPublish.accept(.completed)
            case .canceled:
                self.resultPublish.accept(.canceled)
            case .failed(let error):
                printLog(error)
                self.resultPublish.accept(.failed)
            }
            self.reset()
        })
    }
    
    func reset() {
        disposeBag = DisposeBag()
        paymentSheet = nil
    }
}
