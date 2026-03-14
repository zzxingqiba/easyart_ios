//
//  DDAddressTextViewEditView.swift
//  easyart
//
//  Created by Damon on 2024/11/4.
//

import UIKit

class DDAddressTextViewEditView: DDView {
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
                self.mBottomLine.backgroundColor = ThemeColor.red.color()
            } else {
                mErrorLabel.text = nil
                self.mBottomLine.backgroundColor = UIColor.dd.color(hexValue: 0x666666, alpha: 0.4)
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
            return mTextView.mPlaceHolderLabel.text
        }
        set {
            mTextView.mPlaceHolderLabel.text = newValue
        }
    }
    
    var text: String? {
        get {
            return mTextView.mTextView.text
        }
        set {
            mTextView.text = newValue ?? ""
        }
    }
    
    override func createUI() {
        self.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
        }
        
        let view = UIView()
        self.addSubview(view)
        view.snp.makeConstraints { make in
            make.left.right.equalTo(mTitleLabel)
            make.top.equalTo(mTitleLabel.snp.bottom)
            make.height.greaterThanOrEqualTo(50)
        }
        
        view.addSubview(mTextView)
        mTextView.snp.makeConstraints { make in
            make.left.equalTo(mTitleLabel).offset(6)
            make.right.equalTo(mTitleLabel)
//            make.centerY.equalTo(view)
            make.top.equalToSuperview().offset(15)
            make.height.equalTo(20)
        }
        
        view.addSubview(mBottomLine)
        mBottomLine.snp.makeConstraints { make in
            make.top.equalTo(mTextView.snp.bottom).offset(15)
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        self.addSubview(mErrorLabel)
        mErrorLabel.snp.makeConstraints { make in
            make.left.right.equalTo(mTitleLabel)
            make.top.equalTo(view.snp.bottom).offset(3)
            make.bottom.equalToSuperview()
        }
        
        self._bindView()
    }

    //MARK: UI
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mTextView: DDTextView = {
        let view = DDTextView()
        view.maxCount = 150
        view.mTextView.textColor = ThemeColor.main.color()
        view.mPlaceHolderLabel.text = " Please enter".localString
        return view
    }()
    
    lazy var mBottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeColor.line.color()
        return view
    }()
    
    lazy var mErrorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = ThemeColor.red.color()
        return label
    }()
}

extension DDAddressTextViewEditView {
    func _bindView() {
        _ = self.mTextView.mTextView.rx.observe(CGSize.self, "contentSize").subscribe(onNext: { [weak self] (contentSize) in
            guard let self = self, let contentSize = contentSize else { return }
                self.mTextView.snp.updateConstraints { (make) in
                    make.height.equalTo(max(20, contentSize.height))
                }
        })
    }
}
