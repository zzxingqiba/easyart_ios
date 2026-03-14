//
//  ConfirmOrderVC.swift
//  easyart
//
//  Created by Damon on 2024/9/18.
//

import UIKit
import KakaJSON
import RxRelay
import SwiftyJSON
import DDUtils
import HDHUD

class ConfirmOrderVC: BaseVC {
    var model: DDPlaceOrderModel
    let pageInfo = BehaviorRelay<JSON>(value: JSON())
    var isAcceptRule = BehaviorRelay<Bool>(value: true)
    private var addressID = BehaviorRelay<String>(value: "")
    private var totalPrice: Float = 0
    private var logisticsCost: Int = 0
    private var dutiesCost: Int = 0
    private var insurance: Int = 0
    //购买协议使用
    private var buyName = ""
    private var artistName = ""
    private var artworkName = ""
    private var payPrice: String = ""
    private var address: String = ""
    
    init(model: DDPlaceOrderModel) {
        self.model = model
        super.init(bottomPadding: 100)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._bindView()
        self._loadData()
    }
    
    override func createUI() {
        super.createUI()
        self.mSafeView.contentType = .flex
        self.mSafeView.addSubview(mAddressInfoView)
        mAddressInfoView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
        }
        self.mSafeView.addSubview(mGoodsInfoView)
        mGoodsInfoView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(mAddressInfoView.snp.bottom)
        }
        //line
        self.mSafeView.addSubview(mMessageTextView)
        mMessageTextView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(mGoodsInfoView.snp.bottom).offset(17)
            make.height.equalTo(16)
        }
        
        let line2 = UIView()
        line2.backgroundColor = ThemeColor.line.color()
        self.mSafeView.addSubview(line2)
        line2.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(mMessageTextView.snp.bottom).offset(17)
            make.height.equalTo(1)
        }
        //
        self.mSafeView.addSubview(mPriceView)
        mPriceView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(line2.snp.bottom).offset(16)
        }
        //装裱费
        self.mSafeView.addSubview(mPackageBGView)
        mPackageBGView.snp.makeConstraints { make in
            make.left.right.equalTo(mPriceView)
            make.top.equalTo(mPriceView.snp.bottom)
            make.height.lessThanOrEqualTo(MAXFLOAT)
        }
        mPackageBGView.addSubview(mPackageView)
        mPackageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(16)
        }
        mPackageBGView.addSubview(mPackageContentLabel)
        mPackageContentLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(mPackageView.snp.bottom).offset(16)
            make.bottom.equalToSuperview()
        }
       
        let line3 = UIView()
        line3.backgroundColor = ThemeColor.line.color()
        self.mSafeView.addSubview(line3)
        line3.snp.makeConstraints { make in
            make.left.right.equalTo(mPriceView)
            make.top.equalTo(mPackageBGView.snp.bottom).offset(16)
            make.height.equalTo(1)
        }
        
        //运费
        self.mSafeView.addSubview(mShippingTitleLabel)
        mShippingTitleLabel.snp.makeConstraints { make in
            make.left.right.equalTo(mPriceView)
            make.top.equalTo(line3.snp.bottom).offset(16)
        }
        
        self.mSafeView.addSubview(mSFShippingFeeView)
        mSFShippingFeeView.snp.makeConstraints { make in
            make.left.right.equalTo(mPriceView)
            make.top.equalTo(mShippingTitleLabel.snp.bottom).offset(10)
            make.height.equalTo(30)
        }
        
        self.mSafeView.addSubview(mDHLShippingFeeView)
        mDHLShippingFeeView.snp.makeConstraints { make in
            make.left.right.equalTo(mPriceView)
            make.top.equalTo(mSFShippingFeeView.snp.bottom)
            make.height.equalTo(mSFShippingFeeView)
        }
        
        let line4 = UIView()
        line4.backgroundColor = ThemeColor.line.color()
        self.mSafeView.addSubview(line4)
        line4.snp.makeConstraints { make in
            make.left.right.equalTo(mPriceView)
            make.top.equalTo(mDHLShippingFeeView.snp.bottom).offset(16)
            make.height.equalTo(1)
        }
        
        self.mSafeView.addSubview(mDutiesView)
        mDutiesView.snp.makeConstraints { make in
            make.left.right.equalTo(mPriceView)
            make.top.equalTo(line4.snp.bottom).offset(16)
        }
        
        let line5 = UIView()
        line5.backgroundColor = ThemeColor.line.color()
        self.mSafeView.addSubview(line5)
        line5.snp.makeConstraints { make in
            make.left.right.equalTo(mPriceView)
            make.top.equalTo(mDutiesView.snp.bottom).offset(16)
            make.height.equalTo(1)
        }
        
        self.mSafeView.addSubview(mInsuranceView)
        mInsuranceView.snp.makeConstraints { make in
            make.left.right.equalTo(mPriceView)
            make.top.equalTo(line5.snp.bottom).offset(16)
        }
        
        let line6 = UIView()
        line6.backgroundColor = ThemeColor.line.color()
        self.mSafeView.addSubview(line6)
        line6.snp.makeConstraints { make in
            make.left.right.equalTo(mPriceView)
            make.top.equalTo(mInsuranceView.snp.bottom).offset(16)
            make.height.equalTo(1)
        }
        
        self.mSafeView.addSubview(mTotalView)
        mTotalView.snp.makeConstraints { make in
            make.left.right.equalTo(mPriceView)
            make.top.equalTo(line6.snp.bottom).offset(16)
        }
        
        let line7 = UIView()
        line7.backgroundColor = ThemeColor.line.color()
        self.mSafeView.addSubview(line7)
        line7.snp.makeConstraints { make in
            make.left.right.equalTo(mPriceView)
            make.top.equalTo(mTotalView.snp.bottom).offset(16)
            make.height.equalTo(1)
        }
        self.mSafeView.addSubview(mRuleView)
        mRuleView.snp.makeConstraints { make in
            make.left.equalTo(mTotalView)
            make.top.equalTo(line7.snp.bottom).offset(20)
            make.right.equalTo(mTotalView)
        }
        
        self.view.addSubview(mPlaceOrderBottomView)
        mPlaceOrderBottomView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(50 + BottomSafeAreaHeight)
        }
    }
    
    //MARK: UI
    lazy var mAddressInfoView: DDAddressView = {
        let info = DDAddressView()
        return info
    }()

    lazy var mGoodsInfoView: DDGoodsInfoView = {
        let info = DDGoodsInfoView()
        return info
    }()
    
    lazy var mMessageTextView: DDTextView = {
        let textField = DDTextView()
        textField.mPlaceHolderLabel.text = "Message (Optional)".localString
        return textField
    }()

    lazy var mPriceView: DDSpaceBetweenView = {
        let view = DDSpaceBetweenView()
        view.mTitleLabel.text = "Artwork amount".localString
        view.mContentLabel.font = .systemFont(ofSize: 14, weight: .bold)
        return view
    }()
    
    lazy var mPackageBGView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var mPackageView: DDSpaceBetweenView = {
        let view = DDSpaceBetweenView()
        view.mTitleLabel.text = "Mounting fee".localString
        view.mContentLabel.font = .systemFont(ofSize: 14, weight: .bold)
        return view
    }()
    
    lazy var mPackageContentLabel: UILabel = {
        let label = UILabel()
        label.text = "Shipping fee".localString
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.gray.color()
        return label
    }()
    
    lazy var mShippingTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Shipping fee".localString
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mSFShippingFeeView: DDShippingFeeView = {
        let view = DDShippingFeeView()
        view.isSelected = true
        view.mTitleLabel.text = "Express Courier".localString
        view.mContentLabel.text = "-"
        view.mContentLabel.font = .systemFont(ofSize: 14, weight: .bold)
        view.mIconImageView.image = UIImage(named: "icon_sf")
        return view
    }()
    
    lazy var mDHLShippingFeeView: DDShippingFeeView = {
        let view = DDShippingFeeView()
        view.isSelected = false
        view.mTitleLabel.text = "Express Courier".localString
        view.mContentLabel.text = "-"
        view.mContentLabel.font = .systemFont(ofSize: 14, weight: .bold)
        view.mIconImageView.image = UIImage(named: "icon_dhl")
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
    
    lazy var mTotalView: DDSpaceBetweenView = {
        let view = DDSpaceBetweenView()
        view.mTitleLabel.text = "Subtotal (CIF)".localString
        view.mContentLabel.font = .systemFont(ofSize: 14, weight: .bold)
        return view
    }()
    
    lazy var mRuleView: DDRuleView = {
        let view = DDRuleView()
        view.mRuleTextView.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.dd.color(hexValue: 0x1053FF)]
        view.updateRule(text: self._ruleText())
        view.mRuleTextView.delegate = self
        return view
    }()
    
    lazy var mPlaceOrderBottomView: DDPlaceOrderBottomView = {
        let view = DDPlaceOrderBottomView()
        return view
    }()
}

extension ConfirmOrderVC {
    
    func _ruleText() -> NSAttributedString {
        let mutAttStr = NSMutableAttributedString(string: "Agree to Easyart Purchase Agreement".localString + " ", attributes: [.foregroundColor: UIColor.dd.color(hexValue: 0x000000)])
        let attStr1 = NSMutableAttributedString(string: "Easyart Purchase and Sales Agreement".localString)
        attStr1.addAttribute(.link, value: "HDRulePopUserRule://", range: NSRange(location: 0, length: attStr1.length))
        mutAttStr.append(attStr1)
        mutAttStr.addAttributes([.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.dd.color(hexValue: 0x000000)], range: NSRange(location: 0, length: mutAttStr.length))
        
        return mutAttStr
    }
    
    func _loadData() {
        HDHUD.show(icon: .loading, duration: -1)
        _ = DDAPI.shared.request("goods/detail", data: ["goods_id": self.model.goodsID]).subscribe(onSuccess: { [weak self] response in
            HDHUD.hide()
            guard let self = self else { return }
            let data = JSON(response.data)
            self.pageInfo.accept(data)
            self.addressID.accept(data["address_info"]["id"].stringValue)
            //购买协议
            if let addressModel = data["address_info"].dictionaryObject?.kj.model(DDAddressModel.self) {
                self.buyName = addressModel.getName()
                self.address = addressModel.getFullAddress()
            }
            self.artistName = data["goods_info"]["artist_name"].stringValue
            self.artworkName = data["goods_info"]["name"].stringValue
        }, onFailure: { _ in
            HDHUD.hide()
        })
    }
    
    func _bindView() {
        _ = self.mMessageTextView.mTextView.rx.observe(CGSize.self, "contentSize").subscribe(onNext: { [weak self] (contentSize) in
            guard let self = self, let contentSize = contentSize else { return }
                self.mMessageTextView.snp.updateConstraints { (make) in
                    make.height.equalTo(max(16, contentSize.height))
            }
        })
        _ = self.model.packageViewModel.packageIndex.subscribe(onNext: { [weak self] index in
            guard let self = self else { return }
            if index != nil {
                self.mPackageBGView.isHidden = false
                self.mPackageBGView.snp.updateConstraints { make in
                    make.height.lessThanOrEqualTo(MAXFLOAT)
                }
            } else {
                self.mPackageBGView.isHidden = true
                self.mPackageBGView.snp.updateConstraints { make in
                    make.height.lessThanOrEqualTo(0)
                }
            }
        })
        
        _ = self.pageInfo.subscribe(onNext: { [weak self] json in
            guard let self = self else { return }
            if let address = json["address_info"].dictionaryObject {
                let model = address.kj.model(DDAddressModel.self)
                self.mAddressInfoView.updateUI(address: model)
            }
            self.payPrice = self.model.skuInfo["pay_price"].stringValue
            
            self.mGoodsInfoView.updateUI(info: json["goods_info"], model: self.model)
            self.mPriceView.mContentLabel.text = "$" + self.model.skuInfo["pay_price"].stringValue
            self.mPackageView.mContentLabel.text = "$" + self.model.packageViewModel.getTotalPrice()
            self.mPackageContentLabel.text = self.model.packageViewModel.getPackageString()
            //装潢费
            self.totalPrice = self.model.skuInfo["pay_price"].floatValue + (Float(self.model.packageViewModel.getTotalPrice()) ?? 0)
            self._updateTotalPrice()
        })
        
        _ = self.mRuleView.selectChange.subscribe(onNext: { [weak self] isSelected in
            self?.isAcceptRule.accept(isSelected)
        })
        
        _ = self.isAcceptRule.subscribe(onNext: { [weak self] isSelected in
            guard let self = self else { return }
            if isSelected {
                self.mPlaceOrderBottomView.mConfirmButton.isSelected = true
            } else {
                self.mPlaceOrderBottomView.mConfirmButton.isSelected = false
            }
            self.mRuleView.mRuleButton.isSelected = isSelected
        })
        
        _ = self.mAddressInfoView.clickPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let vc = AddressManageVC(bottomPadding: 50)
            _  = vc.addressChangeRelay.subscribe(onNext: { [weak self] address in
                guard let self = self, let address = address else { return }
                self.addressID.accept(address.id)
                self.buyName = address.getName()
                self.address = address.getFullAddress()
                self.mAddressInfoView.updateUI(address: address)
            })
            vc.selectedModel = self.mAddressInfoView.mAddressModel
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
        _ = self.mPlaceOrderBottomView.clickPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            if self.isAcceptRule.value {
                if self.mDHLShippingFeeView.isSelected || self.mSFShippingFeeView.isSelected {
                    self._placeOrder()
                } else {
                    let goodsInfo = self.pageInfo.value["goods_info"]
                    let string = "Inquire about artwork #\(goodsInfo["name"].stringValue), \(goodsInfo["artist_name"].stringValue)"
                    let subject = string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? string
                    UIApplication.shared.open(URL(string: "mailto:info@easyart.cn?subject=\(subject)")!)
                }
            } else {
                self._showRulePopView()
            }
        })
        
        _ = self.mSFShippingFeeView.clickPublish.subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.mDHLShippingFeeView.isSelected = false
                self.mPlaceOrderBottomView.mConfirmButton.setTitle("Submit order".localString, for: .normal)
                self._logisticsCost(type: 2)
        })
        
        _ = self.mDHLShippingFeeView.clickPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.mSFShippingFeeView.isSelected = false
            self.mPlaceOrderBottomView.mConfirmButton.setTitle("Submit order".localString, for: .normal)
            self._logisticsCost(type: 1)
        })
        
//        _ = self.mOtherShippingFeeView.clickPublish.subscribe(onNext: { [weak self] _ in
//            guard let self = self else { return }
//            self.mDHLShippingFeeView.isSelected = false
//            self.mPlaceOrderBottomView.mConfirmButton.setTitle("Contact".localString, for: .normal)
//            self._updateTotalPrice()
//        })
        
        _ = self.addressID.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self._logisticsCost(type: 1)
            self._logisticsCost(type: 2)
        })
    }
    
    func _placeOrder() {
        HDHUD.show(icon: .loading, duration: -1)
        var logistics_cost_type = 1
        if self.mDHLShippingFeeView.isSelected {
            logistics_cost_type = 1
        } else if self.mSFShippingFeeView.isSelected {
            logistics_cost_type = 2
        }
        var data: [String : Any] = [
            "goods_id": self.model.goodsID,
            "sku_id": self.model.skuInfo["id"].stringValue,
            "pay_type": 3,
            "addr_id": self.addressID.value,
            "leave_msg": self.mMessageTextView.text,
            "number_id": self.model.numberID ?? "0",
            "type": 0,
            "logistics_cost_type": logistics_cost_type
        ]
        let viewModel = self.model.packageViewModel
        if let index = viewModel.packageIndex.value {
            data["border_id"] = viewModel.getBorderPriceID()
            data["paper_id"] = viewModel.getPaperPriceID()
            data["paddingId"] = viewModel.getPaddingID()
            data["isAcrylic"] = viewModel.getAcrylic() ? "1" : "0"
            data["mountingType"] = viewModel.packageConfigList.value[index]["id"].intValue
            data["decorate_info"] = viewModel.getPackageString()
        }
        _ = DDAPI.shared.request("goods/order", data: data).subscribe(onSuccess: { [weak self] response in
            HDHUD.hide()
            guard let self = self else { return }
            let data = JSON(response.data)
            let stripeInfo = data["stripe_info"]
            StripeTools.shared.resultPublish.subscribe(onNext: { [weak self] result in
                print("result", result)
                let vc = OrderDetailVC(orderID: data["order_id"].stringValue)
                self?.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: StripeTools.shared.disposeBag)
            StripeTools.shared.startPay(publishableKey: stripeInfo["publishableKey"].stringValue, customerID: stripeInfo["customer"].stringValue, ephemeralKey: stripeInfo["ephemeralKey"].stringValue, paymentIntent: stripeInfo["paymentIntent"].stringValue, productName: stripeInfo["description"].stringValue)
        }, onFailure: { error in
            HDHUD.hide()
            HDHUD.show(DDErrorProvider.localizedDescription(error), icon: .warn)
        })
    }
    
    func _logisticsCost(type: Int) {
        guard String.isAvailable(self.addressID.value) else { return }
        var requestData: [String: Any] = ["goods_id": self.model.goodsID, "sku_id": self.model.skuInfo["id"].intValue, "addr_id": self.addressID.value, "logistics_cost_type": type]
        if let index = self.model.packageViewModel.packageIndex.value {
            let viewModel = self.model.packageViewModel
            requestData["border_id"] = viewModel.getBorderPriceID()
            requestData["paper_id"] = viewModel.getPaperPriceID()
            requestData["paddingId"] = viewModel.getPaddingID()
            requestData["isAcrylic"] = viewModel.getAcrylic() ? "1" : "0"
            requestData["mountingType"] = viewModel.packageConfigList.value[index]["id"].intValue
        }
        _ = DDAPI.shared.request("goods/logisticsCost", data: requestData).subscribe(onSuccess: { [weak self] response in
            guard let self = self else { return }
            let json = JSON(response.data)
            self.logisticsCost = json["cost"].intValue
            self.insurance = json["insurance_info"]["cost"].intValue
            self.dutiesCost = json["import_duties_info"]["cost"].intValue
            if self.logisticsCost > 0 {
                if type == 1 {
                    self.mDHLShippingFeeView.mContentLabel.text = "$\(self.logisticsCost)"
                } else {
                    self.mSFShippingFeeView.mContentLabel.text = "$\(self.logisticsCost)"
                }
            } else {
                if type == 1 {
                    self.mDHLShippingFeeView.mContentLabel.text = "-"
                } else {
                    self.mSFShippingFeeView.mContentLabel.text = "-"
                }
            }
            
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
            let InsuranceAttri = NSAttributedString(string: " " + json["insurance_info"]["desc"].stringValue, attributes: [NSAttributedString.Key.foregroundColor : ThemeColor.lightGray.color(), .font: UIFont.systemFont(ofSize: 11)])
            InsuranceAttributed.append(InsuranceAttri)
            self.mInsuranceView.mTitleLabel.attributedText = InsuranceAttributed
            self.mInsuranceView.mContentLabel.text = "$" + json["insurance_info"]["cost"].stringValue
            self._updateTotalPrice()
        })
    }
    
    func _showRulePopView() {
        let pop = DDOrderRulePopView(buyName: self.buyName, artistName: self.artistName, artworkName: self.artworkName, payPrice: "\(self.payPrice)", address: self.address)
        _ = pop.mClickSubject.subscribe(onNext: { [weak self] clickInfo in
            guard let self = self else { return }
            DDPopView.hide()
            if let isSelect = clickInfo.info as? Bool {
                self.isAcceptRule.accept(isSelect)
            }
        })
        DDPopView.show(view: pop)
    }
    
    func _updateTotalPrice() {
        if self.mDHLShippingFeeView.isSelected || self.mSFShippingFeeView.isSelected {
            self.mTotalView.mContentLabel.text = "$\(Int(self.totalPrice + Float(self.logisticsCost) + Float(self.dutiesCost) + Float(self.insurance)))"
            self.mPlaceOrderBottomView.mPriceLabel.text = "$\(Int(self.totalPrice + Float(self.logisticsCost) + Float(self.dutiesCost) + Float(self.insurance)))"
            self.mPlaceOrderBottomView.mConfirmButton.isEnabled = String.isAvailable(self.mAddressInfoView.mAddressModel?.id)
            self.mPlaceOrderBottomView.mTipLabel.text = "Including shipping cost".localString
        } else {
            self.mTotalView.mContentLabel.text = "$\(Int(self.totalPrice))"
            //底部
            self.mPlaceOrderBottomView.mPriceLabel.text = "$\(Int(self.totalPrice))"
            self.mPlaceOrderBottomView.mConfirmButton.isEnabled = true
            self.mPlaceOrderBottomView.mTipLabel.text = "Shipping fee Not included".localString
        }
        
    }
}

extension ConfirmOrderVC: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if url.scheme == "HDRulePopUserRule" {
            self._showRulePopView()
            return false
        } else if url.scheme == "HDRulePopPrivacy" {
            let vc = QLWebViewController(url: URL(string: WWWUrl_Base + "privacy/" + DDConfigTools.shared.getLanguage() )!)
            DDUtils.shared.getCurrentVC()?.present(vc, animated: true)
            return false
        }
        return false
    }
}
