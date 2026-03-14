//
//  DDTextFieldView.swift
//  InvoiceClient
//
//  Created by Damon on 2020/7/25.
//  Copyright © 2020 Damon. All rights reserved.
//

import UIKit
import DDUtils


class DDTextFieldView: UIView {
    var errorStatus = false {
        willSet {
            if newValue {
                self.mTextField.text = "输入错误"
                self.mClearButton.isHidden = false
                self.mTextField.textColor = UIColor.dd.color(hexValue: 0xFF5858)
                self.mTextField.resignFirstResponder()
            } else {
                self.mTextField.textColor = UIColor.dd.color(hexValue: 0x333333)
            }
        }
    }
    
    init(title: String? = nil, icon: UIImage? = nil, imageSize: CGSize = CGSize(width: 24, height: 24)) {
        super.init(frame: .zero)
        self.p_createUI(title: title, icon: icon, imageSize: imageSize)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func p_createUI(title: String?, icon: UIImage?, imageSize: CGSize) {
        self.addSubview(mIconImageView)
        mIconImageView.snp.makeConstraints { (make) in
            make.left.centerY.equalToSuperview()
        }
        
        self.addSubview(mTitleLable)
        mTitleLable.snp.makeConstraints { (make) in
            make.left.equalTo(mIconImageView.snp.right).offset(6)
            make.centerY.equalToSuperview()
        }
        
        self.addSubview(mTextField)
        mTextField.snp.makeConstraints { (make) in
            make.left.equalTo(mTitleLable.snp.right).offset(30)
            make.right.equalToSuperview().offset(-30)
            make.top.bottom.equalToSuperview()
        }
        
        self.addSubview(mClearButton)
        mClearButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
            make.width.height.equalTo(25)
        }
        
        self.addSubview(mBottomLine)
        mBottomLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        if let icon = icon {
            mIconImageView.image = icon
            mIconImageView.snp.makeConstraints { (make) in
                make.width.equalTo(imageSize.width)
                make.height.equalTo(imageSize.height)
            }
        } else {
            mIconImageView.snp.makeConstraints { (make) in
                make.width.height.equalTo(0)
            }
        }
        
        mTitleLable.text = title
        if title == nil {
            mTextField.snp.updateConstraints { (make) in
                make.left.equalTo(mTitleLable.snp.right)
            }
        }
        
        _ = mClearButton.rx.tap.subscribe(onNext: { [weak self] (_) in
            self?.mTextField.text = ""
            self?.errorStatus = false
            self?.mClearButton.isHidden = true
            self?.mBottomLine.backgroundColor = UIColor.dd.color(hexValue: 0x666666, alpha: 0.4)
        })
        
        _ = mTextField.rx.text.subscribe(onNext: { [weak self] (text) in
            if self?.errorStatus == true {
                self?.mTextField.text = ""
                self?.errorStatus = false
            }
            if let text = text, text.length > 0 {
                self?.mBottomLine.backgroundColor = UIColor.dd.color(hexValue: 0x23AAFF)
                self?.mClearButton.isHidden = false
            } else {
                self?.mBottomLine.backgroundColor = UIColor.dd.color(hexValue: 0x666666, alpha: 0.4)
                self?.mClearButton.isHidden = true
            }
        })
        
    }
    
    //MARK: Lazy
    lazy var mIconImageView: UIImageView = {
        let tImageView = UIImageView()
        return tImageView
    }()
    
    lazy var mTitleLable: UILabel = {
        let tLabel = UILabel()
        tLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        tLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        tLabel.font = .systemFont(ofSize: 14)
        tLabel.textColor = UIColor.dd.color(hexValue: 0x333333)
        return tLabel
    }()
    
    lazy var mTextField: UITextField = {
        let tTextField = UITextField()
        tTextField.font = .systemFont(ofSize: 14)
        tTextField.textColor = UIColor.dd.color(hexValue: 0x000000)
        
        return tTextField
    }()
    
    lazy var mClearButton: UIButton = {
        let tButton = UIButton(type: .custom)
        tButton.setImage(UIImage(named: "ic_20_delete"), for: .normal)
        return tButton
    }()
    
    lazy var mBottomLine: UIView = {
        let tView = UIView()
        tView.backgroundColor = UIColor.dd.color(hexValue: 0x666666, alpha: 0.4)
        return tView
    }()
}
