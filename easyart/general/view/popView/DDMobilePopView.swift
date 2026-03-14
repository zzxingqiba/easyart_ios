//
//  DDMobilePopView.swift
//  Menses
//
//  Created by Damon on 2020/8/30.
//  Copyright © 2020 Damon. All rights reserved.
//

import UIKit
import DDUtils
import RxSwift
import HDHUD

class DDMobilePopView: UIView {
    let mClickSubject = PublishSubject<DDPopButtonType>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.p_createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func p_createUI() {
        let view = UIView()
        view.backgroundColor = UIColor.dd.color(hexValue: 0xffffff)
        view.layer.cornerRadius = 12
        self.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.width.equalTo(320)
        }

        view.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(20)
        }

        view.addSubview(mPhoneTextField)
        mPhoneTextField.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.top.equalTo(mTitleLabel.snp.bottom).offset(20)
            make.height.equalTo(48)
        }
        
        view.addSubview(mCodeTextField)
        mCodeTextField.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(mPhoneTextField)
            make.top.equalTo(mPhoneTextField.snp.bottom).offset(20)
        }
        
        mCodeTextField.addSubview(mCodeButton)
        mCodeButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(24)
        }
        

        view.addSubview(mConfirmButton)
        mConfirmButton.snp.makeConstraints { (make) in
            make.top.equalTo(mCodeTextField.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.greaterThanOrEqualTo(150)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().offset(-20)
        }

        self.addSubview(mCloseButton)
        mCloseButton.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
        
        _ = self.mPhoneTextField.mTextField.rx.text.subscribe(onNext: { (phone) in
            
        })
        _ = self.mCodeTextField.mTextField.rx.text.subscribe(onNext: { (code) in
            
        })
        
        //点击获取验证码
        _ = mCodeButton.rx.tap.subscribe(onNext: { [weak self] (_) in
            self?.p_sendCode()
        })
        
        _ = mConfirmButton.rx.tap.subscribe(onNext: { [weak self] (_) in
            self?.p_bindPhone()
        })

        _ = mCloseButton.rx.tap.subscribe(onNext: { [weak self] (_) in
            self?.mClickSubject.onNext(.close)
        })
    }
    
    //请求验证码
    func p_sendCode() {
        guard let phoneText = self.mPhoneTextField.mTextField.text, !phoneText.isEmpty else {
            HDHUD.show( "请填写手机号")
            return
        }
        _ = DDAPI.shared.request("home/getCode", data: ["phone": phoneText]).subscribe(onSuccess: { (response) in
            HDHUD.show( "验证码发送成功，请注意查收")
        })
    }
    
    func p_bindPhone() {
        guard let phoneText = self.mPhoneTextField.mTextField.text, !phoneText.isEmpty else {
            HDHUD.show( "请填写手机号")
            return
        }
        guard let codeText = self.mCodeTextField.mTextField.text, !codeText.isEmpty else {
            HDHUD.show( "请填写验证码")
            return
        }
        _ = DDAPI.shared.request("home/bindPhone", data: ["phone": phoneText, "code": codeText]).subscribe(onSuccess: { [weak self] (response) in
            HDHUD.show( "手机号绑定成功")
            self?.mClickSubject.onNext(.confirm)
        })        
    }
    
    //MARK: Lazy
    lazy var mTitleLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.text = "手机号验证"
        tLabel.textAlignment = .center
        tLabel.font = .systemFont(ofSize: 20)
        tLabel.textColor = UIColor.dd.color(hexValue: 0x333333)
        return tLabel
    }()
    
    
    lazy var mPhoneTextField: DDTextFieldView = {
        let tTextField = DDTextFieldView(title: "手机号", icon: nil, imageSize: .zero)
        return tTextField
    }()
    
    lazy var mCodeTextField: DDTextFieldView = {
        let tTextField = DDTextFieldView(title: "验证码", icon: nil, imageSize: .zero)
        return tTextField
    }()
    
    lazy var mCodeButton: UIButton = {
        let tButton = UIButton(type: .custom)
        tButton.backgroundColor = UIColor.dd.color(hexValue: 0xFB4374)
//        tButton.setBackgroundImage(UIImage.dd.getLinearGradientImage(colors: [UIColor.dd.color(hexValue: 0xFF1626), UIColor.dd.color(hexValue: 0xFF9E2C)], directionType: .leftToRight, size: CGSize(width: 10, height: 10)), for: .normal)
        tButton.setTitleColor(UIColor.dd.color(hexValue: 0xffffff), for: .normal)
        tButton.setTitle("获取验证码", for: .normal)
        tButton.titleLabel?.font = .systemFont(ofSize: 13)
        tButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
        tButton.layer.masksToBounds = true
        tButton.layer.cornerRadius = 12
        return tButton
    }()
    
    lazy var mConfirmButton: UIButton = {
        let tButton = UIButton(type: .custom)
        tButton.backgroundColor = UIColor.dd.color(hexValue: 0xFB4374)
        tButton.setTitleColor(UIColor.dd.color(hexValue: 0xffffff), for: .normal)
        tButton.setTitle("确定输入", for: .normal)
        tButton.layer.cornerRadius = 20
        return tButton
    }()
    
    lazy var mCloseButton: UIButton = {
        let tButton = UIButton(type: .custom)
        let attributedString = NSMutableAttributedString(string: "点击关闭")
        attributedString.bs_font = .systemFont(ofSize: 18)
        attributedString.bs_color = UIColor.dd.color(hexValue: 0xffffff)
        attributedString.bs_underlineStyle = .single
        attributedString.bs_underlineColor = UIColor.dd.color(hexValue: 0xffffff)
        tButton.setAttributedTitle(attributedString, for: .normal)
        return tButton
    }()

}
