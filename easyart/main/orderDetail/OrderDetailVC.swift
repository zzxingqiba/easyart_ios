//
//  OrderDetailVC.swift
//  easyart
//
//  Created by Damon on 2024/9/30.
//

import UIKit
import SwiftyJSON
import DDUtils
import HDHUD

class OrderDetailVC: BaseVC {
    private var orderID: String
    private var orderNumber: String = ""
    var orderListType: OrderListType = .buy
    init(orderID: String) {
        self.orderID = orderID
        super.init(bottomPadding: 150)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._bindView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self._loadData()
    }
    
    override func createUI() {
        super.createUI()
        self.mSafeView.contentType = .flex
        self.mSafeView.addSubview(mStatusView)
        mStatusView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
        }
        
        self.mSafeView.addSubview(mOrderAddressView)
        mOrderAddressView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(mStatusView.snp.bottom)
            make.height.lessThanOrEqualTo(MAXFLOAT)
        }
        
        self.mSafeView.addSubview(mAuthorLabel)
        mAuthorLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(mStatusView.snp.bottom)
            make.height.equalTo(40)
        }
        
        let line = UIView()
        line.backgroundColor = ThemeColor.line.color()
        self.mSafeView.addSubview(line)
        line.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(mOrderAddressView.snp.bottom)
            make.height.equalTo(1)
        }
        
        self.mSafeView.addSubview(mOrderGoodsInfoView)
        mOrderGoodsInfoView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(line.snp.bottom)
        }
        
        let line2 = UIView()
        line2.backgroundColor = ThemeColor.line.color()
        self.mSafeView.addSubview(line2)
        line2.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(mOrderGoodsInfoView.snp.bottom)
            make.height.equalTo(1)
        }
        
        self.mSafeView.addSubview(mMessageLabel)
        mMessageLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(line2.snp.bottom).offset(16)
        }
        
        let line3 = UIView()
        line3.backgroundColor = ThemeColor.line.color()
        self.mSafeView.addSubview(line3)
        line3.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(mMessageLabel.snp.bottom).offset(16)
            make.height.equalTo(1)
        }
        
        self.mSafeView.addSubview(mShippingView)
        mShippingView.snp.makeConstraints { make in
            make.left.right.equalTo(mMessageLabel)
            make.top.equalTo(line3.snp.bottom).offset(16)
        }
        
        let line4 = UIView()
        line4.backgroundColor = ThemeColor.line.color()
        self.mSafeView.addSubview(line4)
        line4.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(mShippingView.snp.bottom).offset(16)
            make.height.equalTo(1)
        }
        
        self.mSafeView.addSubview(mDutiesView)
        mDutiesView.snp.makeConstraints { make in
            make.left.right.equalTo(mMessageLabel)
            make.top.equalTo(line4.snp.bottom).offset(16)
        }
        
        let line5 = UIView()
        line5.backgroundColor = ThemeColor.line.color()
        self.mSafeView.addSubview(line5)
        line5.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(mDutiesView.snp.bottom).offset(16)
            make.height.equalTo(1)
        }
        
        self.mSafeView.addSubview(mInsuranceView)
        mInsuranceView.snp.makeConstraints { make in
            make.left.right.equalTo(mMessageLabel)
            make.top.equalTo(line5.snp.bottom).offset(16)
        }
        
        let line7 = UIView()
        line7.backgroundColor = ThemeColor.line.color()
        self.mSafeView.addSubview(line7)
        line7.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(mInsuranceView.snp.bottom).offset(16)
            make.height.equalTo(1)
        }
        
        self.mSafeView.addSubview(mTotalView)
        mTotalView.snp.makeConstraints { make in
            make.left.right.equalTo(mMessageLabel)
            make.top.equalTo(line7.snp.bottom).offset(16)
        }
        
        let line6 = UIView()
        line6.backgroundColor = ThemeColor.line.color()
        self.mSafeView.addSubview(line6)
        line6.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(mTotalView.snp.bottom).offset(16)
            make.height.equalTo(1)
        }
        
        self.mSafeView.addSubview(mInfoView)
        mInfoView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(line6.snp.bottom).offset(16)
        }
        
        self.view.addSubview(mOrderDetailBottomButton)
        mOrderDetailBottomButton.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(50 + BottomSafeAreaHeight)
        }
        
        let bottomLine = UIView()
        bottomLine.backgroundColor = ThemeColor.line.color()
        self.view.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { make in
            make.left.right.top.equalTo(mOrderDetailBottomButton)
            make.height.equalTo(1)
        }
    }
    

    //MARK: UI
    lazy var mStatusView: OrderStatusView = {
        let view = OrderStatusView()
        return view
    }()
    
    lazy var mOrderAddressView: OrderAddressView = {
        let view = OrderAddressView()
        return view
    }()
    
    lazy var mAuthorLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.font = .systemFont(ofSize: 13)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mOrderGoodsInfoView: OrderGoodsInfoView = {
        let view = OrderGoodsInfoView()
        return view
    }()
    
    lazy var mMessageLabel: DDSpaceBetweenView = {
        let view = DDSpaceBetweenView()
        view.mTitleLabel.text = "Message".localString
        return view
    }()
    
    lazy var mTotalView: DDSpaceBetweenView = {
        let view = DDSpaceBetweenView()
        view.mTitleLabel.text = "Total (excluding shipping costs) ".localString
        return view
    }()
    
    lazy var mShippingView: DDSpaceBetweenView = {
        let view = DDSpaceBetweenView()
        view.mTitleLabel.text = "Shipping fee".localString
        return view
    }()
    
    lazy var mDutiesView: DDSpaceBetweenView = {
        let view = DDSpaceBetweenView()
        let attributed = NSMutableAttributedString(string: "Import duties".localString, attributes: [NSAttributedString.Key.foregroundColor : ThemeColor.black.color()])
        let attri = NSAttributedString(string: "\nJapan VAT 10%", attributes: [NSAttributedString.Key.foregroundColor : ThemeColor.lightGray.color(), .font: UIFont.systemFont(ofSize: 11)])
        attributed.append(attri)
        view.mTitleLabel.attributedText = attributed
        view.mContentLabel.text = "Excludes".localString
        return view
    }()
    
    lazy var mInsuranceView: DDSpaceBetweenView = {
        let view = DDSpaceBetweenView()
        let attributed = NSMutableAttributedString(string: "Insurance".localString, attributes: [NSAttributedString.Key.foregroundColor : ThemeColor.black.color()])
        let attri = NSAttributedString(string: " 0.8%", attributes: [NSAttributedString.Key.foregroundColor : ThemeColor.lightGray.color(), .font: UIFont.systemFont(ofSize: 11)])
        attributed.append(attri)
        view.mTitleLabel.attributedText = attributed
        view.mContentLabel.text = "Excludes".localString
        return view
    }()
    
    lazy var mInfoView: OrderInfoView = {
        let view = OrderInfoView()
        return view
    }()
    
    lazy var mOrderDetailBottomButton: OrderDetailBottomButton = {
        let view = OrderDetailBottomButton()
        view.backgroundColor = UIColor.dd.color(hexValue: 0xffffff)
        view.distribution = .fillEqually
        return view
    }()
}

extension OrderDetailVC {
    func _loadData() {
        _ = DDAPI.shared.request("goods/orderDetail", data: ["order_id": self.orderID]).subscribe(onSuccess: { [weak self] response in
            guard let self = self else { return }
            let json = JSON(response.data)
            let order_info = json["order_info"]
            self.orderNumber = order_info["order_number"].stringValue
            self.mStatusView.update(title: json["tip_info"]["title"].stringValue, nextStep: json["tip_info"]["next_title"].stringValue, titleBolder: order_info["status"].intValue == 4, tip: json["tip_info"]["desc"].stringValue)
            //收货地址
            if let address = json["address_info"].dictionaryObject {
                let addressModel = address.kj.model(DDAddressModel.self)
                self.mAuthorLabel.isHidden = self.orderListType != .sell
                self.mOrderAddressView.isHidden = self.orderListType == .sell
                self.mAuthorLabel.text = "Art collectors: \(addressModel.consignee)"
                self.mOrderAddressView.updateUI(model: addressModel)
                if self.orderListType == .sell {
                    self.mOrderAddressView.snp.updateConstraints { make in
                        make.height.lessThanOrEqualTo(40)
                    }
                } else {
                    self.mOrderAddressView.snp.updateConstraints { make in
                        make.height.lessThanOrEqualTo(MAXFLOAT)
                    }
                }
            }
            
            //留言
            if !order_info["leave_msg"].stringValue.isEmpty {
                self.mMessageLabel.mContentLabel.text = order_info["leave_msg"].stringValue
            } else {
                self.mMessageLabel.mContentLabel.text = "-"
            }
            self.mTotalView.mContentLabel.text = "$ " + order_info["pay_amount"].stringValue
            self.mShippingView.mContentLabel.text = "$ " + order_info["logistics_cost"].stringValue
            
            self.mOrderGoodsInfoView.updateUI(orderInfo: order_info)
            self.mInfoView.updateUI(json: order_info)
            //税率
            let attributed = NSMutableAttributedString(string: "Import duties".localString, attributes: [NSAttributedString.Key.foregroundColor : ThemeColor.black.color()])
            if String.isAvailable(json["import_duties_info"]["desc"].stringValue) {
                let attri = NSAttributedString(string: "\n" + json["import_duties_info"]["desc"].stringValue, attributes: [NSAttributedString.Key.foregroundColor : ThemeColor.lightGray.color(), .font: UIFont.systemFont(ofSize: 11)])
                attributed.append(attri)
            }
            self.mDutiesView.mTitleLabel.attributedText = attributed
            if json["import_duties_info"]["cost"].floatValue > 0 {
                self.mDutiesView.mContentLabel.text = "$" + json["import_duties_info"]["cost"].stringValue
            } else {
                self.mDutiesView.mContentLabel.text = "-"
            }
            //保险
            let InsuranceAttributed = NSMutableAttributedString(string: "Insurance".localString, attributes: [NSAttributedString.Key.foregroundColor : ThemeColor.black.color()])
            let InsuranceAttri = NSAttributedString(string: " " + order_info["insurance_info"]["desc"].stringValue, attributes: [NSAttributedString.Key.foregroundColor : ThemeColor.lightGray.color(), .font: UIFont.systemFont(ofSize: 11)])
            InsuranceAttributed.append(InsuranceAttri)
            self.mInsuranceView.mTitleLabel.attributedText = InsuranceAttributed
            self.mInsuranceView.mContentLabel.text = "$" + order_info["insurance_info"]["cost"].stringValue
            //底部按钮
            var list = [UIView]()
            if self.orderListType == .sell {
                //卖出订单
                if order_info["status"].intValue == 1 || order_info["status"].intValue == 3 {
                    list.append(self._createButton(title: "Inquire about artwork".localString, isBlackButton: true, tag: DDOrderButtonTag.contact.rawValue))
                } else if order_info["status"].intValue == 4 {
                    list.append(self._createButton(title: "Delete order".localString, isBlackButton: false, tag: DDOrderButtonTag.delete.rawValue))
                    list.append(self._createButton(title: "Inquire about artwork".localString, isBlackButton: true, tag: DDOrderButtonTag.contact.rawValue))
                } else if order_info["status"].intValue == 5 {
                    list.append(self._createButton(title: "Delete order".localString, isBlackButton: true, tag: DDOrderButtonTag.delete.rawValue))
                } else if order_info["status"].intValue == 2 {
                    if order_info["logistics_status"].intValue == 9 {
                        list.append(self._createButton(title: "Inquire about artwork".localString, isBlackButton: false, tag: DDOrderButtonTag.contact.rawValue))
                        list.append(self._createButton(title: "Deliver".localString, isBlackButton: true, tag: DDOrderButtonTag.send.rawValue))
                    } else {
                        list.append(self._createButton(title: "Inquire about artwork".localString, isBlackButton: true, tag: DDOrderButtonTag.contact.rawValue))
                    }
                }
            } else {
                //买入订单
                if order_info["order_type"].intValue == 3 {
                    if order_info["status"].intValue == 1 {
                        list.append(self._createButton(title: "I want to make the payment".localString, isBlackButton: true, tag: DDOrderButtonTag.pay.rawValue))
                    } else if order_info["status"].intValue == 4 || order_info["status"].intValue == 5 {
                        list.append(self._createButton(title: "Delete order".localString, isBlackButton: true, tag: DDOrderButtonTag.delete.rawValue))
                    }
                } else {
                    //待支付
                    if order_info["status"].intValue == 1 {
                        list.append(self._createButton(title: "Cancel order".localString, isBlackButton: false, tag: DDOrderButtonTag.cancel.rawValue))
                        if order_info["pay_type"].intValue == 2 {
                            list.append(self._createButton(title: "I have already made the payment".localString, isBlackButton: false, tag: DDOrderButtonTag.hasPay.rawValue))
                        }
                        list.append(self._createButton(title: "I want to make the payment".localString, isBlackButton: true, tag: DDOrderButtonTag.pay.rawValue))
                    } else if order_info["status"].intValue == 2 {
                        if order_info["pay_type"].intValue == 2 {
                            list.append(self._createButton(title: "I have already made the payment".localString, isBlackButton: false, tag: DDOrderButtonTag.hasPay.rawValue))
                        }
                        if order_info["ant_chain"].boolValue && order_info["pay_type"].intValue != 2 {
                            list.append(self._createButton(title: "View digital voucher".localString, isBlackButton: false, tag: DDOrderButtonTag.copyright.rawValue))
                        }
                        list.append(self._createButton(title: "Inquire about artwork".localString, isBlackButton: true, tag: DDOrderButtonTag.contact.rawValue))
                    } else if order_info["status"].intValue == 3 {
                        if order_info["pay_type"].intValue == 2 {
                            list.append(self._createButton(title: "I have already made the payment".localString, isBlackButton: false, tag: DDOrderButtonTag.hasPay.rawValue))
                        }
                        list.append(self._createButton(title: "Inquire about artwork".localString, isBlackButton: false, tag: DDOrderButtonTag.contact.rawValue))
                        list.append(self._createButton(title: "Confirm receipt".localString, isBlackButton: true, tag: DDOrderButtonTag.recieve.rawValue))
                    } else if order_info["status"].intValue == 4 {
                        if order_info["pay_type"].intValue == 1 {
                            list.append(self._createButton(title: "Inquire about artwork".localString, isBlackButton: false, tag: DDOrderButtonTag.contact.rawValue))
                        } else if order_info["pay_type"].intValue == 2 {
                            list.append(self._createButton(title: "I have already made the payment".localString, isBlackButton: false, tag: DDOrderButtonTag.hasPay.rawValue))
                        }
                    } else if order_info["status"].intValue == 5 {
                        if order_info["pay_type"].intValue == 2 {
                            list.append(self._createButton(title: "I have already made the payment".localString, isBlackButton: false, tag: DDOrderButtonTag.hasPay.rawValue))
                            list.append(self._createButton(title: "Delete order".localString, isBlackButton: true, tag: DDOrderButtonTag.delete.rawValue))
                        } else {
                            list.append(self._createButton(title: "Delete order".localString, isBlackButton: true, tag: DDOrderButtonTag.delete.rawValue))
                        }
                    }
                }
            }
            //更新底部按钮
            self.mOrderDetailBottomButton.updateUI(views: list)
        })
    }
    
    func _bindView() {
        

        
    }
    
    @objc func _clickButton(event: UIButton) {
        let tag = DDOrderButtonTag(rawValue: event.tag)
        if tag == .contact {
            UIApplication.shared.open(URL(string: "mailto:info@easyart.cn")!)
        } else if tag == .pay {
            StripeTools.shared.resultPublish.subscribe(onNext: { [weak self] result in
                self?._loadData()
            }).disposed(by: StripeTools.shared.disposeBag)
            StripeTools.shared.startPay(orderID: self.orderID)
        } else if tag == .cancel {
            let sheet = DDSheetView()
            sheet.mTitleLabel.text = "Do you want to cancel the order".localString
            _ = sheet.mClickSubject.subscribe(onNext: { [weak self] buttonType in
                guard let self = self else { return }
                DDPopView.hide()
                if buttonType == .confirm {
                    _ = DDAPI.shared.request("goods/orderCancel", data: ["order_id": self.orderID]).subscribe(onSuccess: { [weak self] response in
                        HDHUD.show("Cancelled successfully".localString)
                        self?._loadData()
                    })
                }
            })
            DDPopView.show(view: sheet, animationType: .bottom)
        } else if tag == .delete {
            let sheet = DDSheetView()
            sheet.mTitleLabel.text = "Do you want to delete the order".localString
            _ = sheet.mClickSubject.subscribe(onNext: { [weak self] buttonType in
                guard let self = self else { return }
                DDPopView.hide()
                if buttonType == .confirm {
                    _ = DDAPI.shared.request("goods/orderDel", data: ["order_id": self.orderID]).subscribe(onSuccess: { [weak self] response in
                        HDHUD.show("Delete successful".localString)
                        self?.navigationController?.popViewController(animated: true)
                    })
                }
            })
            DDPopView.show(view: sheet, animationType: .bottom)
        } else if tag == .send {
            let vc = OrderSendVC(orderNumber: self.orderNumber)
            self.navigationController?.pushViewController(vc, animated: true)
        }  else if tag == .recieve {
            let sheet = DDSheetView()
            sheet.mTitleLabel.text = "Confirm receipt".localString
            _ = sheet.mClickSubject.subscribe(onNext: { [weak self] buttonType in
                guard let self = self else { return }
                DDPopView.hide()
                if buttonType == .confirm {
                    _ = DDAPI.shared.request("goods/orderRecv", data: ["order_id": self.orderID]).subscribe(onSuccess: { [weak self] response in
                        HDHUD.show("Goods received successfully".localString, icon: .success)
                        self?.navigationController?.popViewController(animated: true)
                    })
                }
            })
            DDPopView.show(view: sheet, animationType: .bottom)
        }
    }
    
    func _createButton(title: String, isBlackButton: Bool, tag: Int) -> UIButton {
        let button = UIButton(type: .custom)
        button.tag = tag
        button.setTitle(title, for: .normal)
        if isBlackButton {
            button.backgroundColor = ThemeColor.black.color()
            button.setTitleColor(UIColor.dd.color(hexValue: 0xffffff), for: .normal)
        } else {
            button.backgroundColor = UIColor.dd.color(hexValue: 0xffffff)
            button.setTitleColor(ThemeColor.black.color(), for: .normal)
        }
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(_clickButton(event: )), for: .touchUpInside)
        return button
    }
}
