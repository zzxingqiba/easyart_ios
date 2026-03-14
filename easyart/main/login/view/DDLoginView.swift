//
//  DDLoginView.swift
//  HiTalk
//
//  Created by Damon on 2024/8/14.
//

import UIKit
import AuthenticationServices
import GoogleSignIn
import RxRelay
import HDHUD
import SwiftyJSON
import DDUtils

class DDLoginView: DDView {
    let loginResult: PublishRelay<Bool> = PublishRelay<Bool>()
    let closeClick: PublishRelay<Void> = PublishRelay()
    let registClick: PublishRelay<Void> = PublishRelay()
    let emailClick: PublishRelay<Void> = PublishRelay()
    
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
        
        self.addSubview(mAppleLoginButton)
        mAppleLoginButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(18)
            make.right.equalToSuperview().offset(-18)
            make.top.equalTo(mTipLabel.snp.bottom).offset(20)
            make.height.equalTo(45)
        }
        
        self.addSubview(mGoogleLoginButton)
        mGoogleLoginButton.snp.makeConstraints { make in
            make.left.right.equalTo(mAppleLoginButton)
            make.top.equalTo(mAppleLoginButton.snp.bottom).offset(20)
            make.height.equalTo(mAppleLoginButton)
        }
        
        let orView = UIView()
        orView.backgroundColor = ThemeColor.line.color()
        self.addSubview(orView)
        orView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mGoogleLoginButton.snp.bottom).offset(40)
            make.width.equalTo(90)
            make.height.equalTo(1)
        }
        
        self.addSubview(mORLabel)
        mORLabel.snp.makeConstraints { make in
            make.center.equalTo(orView)
        }
        
        self.addSubview(mRegistButton)
        mRegistButton.snp.makeConstraints { make in
            make.left.right.equalTo(mAppleLoginButton)
            make.top.equalTo(mORLabel.snp.bottom).offset(40)
            make.height.equalTo(mAppleLoginButton)
        }
        
        self.addSubview(mCancelButton)
        mCancelButton.snp.makeConstraints { make in
            make.left.right.equalTo(mAppleLoginButton)
            make.top.equalTo(mRegistButton.snp.bottom).offset(20)
            make.height.equalTo(mAppleLoginButton)
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
        label.text = "Please choose a login method".localString
        return label
    }()
    
    lazy var mAppleLoginButton: ASAuthorizationAppleIDButton = {
        let tButton = ASAuthorizationAppleIDButton()
        return tButton
    }()
    
    lazy var mGoogleLoginButton: GIDSignInButton = {
        let button = GIDSignInButton()
        button.colorScheme = .light
        button.style = .wide
        return button
    }()
    
    lazy var mORLabel: PaddingLabel = {
        let label = PaddingLabel(withInsets: 2, 2, 10, 10)
        label.backgroundColor = UIColor.dd.color(hexValue: 0xffffff)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        label.textColor = UIColor.dd.color(hexValue: 0x999999)
        label.text = "Or".localString
        return label
    }()
    
    lazy var mRegistButton: DDButton = {
        let button = DDButton()
        button.backgroundColor = UIColor.dd.color(hexValue: 0xffffff)
        button.imageSize = CGSize(width: 14, height: 15)
        button.mImageView.image = UIImage(named: "icon-regist")
        button.mTitleLabel.textColor = ThemeColor.black.color()
        button.mTitleLabel.font = .systemFont(ofSize: 14)
        button.mTitleLabel.text = "Sign in with Email".localString
        button.layer.borderColor = ThemeColor.black.color().cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    lazy var mCancelButton: DDButton = {
        let button = DDButton()
        button.imageSize = .zero
        button.contentType = .center(gap: 0)
        button.backgroundColor = UIColor.dd.color(hexValue: 0xffffff)
        button.mTitleLabel.textColor = ThemeColor.black.color()
        button.mTitleLabel.font = .systemFont(ofSize: 14)
        button.mTitleLabel.text = "Cancel".localString
        button.layer.borderColor = ThemeColor.black.color().cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    lazy var mRuleView: DDRuleView = {
        let view = DDRuleView()
        view.mRuleTextView.delegate = self
        return view
    }()
}

extension DDLoginView {
    
    func _loadData() {
        self.mRuleView.updateRule(text: _ruleText())
    }
    
    func _bindView() {
        self.mAppleLoginButton.addTarget(self, action: #selector(_startHandleAuthor), for: UIControl.Event.touchUpInside)
        self.mGoogleLoginButton.addTarget(self, action: #selector(_googleLogin), for: .touchUpInside)
        
        _ = self.mRegistButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.registClick.accept(())
        })
        
        _ = self.mCancelButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.closeClick.accept(())
        })
    }
    
    @objc func _startHandleAuthor() -> Void {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        //            authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    @objc func _googleLogin() {
        HDHUD.show(icon: .loading, duration: -1, mask: true)
        GIDSignIn.sharedInstance.signIn(withPresenting: DDUtils.shared.getCurrentVC()!) { [weak self] result, error in
            HDHUD.hide()
            guard let self = self, error == nil else { return }
            guard let signInResult = result else { return }
            let user = signInResult.user
            let emailAddress = user.profile?.email
            let userID = user.userID
            let fullName = user.profile?.name
            let profilePicUrl = user.profile?.imageURL(withDimension: 320)
            _ = DDUserTools.shared.googleLogin(email: emailAddress, userID: userID, name: fullName, avatar: profilePicUrl?.absoluteString).subscribe(onSuccess: { [weak self] isLogin in
                self?.loginResult.accept(isLogin)
            })
        }
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



extension DDLoginView: ASAuthorizationControllerDelegate {
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential, let identityToken = appleIDCredential.identityToken, let token = String(data: identityToken, encoding: .utf8) {
            print("appleIDCredential", appleIDCredential, appleIDCredential.user)
            let idList = appleIDCredential.user.components(separatedBy: ".")
            if idList.count > 2 {
                let id = idList[1]
                _ = DDUserTools.shared.appleLogin(code: id, token: token).subscribe(onSuccess: { [weak self] isLogin in
                    self?.loginResult.accept(isLogin)
                })
            }
            
        }
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        //        self.buttonClick.onNext(HDPopButtonClickInfo(clickType: .cancel, info: nil))
    }
}

extension DDLoginView: UITextViewDelegate {
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
