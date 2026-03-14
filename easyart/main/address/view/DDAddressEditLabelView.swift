//
//  DDAddressEditLabelView.swift
//  easyart
//
//  Created by Damon on 2024/10/31.
//

import UIKit

class DDAddressEditLabelView: DDView {
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
                mErrorLabel.text = self.errorTitle
                self.mTextField.mBottomLine.backgroundColor = ThemeColor.red.color()
            } else {
                mErrorLabel.text = nil
                self.mTextField.mBottomLine.backgroundColor = UIColor.dd.color(hexValue: 0x666666, alpha: 0.4)
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
        mTitleLabel.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
        }
        
        self.addSubview(mTextField)
        mTextField.snp.makeConstraints { make in
            make.left.right.equalTo(mTitleLabel)
            make.top.equalTo(mTitleLabel.snp.bottom)
            make.height.equalTo(50)
        }
        
        self.addSubview(mErrorLabel)
        mErrorLabel.snp.makeConstraints { make in
            make.left.right.equalTo(mTitleLabel)
            make.top.equalTo(mTextField.snp.bottom).offset(3)
            make.bottom.equalToSuperview()
        }
    }

    //MARK: UI
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mTextField: DDTextFieldView = {
        let textField = DDTextFieldView()
        textField.mTextField.textColor = ThemeColor.main.color()
        textField.mTextField.placeholder = " Please enter".localString
        return textField
    }()
    
    lazy var mErrorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = ThemeColor.red.color()
        return label
    }()
}
