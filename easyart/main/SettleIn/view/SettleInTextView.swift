//
//  SettleInTextView.swift
//  easyart
//
//  Created by Damon on 2024/12/17.
//

import UIKit

class SettleInTextView: DDView {
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
                self.mBottomLine.backgroundColor = ThemeColor.red.color()
            } else {
                self.mBottomLine.backgroundColor = ThemeColor.line.color()
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
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(10)
        }
        
//        let view = UIView()
//        self.addSubview(view)
//        view.snp.makeConstraints { make in
//            make.left.equalTo(self.snp.centerX)
//            make.right.equalToSuperview()
//            make.top.equalToSuperview()
//            make.bottom.equalToSuperview()
//            make.height.greaterThanOrEqualTo(60)
//        }
        
        self.addSubview(mTextView)
        mTextView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.greaterThanOrEqualTo(20)
            make.top.equalTo(mTitleLabel.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        self.addSubview(mBottomLine)
        mBottomLine.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
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
        view.maxCount = 2000
        view.showNumberLabel = false
        view.mTextView.textColor = ThemeColor.black.color()
        view.mPlaceHolderLabel.text = " Please enter".localString
        return view
    }()
    
    lazy var mBottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeColor.line.color()
        return view
    }()
}

extension SettleInTextView {
    func _bindView() {
        _ = self.mTextView.mTextView.rx.observe(CGSize.self, "contentSize").subscribe(onNext: { [weak self] (contentSize) in
            guard let self = self, let contentSize = contentSize else { return }
                self.mTextView.snp.updateConstraints { (make) in
                    make.height.greaterThanOrEqualTo(max(20, contentSize.height))
                }
        })
    }
}
