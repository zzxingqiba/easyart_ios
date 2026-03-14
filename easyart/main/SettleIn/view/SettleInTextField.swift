//
//  SettleInTextField.swift
//  easyart
//
//  Created by Damon on 2024/12/17.
//

import UIKit

class SettleInTextField: DDView {
    var errorTitle = ""
    
    init(title: String) {
        super.init(frame: .zero)
        self.title = title
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isError = false {
        didSet {
            if isError {
                self.mLineView.backgroundColor = ThemeColor.red.color()
            } else {
                self.mLineView.backgroundColor = ThemeColor.line.color()
            }
        }
    }
    
    var title: String? {
        get {
            return self.mTitleLabel.text
        }
        set {
            self.mTitleLabel.text = newValue
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
    
    override func createUI() {
        self.addSubview(mTitleLabel)
        self.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
        
        mTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        self.addSubview(mTextField)
        mTextField.snp.makeConstraints { make in
            make.left.equalTo(self.snp.centerX)
            make.right.equalToSuperview().offset(30)
            make.top.bottom.equalToSuperview()
        }
        
        self.addSubview(mLineView)
        mLineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }

    //MARK: UI
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mTextField: DDTextFieldView = {
        let textField = DDTextFieldView()
        textField.mBottomLine.isHidden = true
        textField.mTextField.textAlignment = .right
        textField.mTextField.textColor = ThemeColor.black.color()
        textField.mTextField.placeholder = " Please enter".localString
        return textField
    }()
    
    lazy var mLineView: UIView = {
        let line = UIView()
        line.backgroundColor = ThemeColor.line.color()
        return line
    }()

}
