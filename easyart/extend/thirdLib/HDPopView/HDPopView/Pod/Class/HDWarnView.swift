//
//  HDWarnView.swift
//  InvoiceClient
//
//  Created by Damon on 2020/7/25.
//  Copyright © 2020 Damon. All rights reserved.
//

import UIKit
import DDUtils
import RxSwift

open class HDWarnView: HDPopContentView {

    public convenience init(title: String?, content: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.3
        paragraphStyle.alignment = .center
        let attributed = NSAttributedString(string: content, attributes: [NSAttributedString.Key.paragraphStyle : paragraphStyle])
        self.init(title: title, content: attributed)
    }

    public init(title: String?, content: NSAttributedString) {
        super.init(frame: .zero)
        self._createUI()
        self._bindView()
        self.mTitleLabel.text = title
        self.mContentLabel.attributedText = content
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Lazy
    public private(set) lazy var mTitleLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.textColor = UIColor.dd.color(hexValue: 0x000000)
        tLabel.font = .systemFont(ofSize: 20, weight: .medium)
        tLabel.textAlignment = .center
        return tLabel
    }()

    lazy var mScrollView: UIScrollView = {
        let tScrollView = UIScrollView(frame: CGRect.zero)
        tScrollView.backgroundColor = UIColor.clear
        tScrollView.scrollsToTop = true
        tScrollView.showsHorizontalScrollIndicator = false
        tScrollView.showsVerticalScrollIndicator = false
        tScrollView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
        tScrollView.contentInsetAdjustmentBehavior = .never
        return tScrollView
    }()

    public private(set) lazy var mContentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    lazy var mContentLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.numberOfLines = 0
        tLabel.textColor = UIColor.dd.color(hexValue: 0x666666)
        tLabel.font = .systemFont(ofSize: 14)
        tLabel.lineBreakMode = .byCharWrapping
        return tLabel
    }()
    
    public private(set) lazy var mLeftButton: UIButton = {
        let tButton = UIButton(type: .custom)
        tButton.backgroundColor = UIColor.dd.color(hexValue: 0xeeeeee)
        tButton.titleLabel?.font = .systemFont(ofSize: 16)
        tButton.setTitleColor(UIColor.dd.color(hexValue: 0x333333), for: .normal)
        tButton.setTitle(NSLocalizedString("取消", comment: ""), for: .normal)
        tButton.layer.cornerRadius = 20
        return tButton
    }()
    
    public private(set) lazy var mRightButton: UIButton = {
        let tButton = UIButton(type: .custom)
        tButton.backgroundColor = UIColor.dd.color(hexValue: 0xFFDA02)
        tButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        tButton.setTitleColor(UIColor.dd.color(hexValue: 0x333333), for: .normal)
        tButton.setTitle(NSLocalizedString("确定", comment: ""), for: .normal)
        tButton.layer.cornerRadius = 20
        return tButton
    }()
}

private extension HDWarnView {
    func _createUI() {
        self.backgroundColor = UIColor.dd.color(hexValue: 0xffffff)
        self.layer.cornerRadius = 12
        self.snp.makeConstraints { (make) in
            make.width.equalTo(310)
        }
        
        self.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(20)
        }

        self.addSubview(mScrollView)
        mScrollView.snp.makeConstraints { (make) in
            make.top.equalTo(mTitleLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(10)
        }

        mScrollView.addSubview(mContentView)
        mContentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        mContentView.addSubview(mContentLabel)
        mContentLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        self.addSubview(mLeftButton)
        mLeftButton.snp.makeConstraints { (make) in
            make.top.equalTo(mScrollView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalTo(self.snp.centerX).offset(-8)
            make.height.equalTo(40)
        }
        
        self.addSubview(mRightButton)
        mRightButton.snp.makeConstraints { (make) in
            make.top.equalTo(mLeftButton)
            make.left.equalTo(self.snp.centerX).offset(8)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    func _bindView() {
        _ = mScrollView.rx.observe(CGSize.self, "contentSize").subscribe(onNext: { [weak self] (contentSize) in
            guard let self = self, let contentSize = contentSize else { return }
            self.mScrollView.isScrollEnabled = contentSize.height > 400
            self.mScrollView.snp.updateConstraints { (make) in
                make.height.equalTo(min(Int(contentSize.height), 400))
            }
        })

        _ = mRightButton.rx.tap.map { _ in
            return HDPopButtonClickInfo(clickType: .confirm, info: nil)
        }.bind(to: self.clickBinder)

        _ = mLeftButton.rx.tap.map { _ in
            return HDPopButtonClickInfo(clickType: .cancel, info:nil)
        }.bind(to: self.clickBinder)
    }
}

