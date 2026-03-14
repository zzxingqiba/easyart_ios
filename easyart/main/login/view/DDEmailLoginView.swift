//
//  DDEmailLoginView.swift
//  easyart
//
//  Created by Damon on 2024/9/27.
//

import UIKit
import RxRelay
import HDHUD
import SwiftyJSON
import DDUtils

class DDEmailLoginView: DDView {
    let loginResult: PublishRelay<Bool> = PublishRelay<Bool>()
    let closeClick: PublishRelay<Void> = PublishRelay()
    
    var isRegist: Bool = false {
        didSet {
            self.mTitleLabel.text = isRegist ? "Register now".localString : "Welcome".localString
        }
    }
    
    override func createUI() {
        super.createUI()
        self.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(50)
        }
        
        self.addSubview(mTipLabel)
        mTipLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mTitleLabel.snp.bottom).offset(40)
        }
        
        self.addSubview(mEmailTextField)
        mEmailTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(18)
            make.right.equalToSuperview().offset(-18)
            make.top.equalTo(mTipLabel.snp.bottom).offset(20)
            make.height.equalTo(45)
        }
        
        self.addSubview(mCodeTextField)
        mCodeTextField.snp.makeConstraints { make in
            make.left.right.equalTo(mEmailTextField)
            make.top.equalTo(mEmailTextField.snp.bottom).offset(20)
            make.height.equalTo(mEmailTextField)
        }
        
        mCodeTextField.addSubview(mCodeView)
        mCodeView.snp.makeConstraints { make in
            make.right.top.bottom.equalToSuperview()
            make.width.equalTo(200)
        }
        
        self.addSubview(mLoginButton)
        mLoginButton.snp.makeConstraints { make in
            make.left.right.equalTo(mEmailTextField)
            make.top.equalTo(mCodeTextField.snp.bottom).offset(20)
            make.height.equalTo(mEmailTextField)
        }
        
        self.addSubview(mCancelButton)
        mCancelButton.snp.makeConstraints { make in
            make.left.right.equalTo(mEmailTextField)
            make.top.equalTo(mLoginButton.snp.bottom).offset(20)
            make.height.equalTo(mEmailTextField)
        }
        
        self.addSubview(mRuleView)
        mRuleView.snp.makeConstraints { make in
            make.top.equalTo(mCancelButton.snp.bottom).offset(50)
            make.bottom.equalToSuperview().offset(-100)
            make.centerX.equalToSuperview()
        }
        
        
        self._bindView()
        self._loadData()
    }

    //MARK: UI
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 36, weight: .bold)
        label.textColor = ThemeColor.black.color()
        label.text = "Welcome".localString
        return label
    }()
    
    lazy var mTipLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.black.color()
        label.text = "Please enter email information".localString
        return label
    }()
    
    lazy var mEmailTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .emailAddress
        textField.layer.borderWidth = 1
        textField.layer.borderColor = ThemeColor.black.color().cgColor
        textField.textColor = ThemeColor.black.color()
        textField.leftView = UIView(frame: CGRectMake(0, 0, 50, 40))
        let imageView = UIImageView(image: UIImage(named: "icon-email-b"))
        imageView.frame = CGRectMake(18, 14, 14, 12)
        textField.leftView?.addSubview(imageView)
        textField.leftViewMode = .always
        textField.placeholder = "Example@email.com"
        textField.font = .systemFont(ofSize: 14)
        return textField
    }()
    
    lazy var mCodeTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.layer.borderWidth = 1
        textField.layer.borderColor = ThemeColor.black.color().cgColor
        textField.textColor = ThemeColor.black.color()
        textField.leftView = UIView(frame: CGRectMake(0, 0, 50, 40))
        let imageView = UIImageView(image: UIImage(named: "icon-email-b"))
        imageView.frame = CGRectMake(18, 14, 14, 12)
        textField.leftView?.addSubview(imageView)
        textField.leftViewMode = .always
        textField.placeholder = "1234"
        textField.font = .systemFont(ofSize: 14)
        return textField
    }()
    
    lazy var mCodeView: CodeView = {
        let view = CodeView()
        return view
    }()
    
    lazy var mLoginButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = ThemeColor.black.color()
        button.setTitle("Submit and log in".localString, for: .normal)
        button.setTitleColor(UIColor.dd.color(hexValue: 0xffffff), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        return button
    }()
    
    lazy var mCancelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = ThemeColor.black.color()
        button.setTitle("Cancel".localString, for: .normal)
        button.setTitleColor(UIColor.dd.color(hexValue: 0xffffff), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        return button
    }()
    
    lazy var mRuleView: DDRuleView = {
        let view = DDRuleView()
        view.mRuleTextView.delegate = self
        return view
    }()
}

extension DDEmailLoginView {
    func _loadData() {
        self.mRuleView.updateRule(text: _ruleText())
    }
    
    func _bindView() {
        _ = self.mLoginButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            if (self.mRuleView.mRuleButton.isSelected) {
                self._login()
            } else {
                HDHUD.show("Please agree to the terms of service and privacy policy".localString, icon: .error)
            }
        })
        
        _ = self.mCancelButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.closeClick.accept(())
        })
        
        _ = self.mCodeView.mClickRelay.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            if !String.isAvailable(self.mEmailTextField.text) {
                return
            }
            self.mCodeView.startCountDown()
            _ = DDAPI.shared.request("login/sendEmail", data: ["email": self.mEmailTextField.text!]).subscribe(onSuccess: { _ in
                HDHUD.show("Verification code sent successfully".localString)
            })
        })
    }
    
    func _login() {
        _ = DDUserTools.shared.login(email: self.mEmailTextField.text, code: self.mCodeTextField.text).subscribe(onSuccess: { success in
            self.loginResult.accept(success)
        })
    }
    
    func _ruleText() -> NSAttributedString {
        let mutAttStr = NSMutableAttributedString(string: "Login to agree to the following terms".localString + " ", attributes: [.foregroundColor: UIColor.dd.color(hexValue: 0x000000)])
        let attStr1 = NSMutableAttributedString(string: "Service Terms".localString)
        attStr1.addAttribute(.link, value: "HDRulePopUserRule://", range: NSRange(location: 0, length: attStr1.length))
        let attStr2 = NSMutableAttributedString(string: " " + "&" + " ")
        let attStr3 = NSMutableAttributedString(string: "Privacy Policy".localString)
        attStr3.addAttribute(.link, value: "HDRulePopPrivacy://", range: NSRange(location: 0, length: attStr3.length))
        let attStr4 = NSMutableAttributedString(string: " " + "&" + " ")
        let attStr5 = NSMutableAttributedString(string: "Membership Agreement".localString)
        attStr5.addAttribute(.link, value: "HDRulePopMember://", range: NSRange(location: 0, length: attStr5.length))
        mutAttStr.append(attStr1)
        mutAttStr.append(attStr2)
        mutAttStr.append(attStr3)
        mutAttStr.append(attStr4)
        mutAttStr.append(attStr5)
        mutAttStr.addAttributes([.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.dd.color(hexValue: 0x000000)], range: NSRange(location: 0, length: mutAttStr.length))
        
        return mutAttStr
    }
}

extension DDEmailLoginView: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if url.scheme == "HDRulePopUserRule" {
//            let vc = QLWebViewController(url: URL(string: "https://www.easyartonline.com/agreement/service")!)
//            vc.hidesBottomBarWhenPushed = true
//            DDUtils.shared.getCurrentVC()?.navigationController?.pushViewController(vc, animated: true)
            UIApplication.shared.open(URL(string: "https://www.easyartonline.com/agreement/service")!)
            return false
        } else if url.scheme == "HDRulePopPrivacy" {
            UIApplication.shared.open(URL(string: "https://www.easyartonline.com/agreement")!)
//            let vc = QLWebViewController(url: URL(string: "https://www.easyartonline.com/agreement")!)
//            vc.hidesBottomBarWhenPushed = true
//            DDUtils.shared.getCurrentVC()?.navigationController?.pushViewController(vc, animated: true)
            return false
        } else if url.scheme == "HDRulePopMember" {
//            let vc = QLWebViewController(url: URL(string: "https://www.easyartonline.com/agreement/member")!)
//            vc.hidesBottomBarWhenPushed = true
//            DDUtils.shared.getCurrentVC()?.navigationController?.pushViewController(vc, animated: true)
            UIApplication.shared.open(URL(string: "https://www.easyartonline.com/agreement/member")!)
            return false
        }
        return false
    }
}
