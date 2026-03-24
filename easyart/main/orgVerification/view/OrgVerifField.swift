//
//  OrgNameTextField.swift
//  easyart
//
//  Created by 崭新的旧刀 on 2026/3/24.
//
import UIKit

class OrgVerifField: DDView {
    var errorTitle = ""
    
    /// 前缀文本
    var prefixText: String? {
        didSet {
            mPreLabel.text = prefixText
            mPreLabel.isHidden = (prefixText == nil)
        }
    }
    
    /// 键盘类型
    var keyboardType: UIKeyboardType = .default {
        didSet {
            mTextField.mTextField.keyboardType = keyboardType
        }
    }
    
    init(title: String) {
        super.init(frame: .zero)
        self.title = title
    }
    
    @available(*, unavailable)
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isError = false {
        didSet {
            if isError {
                mLineView.backgroundColor = ThemeColor.red.color()
            } else {
                mLineView.backgroundColor = ThemeColor.line.color()
            }
        }
    }
    
    var title: String? {
        get {
            return mTitleLabel.text
        }
        set {
            mTitleLabel.text = newValue
        }
    }
    
    var placeholder: String? {
        get {
            return mTextField.mTextField.placeholder
        }
        set {
            mTextField.mTextField.placeholder = newValue
        }
    }
    
    var text: String? {
        get {
            return mTextField.mTextField.text
        }
        set {
            mTextField.mTextField.text = newValue
        }
    }
    
    // MARK: - UI Setup
    
    override func createUI() {
        addSubview(mTitleLabel)
        snp.makeConstraints { make in
            make.height.equalTo(60)
        }
        
        mTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        // 添加前缀标签（默认隐藏）
        addSubview(mPreLabel)
        mPreLabel.isHidden = true
        mPreLabel.snp.makeConstraints { make in
            make.left.equalTo(mTitleLabel.snp.right).offset(5)
            make.centerY.equalToSuperview()
        }
        
        addSubview(mTextField)
        mTextField.snp.makeConstraints { make in
            make.left.equalTo(self.snp.centerX)
            make.right.equalToSuperview().offset(30)
            make.top.bottom.equalToSuperview()
        }
        
        addSubview(mLineView)
        mLineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Convenience Methods
    
    /// 设置为手机号输入框
    func setupAsMobileField(countryCode: String = "+86") {
        prefixText = countryCode
        keyboardType = .numberPad
    }
    
    /// 设置为邮箱输入框
    func setupAsEmailField() {
        keyboardType = .emailAddress
        mTextField.mTextField.autocapitalizationType = .none
    }
    
    /// 设置为密码输入框
    func setupAsPasswordField() {
        keyboardType = .default
        mTextField.mTextField.isSecureTextEntry = true
    }
    
    // MARK: - UI Components
    
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mPreLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mTextField: DDTextFieldView = {
        let textField = DDTextFieldView()
        textField.mBottomLine.isHidden = true
        textField.mTextField.textAlignment = .right
        textField.mTextField.textColor = ThemeColor.black.color()
        textField.mTextField.placeholder = "Please enter".localString
        return textField
    }()
    
    lazy var mLineView: UIView = {
        let line = UIView()
        line.backgroundColor = ThemeColor.line.color()
        return line
    }()
}
