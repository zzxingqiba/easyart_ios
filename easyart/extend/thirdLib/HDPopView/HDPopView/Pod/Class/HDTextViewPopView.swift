//
//  HDTextViewPopView.swift
//  HDPopView
//
//  Created by Damon on 2021/3/4.
//

import UIKit
import DDUtils

import SnapKit

open class HDTextViewPopView: HDPopContentView {
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

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    //输入框文字内容
    open var text : String {
        set {
            self.mTextView.text = newValue
        }
        get {
            return  self.mTextView.text
        }
    }

    //设置默认文字
    open var placeholder : String? {
        set {
            self.mTextView.placeholder = newValue
        }
        get {
            return  self.mTextView.placeholder
        }
    }

    //键盘类型
    open var keyboardType: UIKeyboardType = .default {
        willSet {
            self.mTextView.keyboardType = newValue
        }
    }

    //MARK: UI
    public private(set) lazy var mTitleLabel: UILabel = {
        let tTitleLabel = UILabel()
        tTitleLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: NSLayoutConstraint.Axis.vertical)
        tTitleLabel.font = .systemFont(ofSize: 20, weight: .medium)
        tTitleLabel.textColor = UIColor.dd.color(hexValue: 0x000000)
        tTitleLabel.textAlignment = NSTextAlignment.center
        return tTitleLabel
    }()

    private lazy var mContentLabel: UILabel = {
        let tContentLabel = UILabel()
        tContentLabel.numberOfLines = 0
        tContentLabel.font = UIFont.systemFont(ofSize: 14)
        tContentLabel.textColor = UIColor.dd.color(hexValue: 0x666666)
        tContentLabel.lineBreakMode = .byCharWrapping
        return tContentLabel
    }()

    public private(set) lazy var mTextView: HDTextView = {
        let tTextView = HDTextView()
        tTextView.textColor = UIColor.dd.color(hexValue: 0x394a51)
        tTextView.font = UIFont.systemFont(ofSize: 14)
        tTextView.layer.cornerRadius = 8
        tTextView.layer.borderWidth = 1.0
        tTextView.layer.borderColor = UIColor.dd.color(hexValue: 0xfdc57b).cgColor
        return tTextView
    }()

    public private(set) lazy var mConfirmButton: UIButton = {
        let tButton = UIButton(type: .custom)
        tButton.setTitle(NSLocalizedString("确定", comment: ""), for: UIControl.State.normal)
        tButton.setTitleColor(UIColor.dd.color(hexValue: 0x333333), for: UIControl.State.normal)
        tButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        tButton.backgroundColor = UIColor.dd.color(hexValue: 0xFFDA02)
        tButton.layer.masksToBounds = true
        tButton.layer.cornerRadius = 6.0
        return tButton
    }()

    public private(set) lazy var mCloseButton: UIButton = {
        let tButton = UIButton(type: .custom)
        tButton.setBackgroundImage(UIImageHDPopBoundle(named: "ic_close"), for: .normal)
        return tButton
    }()
}

private extension HDTextViewPopView {
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
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(self.mTitleLabel.snp.bottom).offset(15)
        }

        self.addSubview(self.mTextView)
        self.mTextView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(110)
            make.top.equalTo(self.mContentLabel.snp.bottom).offset(15)
        }

        self.addSubview(self.mConfirmButton)
        self.mConfirmButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(40)
            make.top.equalTo(self.mTextView.snp.bottom).offset(20)
            make.bottom.equalToSuperview().offset(-20)
        }

        self.addSubview(mCloseButton)
        self.mCloseButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(13)
            make.width.height.equalTo(32)
        }
    }

    func _bindView() {

        _ = mConfirmButton.rx.tap.map { _ in
            return HDPopButtonClickInfo(clickType: .confirm, info: self.mTextView.text)
        }.bind(to: self.clickBinder)

        _ = mCloseButton.rx.tap.map { _ in
            return HDPopButtonClickInfo(clickType: .cancel, info: nil)
        }.bind(to: self.clickBinder)

        _ = self.mTextView.rx.text.subscribe(onNext: { (_) in

        })

        _ = self.backgroundClickEvent.emit(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.mTextView.resignFirstResponder()
        })
    }
}
