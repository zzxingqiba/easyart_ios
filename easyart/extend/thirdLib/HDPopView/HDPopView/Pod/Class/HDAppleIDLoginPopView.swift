//
//  HDAppleIDLoginPopView.swift
//  HDPopView
//
//  Created by Damon on 2021/3/4.
//

import UIKit
import RxSwift
import DDUtils
#if canImport(AuthenticationServices)
import AuthenticationServices
#endif

@available(iOS 13.0, *)
public struct HDAppleIDLoginUserModel {
    public var userID = ""
    public var email: String? = nil
    public var fullName = ""
    public var originalInfo: ASAuthorizationAppleIDCredential? = nil
}

@available(iOS 13.0, *)
open class HDAppleIDLoginPopView: HDPopContentView {
    private let buttonClick = PublishSubject<HDPopButtonClickInfo>()

    public convenience init(title:String?, content:String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.3
        paragraphStyle.alignment = .center
        let attributed = NSAttributedString(string: content, attributes: [NSAttributedString.Key.paragraphStyle : paragraphStyle])
        self.init(title: title, content: attributed)
    }

    public init(title:String?, content:NSAttributedString) {
        super.init(frame: CGRect.zero)
        self._createUI()
        self._bindView()
        self.mTitleLabel.text = title
        self.mContentLabel.attributedText = content
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    //MARK: UI
    public private(set) lazy var mTitleLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.textColor = UIColor.dd.color(hexValue: 0x000000)
        tLabel.font = .systemFont(ofSize: 20, weight: .medium)
        tLabel.textAlignment = .center
        return tLabel
    }()

    private lazy var mContentLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.numberOfLines = 0
        tLabel.textColor = UIColor.dd.color(hexValue: 0x666666)
        tLabel.font = .systemFont(ofSize: 14)
        tLabel.lineBreakMode = .byCharWrapping
        return tLabel
    }()


    public private(set) lazy var mConfirmButton: ASAuthorizationAppleIDButton = {
        let tButton = ASAuthorizationAppleIDButton()
        return tButton
    }()

    public private(set) lazy var mCancelButton: UIButton = {
        let tButton = UIButton(type: .custom)
        tButton.backgroundColor = UIColor.dd.color(hexValue: 0xeeeeee)
        tButton.titleLabel?.font = .systemFont(ofSize: 16)
        tButton.setTitleColor(UIColor.dd.color(hexValue: 0x333333), for: .normal)
        tButton.setTitle(NSLocalizedString("取消", comment: ""), for: .normal)
        tButton.layer.cornerRadius = 6
        return tButton
    }()

}

@available(iOS 13.0, *)
private extension HDAppleIDLoginPopView {
    func _createUI() {
        self.backgroundColor = UIColor.dd.color(hexValue: 0xffffff)
        self.layer.cornerRadius = 12
        self.snp.makeConstraints { (make) in
            make.width.equalTo(310)
        }

        self.addSubview(self.mTitleLabel)
        self.mTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(20)
        }

        self.addSubview(self.mContentLabel)
        self.mContentLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.top.equalTo(self.mTitleLabel.snp.bottom).offset(10)
        }

        self.addSubview(self.mConfirmButton)
        self.mConfirmButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.top.equalTo(mContentLabel.snp.bottom).offset(30)
            make.height.equalTo(40)
        }

        self.addSubview(mCancelButton)
        mCancelButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.top.equalTo(mConfirmButton.snp.bottom).offset(20)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().offset(-20)
        }
    }

    func _bindView() {
        self.mConfirmButton.addTarget(self, action: #selector(_startHandleAuthor), for: UIControl.Event.touchUpInside)

        _ = mCancelButton.rx.tap.map { _ in
            return HDPopButtonClickInfo(clickType: .cancel, info: nil)
        }.bind(to: self.clickBinder)

        _ = buttonClick.bind(to: self.clickBinder)
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

@available(iOS 13.0, *)
extension HDAppleIDLoginPopView: ASAuthorizationControllerDelegate {
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            var loginUser = HDAppleIDLoginUserModel()
            loginUser.originalInfo = appleIDCredential
            loginUser.userID = appleIDCredential.user
            loginUser.email = appleIDCredential.email
            if let fullName = appleIDCredential.fullName {
                loginUser.fullName = "\(fullName.givenName ?? "")" + "\(fullName.middleName ?? "")" + "\(fullName.familyName ?? "")"
                //名称为空，使用昵称
                if loginUser.fullName.isEmpty {
                    loginUser.fullName = "\(fullName.nickname ?? "")"
                }
            }
            if loginUser.fullName.isEmpty {
                let userIDArray = loginUser.userID.components(separatedBy: ".")
                loginUser.fullName = "AppleID" + NSLocalizedString("用户", comment: "") + (userIDArray.first ?? "")
            }
            self.buttonClick.onNext(HDPopButtonClickInfo(clickType: .confirm, info: loginUser))
        }
    }

    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.buttonClick.onNext(HDPopButtonClickInfo(clickType: .cancel, info: nil))
    }
}
