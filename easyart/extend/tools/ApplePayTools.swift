//
//  File.swift
//  LazypigQuickly
//
//  Created by Damon on 2022/1/7.
//  Copyright © 2022 Damon. All rights reserved.
//

import Foundation
import StoreKit

import DDLoggerSwift

typealias ProductWithExpireDate = [String: Date]
typealias ProductsRequestHandler = (_ response: SKProductsResponse?, _ error: Error?) -> ()
typealias PurchaseHandler = (_ productID: String?, _ error: Error?) -> ()
typealias RestoreHandler = (_ productID: String?, _ error: Error?) -> ()

//MARK: - PayResultStatus
enum PayResultStatus {
    case success
    case fail
    case cancel
}

//MARK: - ApplePayTools
class ApplePayTools: NSObject {
    private var productsRequest: SKProductsRequest?
    private var productsRequestHandler: ProductsRequestHandler?
    private var purchaseHandler: PurchaseHandler?
    private var restoreHandler: RestoreHandler?
    
    private var orderID: String = ""
    
    static let shared = ApplePayTools()
    
    private override init(){
        super.init()
        self.reset()
    }
}

extension ApplePayTools {
    func reset() {
        //移除老的监听
        SKPaymentQueue.default().remove(self)
        //商品请求取消
        self.productsRequest?.cancel()
        //回调清空
        self.purchaseHandler = nil
        self.restoreHandler = nil
        self.productsRequestHandler = nil
    }
    
    //获取现在上架的商品，可用于商品展示
    func requestProducts(_ productIDs: Set<String>, complete: @escaping ProductsRequestHandler) {
        //取消原来的
        self.productsRequest?.cancel()
        self.productsRequestHandler = complete
        //请求新的
        self.productsRequest = SKProductsRequest(productIdentifiers: productIDs)
        self.productsRequest?.delegate = self
        self.productsRequest?.start()
    }
    
    //支付
    func pay(productID: String, orderID: String, complete: @escaping PurchaseHandler) {
        //移除老的监听
        SKPaymentQueue.default().remove(self)
        //添加新的
        SKPaymentQueue.default().add(self)
        self.orderID = orderID
        self.purchaseHandler = complete
        let payment = SKMutablePayment()
        payment.applicationUsername = "\(DDUserTools.shared.userInfo.value.user_id)"//用户表示
        payment.productIdentifier = productID
        SKPaymentQueue.default().add(payment)
    }
    
    //恢复内购
    func restoreCompletedTransactions(userName: String?, _ complete: @escaping RestoreHandler) {
        self.restoreHandler = complete
        if let userName = userName {
            SKPaymentQueue.default().restoreCompletedTransactions(withApplicationUsername: userName)
        } else {
            SKPaymentQueue.default().restoreCompletedTransactions()
        }
    }
}

private extension ApplePayTools {
    //验证
    func _appleVerify(productID: String, transactionID: String?, originalTransactionID: String?, isPay: Bool, transaction: SKPaymentTransaction) {
        if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL, FileManager.default.fileExists(atPath: appStoreReceiptURL.path) {
            do {
                let receiptData = try Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)
                let receiptString = receiptData.base64EncodedString(options: [])
                _ = DDAPI.shared.request("home/synchronousApple", data: ["order_id" : self.orderID, "transaction_id": transactionID ?? "", "original_transaction": originalTransactionID ?? "", "sign_str": receiptString], autoShowError: false).subscribe { response in
                    self._handlePayResult(productID: productID, error: nil, isPay: isPay, transaction: transaction)
                } onFailure: { [weak self] error in
                    self?._handlePayResult(productID: productID, error: error, isPay: isPay, transaction: transaction)
                }
            } catch {
                printError("内购系统出错" + error.localizedDescription)
                self._handlePayResult(productID: productID, error: error, isPay: isPay, transaction: transaction)
            }
        } else {
            self._handlePayResult(productID: productID, error: DDError.string("等待验证令牌不存在"), isPay: isPay, transaction: transaction)
        }
        
    }
    
    func _completeRestoreTransactions(_ queue: SKPaymentQueue, error: Error?) {
        //ID - transactionIdentifier
        let productItems: [(String, String, String, SKPaymentTransaction)] = queue.transactions.compactMap { transaction in
            if let productID = transaction.original?.payment.productIdentifier {
                let productItem = (productID, transaction.transactionIdentifier ?? "", transaction.original?.transactionIdentifier ?? "", transaction)
                return productItem
            } else {
                SKPaymentQueue.default().finishTransaction(transaction)
            }
            return nil
        }
        
        if productItems.isEmpty && error == nil {
            restoreHandler?("", DDError.string("没有需要恢复的项目"))
            self.reset()
        } else {
            for productItem in productItems {
                self._appleVerify(productID: productItem.0, transactionID: productItem.1,originalTransactionID: productItem.2, isPay: false, transaction: productItem.3)
            }
        }
    }
}

extension ApplePayTools: SKProductsRequestDelegate {
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        productsRequestHandler?(response, nil)
        clearRequestAndHandler()
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        productsRequestHandler?(nil, error)
        clearRequestAndHandler()
    }
    
    //清空回调
    private func clearRequestAndHandler() {
        self.productsRequest?.cancel()
        self.productsRequest = nil
        self.productsRequestHandler = nil
    }
}

extension ApplePayTools: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        var purchasedList: [SKPaymentTransaction] = []
        
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                printInfo("商品加入列表，正在购买中...")
            case .purchased:
                //开始验证结果
                printInfo("已支付")
                purchasedList.append(transaction)
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                printError("购买失败")
                self.purchaseHandler?(transaction.payment.productIdentifier, transaction.error)
                SKPaymentQueue.default().finishTransaction(transaction)
                self.reset()
            case .restored:
                printInfo("恢复购买")
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
        print("待处理订单数", purchasedList.count)
        if let last = purchasedList.last {
            self._appleVerify(productID: last.payment.productIdentifier, transactionID: last.transactionIdentifier, originalTransactionID: last.original?.transactionIdentifier, isPay: true, transaction: last)
        }
    }
    
    //MARK: - 恢复购买
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        printError("发起恢复失败")
        _completeRestoreTransactions(queue, error: error)
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        printInfo("恢复完成")
        _completeRestoreTransactions(queue, error: nil)
    }
}

//处理付款请求
extension ApplePayTools {
    func _handlePayResult(productID: String?, error: Error?, isPay: Bool, transaction: SKPaymentTransaction) {
        if let error = error {
            if isPay {
                //购买成功
                self.purchaseHandler?(productID, error)
            } else {
                //恢复成功
                self.restoreHandler?(productID, error)
            }
            SKPaymentQueue.default().finishTransaction(transaction)
            self.reset()
        } else {
            _ = DDUserTools.shared.updateUserInfo().subscribe(onSuccess: { [weak self] _ in
                guard let self = self else { return }
                if isPay {
                    //购买成功
                    self.purchaseHandler?(productID, nil)
                } else {
                    //恢复成功
                    self.restoreHandler?(productID, nil)
                }
                self.reset()
            })
        }
        SKPaymentQueue.default().finishTransaction(transaction)
    }
}
