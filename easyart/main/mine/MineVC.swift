//
//  MineVC.swift
//  easyart
//
//  Created by 喵小呆 on 2026/3/14.
//
import SnapKit
import SwiftyJSON
import UIKit
import ZLPhotoBrowser

class MineVC: BaseVC {
    init() {
        super.init(bottomPadding: 50)
    }
    
    @available(*, unavailable)
    @MainActor required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._bindView()
    }
    
    override func createUI() {
        super.createUI()
        self.mSafeView.contentType = .flex
        
        self.mSafeView.addSubview(self.mImageView)
        self.mImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(30)
            make.width.height.equalTo(60)
        }
        self.mImageView.kf.setImage(with: URL(string: "https://www.gitkraken.com/wp-content/uploads/2024/08/KeifApp@2x.png"))
        
        self.mSafeView.addSubview(self.mEditImageView)
        self.mEditImageView.snp.makeConstraints { make in
            make.top.right.equalTo(self.mImageView)
            make.width.equalTo(23)
            make.height.equalTo(14)
        }
        
        self.mSafeView.addSubview(self.mSettingButton)
        self.mSettingButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.width.height.equalTo(20)
        }
        
        self.mSafeView.addSubview(self.mMessageButton)
        self.mMessageButton.snp.makeConstraints { make in
            make.top.equalTo(self.mSettingButton.snp.bottom).offset(20)
            make.centerX.equalTo(self.mSettingButton)
            make.width.height.equalTo(20)
        }
        
        self.mSafeView.addSubview(self.mMessageRedIcon)
        self.mMessageRedIcon.snp.makeConstraints { make in
            make.top.equalTo(self.mMessageButton).offset(-5)
            make.left.equalTo(self.mMessageButton.snp.right).offset(-3)
            make.width.height.equalTo(6)
        }
        
        self.mSafeView.addSubview(self.mNameTextFeild)
        self.mNameTextFeild.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.mImageView.snp.bottom).offset(0)
            make.height.equalTo(30)
        }
        
        // 入驻平台/艺术家
        self.mSafeView.addSubview(self.mBecomeButton)
        self.mBecomeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.mNameTextFeild.snp.bottom).offset(10)
            make.height.equalTo(30)
        }
        
        self.mSafeView.addSubview(self.mLoginButton)
        self.mLoginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.mNameTextFeild.snp.bottom).offset(10)
            make.height.equalTo(30)
        }
        
        self.mSafeView.addSubview(self.mFollowsNumberView)
        self.mFollowsNumberView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.top.equalTo(self.mBecomeButton.snp.bottom).offset(20)
        }
        
        let leftLine = UIView()
        leftLine.backgroundColor = UIColor.dd.color(hexValue: 0xE6E6E6)
        self.mSafeView.addSubview(leftLine)
        leftLine.snp.makeConstraints { make in
            make.right.equalTo(self.mFollowsNumberView.snp.left)
            make.centerY.equalTo(self.mFollowsNumberView)
            make.width.equalTo(1.5)
            make.height.equalTo(7.5)
        }
        
        self.mSafeView.addSubview(self.mSaveNumberView)
        self.mSaveNumberView.snp.makeConstraints { make in
            make.right.equalTo(leftLine.snp.left)
            make.width.equalTo(self.mFollowsNumberView)
            make.top.equalTo(self.mFollowsNumberView)
         }
        
        let rightLine = UIView()
        leftLine.backgroundColor = UIColor.dd.color(hexValue: 0xE6E6E6)
        self.mSafeView.addSubview(rightLine)
        rightLine.snp.makeConstraints { make in
            make.left.equalTo(self.mFollowsNumberView.snp.right)
            make.centerY.equalTo(self.mFollowsNumberView)
            make.width.equalTo(1.5)
            make.height.equalTo(7.5)
        }
        
        self.mSafeView.addSubview(self.mOrderNumberView)
        self.mOrderNumberView.snp.makeConstraints { make in
            make.left.equalTo(rightLine.snp.right)
            make.width.equalTo(self.mFollowsNumberView)
            make.top.equalTo(self.mFollowsNumberView)
        }
    }
    
    // MARK: UI
    
    lazy var mImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.kf.indicatorType = .activity
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = ThemeColor.line.color()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 30
        return imageView
    }()
    
    lazy var mEditImageView: UIImageView = {
        let imageView = UIImageView()
//        imageView.isHidden = true
        imageView.image = UIImage(named: "icon-edit-me")
        return imageView
    }()
    
    lazy var mSettingButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "me-icon-setting"), for: .normal)
        return button
    }()
    
    lazy var mMessageButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "me_message"), for: .normal)
        return button
    }()
    
    lazy var mMessageRedIcon: UIView = {
        let view = UIView()
//        view.isHidden = true
        view.backgroundColor = .red
        view.layer.cornerRadius = 3
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var mNameTextFeild: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.placeholder = "Enter nickname".localString
        textField.font = .systemFont(ofSize: 14)
        textField.textColor = ThemeColor.gray.color()
        textField.returnKeyType = .done
        return textField
    }()
    
    lazy var mBecomeButton: DDButton = {
        let button = DDButton(imagePosition: .none)
        button.contentType = .contentFit(padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20), gap: 0)
        button.mTitleLabel.textColor = ThemeColor.black.color()
        button.mTitleLabel.attributedText = NSAttributedString(string: "Join the platform".localString, attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, .underlineColor: ThemeColor.black.color()])
        button.mTitleLabel.font = .systemFont(ofSize: 12)
        return button
    }()
    
    lazy var mLoginButton: DDButton = {
        let button = DDButton(imagePosition: .none)
        button.isHidden = true
        button.contentType = .contentFit(padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20), gap: 0)
        button.mTitleLabel.textColor = ThemeColor.black.color()
        button.mTitleLabel.text = "Log in".localString
        button.layer.borderColor = UIColor.dd.color(hexValue: 0xA39FAC).cgColor
        button.layer.borderWidth = 0.5
        button.mTitleLabel.font = .systemFont(ofSize: 12)
        button.layer.cornerRadius = 15
        return button
    }()
    
    lazy var mSaveNumberView: MineNumberItemView = {
        let view = MineNumberItemView()
        view.mIconButton.normalImage = UIImage(named: "me-icon-save")
        view.mIconButton.mTitleLabel.text = "Save"
        view.mNumberLabel.text = "0"
        return view
    }()
    
    lazy var mFollowsNumberView: MineNumberItemView = {
        let view = MineNumberItemView()
        view.mIconButton.normalImage = UIImage(named: "me-icon-follows")
        view.mIconButton.mTitleLabel.text = "Follows"
        view.mNumberLabel.text = "0"
        return view
    }()
    
    lazy var mOrderNumberView: MineNumberItemView = {
        let view = MineNumberItemView()
        view.mIconButton.normalImage = UIImage(named: "me-icon-order")
        view.mIconButton.mTitleLabel.text = "Order"
        view.mNumberLabel.text = "0"
        return view
    }()

    func _bindView() {}
}
