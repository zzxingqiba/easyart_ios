//
//  DDAppleAuthorPop.swift
//  HiTalk
//
//  Created by Damon on 2024/8/19.
//

import UIKit
import DDUtils
import RxSwift
import AuthenticationServices

class DDAppleAuthorPop: DDView {
    let mClickSubject = PublishSubject<DDPopButtonClickInfo>()
    
    override func createUI() {
        super.createUI()
        
        self.backgroundColor = UIColor.clear
        
        self.addSubview(mContentView)
        mContentView.snp.makeConstraints { make in
            make.width.equalTo(350)
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(80)
            make.bottom.equalToSuperview()
        }
        
        self.addSubview(mTitleImageView)
        mTitleImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(140)
            make.height.equalTo(80)
        }
        
        mContentView.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mTitleImageView.snp.bottom).offset(20)
        }
        
        mContentView.addSubview(mContentLabel)
        mContentLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.top.equalTo(mTitleLabel.snp.bottom).offset(20)
            
        }
        
        mContentView.addSubview(mAppleLoginButton)
        mAppleLoginButton.snp.makeConstraints { make in
            make.top.equalTo(mContentLabel.snp.bottom).offset(30)
            make.width.equalTo(150)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30)
        }
        
        self.addSubview(mCloseButton)
        mCloseButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(36)
            make.right.equalToSuperview().offset(10)
            make.width.height.equalTo(30)
        }
        
        self._bindView()
    }
    
    //MARK: UI
    lazy var mContentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.dd.color(hexValue: 0xffffff)
        view.layer.borderColor = UIColor.dd.color(hexValue: 0xffffff).cgColor
        view.layer.borderWidth = 3
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var mTitleImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "warn-icon"))
        return imageView
    }()
    
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = UIColor.dd.color(hexValue: 0xe8750f)
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    lazy var mContentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor.dd.color(hexValue: 0x000000)
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    lazy var mCloseButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon-close-white"), for: .normal)
        return button
    }()
    
    lazy var mAppleLoginButton: ASAuthorizationAppleIDButton = {
        let tButton = ASAuthorizationAppleIDButton()
        return tButton
    }()
}

extension DDAppleAuthorPop {
    func _bindView() {
        _ = self.mCloseButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.mClickSubject.onNext(DDPopButtonClickInfo(clickType: .close, info: nil))
        })
        
        self.mAppleLoginButton.addTarget(self, action: #selector(_startHandleAuthor), for: UIControl.Event.touchUpInside)
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
}

extension DDAppleAuthorPop: ASAuthorizationControllerDelegate {
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential, let identityToken = appleIDCredential.identityToken, let token = String(data: identityToken, encoding: .utf8) {
            print("appleIDCredential", appleIDCredential, appleIDCredential.user)
            self.mClickSubject.onNext(DDPopButtonClickInfo(clickType: .confirm, info: token))
        }
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        //        self.buttonClick.onNext(HDPopButtonClickInfo(clickType: .cancel, info: nil))
    }
}
