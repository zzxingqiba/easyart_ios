//
//  HDRulePopView.swift
//  HDPopView
//
//  Created by Damon on 2021/3/3.
//

import UIKit
import DDUtils
import RxSwift

open class HDRulePopView: HDPopContentView {
    private var mAppTitle: String
    private let clickSubject = PublishSubject<HDPopButtonClickInfo>()
    private let showConfirmPop: Bool
    private var isConfirmPop: Bool = false  //当前是否在显示确认弹窗

    public init(appTitle: String? = nil, showConfirmPop: Bool = true) {
        mAppTitle = appTitle ?? (DDUtils.shared.getAppNameString().isEmpty ? DDUtils.shared.getAppNameString() : NSLocalizedString("本软件", comment: ""))
        self.showConfirmPop = showConfirmPop
        super.init(frame: .zero)
        self._createUI()
        self._bindView()
        self._configRuleConetnt()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: Lazy
    public private(set) lazy var mTitleLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.textColor = UIColor.dd.color(hexValue: 0x000000)
        tLabel.font = .systemFont(ofSize: 20, weight: .medium)
        tLabel.numberOfLines = 2
        tLabel.textAlignment = .center
        return tLabel
    }()

    public private(set) lazy var mContentTextView: UITextView = {
        let tTextView = UITextView()
        tTextView.isEditable = false
        tTextView.isSelectable = true
        tTextView.delegate = self
        tTextView.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.dd.color(hexValue: 0xff7e67)]
        return tTextView
    }()

    private lazy var mBottomline: UILabel = {
        let tmpLabel = UILabel()
        tmpLabel.backgroundColor = UIColor.dd.color(hexValue: 0x000000, alpha: 0.2)
        return tmpLabel
    }()

    public private(set) lazy var mLeftButton: UIButton = {
        let tButton = UIButton(type: .custom)
        tButton.backgroundColor = UIColor.dd.color(hexValue: 0xeeeeee)
        tButton.titleLabel?.font = .systemFont(ofSize: 16)
        tButton.setTitleColor(UIColor.dd.color(hexValue: 0x333333), for: .normal)
        tButton.setTitle(NSLocalizedString("拒绝", comment: ""), for: .normal)
        tButton.layer.cornerRadius = 20
        return tButton
    }()

    public private(set) lazy var mRightButton: UIButton = {
        let tButton = UIButton(type: .custom)
        tButton.backgroundColor = UIColor.dd.color(hexValue: 0xFFDA02)
        tButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        tButton.setTitleColor(UIColor.dd.color(hexValue: 0x333333), for: .normal)
        tButton.setTitle(NSLocalizedString("同意", comment: ""), for: .normal)
        tButton.layer.cornerRadius = 20
        return tButton
    }()

}

private extension HDRulePopView {
    func _createUI() {
        self.backgroundColor = UIColor.dd.color(hexValue: 0xffffff)
        self.layer.cornerRadius = 12
        self.snp.makeConstraints { (make) in
            make.width.equalTo(310)
        }

        mTitleLabel.text = NSLocalizedString("用户协议与隐私政策", comment: "")
        self.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(20)
        }

        self.addSubview(mContentTextView)
        mContentTextView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(mTitleLabel.snp.bottom).offset(20)
            make.height.equalTo(370)
        }

        self.addSubview(mBottomline)
        mBottomline.snp.makeConstraints { (make) in
            make.left.right.equalTo(mContentTextView)
            make.top.equalTo(mContentTextView.snp.bottom).offset(10)
            make.height.equalTo(0.5)
        }

        self.addSubview(mLeftButton)
        mLeftButton.snp.makeConstraints { (make) in
            make.top.equalTo(mBottomline.snp.bottom).offset(10)
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
        //确定按钮
        _ = mRightButton.rx.tap.map { _ in
            return HDPopButtonClickInfo(clickType: .confirm, info: nil)
        }.bind(to: self.clickBinder)

        //取消按钮
        _ = mLeftButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            if self.showConfirmPop == false {
                //不显示确认界面
                self.clickSubject.onNext(HDPopButtonClickInfo(clickType: .cancel, info: nil))
            } else if self.isConfirmPop {
                //确认界面的取消按钮
                self.clickSubject.onNext(HDPopButtonClickInfo(clickType: .cancel, info: nil))
            } else {
                //显示确认弹窗
                self._showConfirmContent()
            }
        })
        
        _ = clickSubject.bind(to: self.clickBinder)
    }

    func _configRuleConetnt() {
        let mutAttStr = NSMutableAttributedString(string: "为了更良好的用户体验，\(mAppTitle)会在使用过程中使用、收集您的部分个人信息。请您阅读并完全理解以下内容:\n\n\(mAppTitle)非常重视您的个人信息安全和隐私保护。我们在")

        let attStr1 = NSMutableAttributedString(string: "《用户协议》和《隐私政策》")
        attStr1.addAttribute(.link, value: "HDRulePopUserRule://", range: NSRange(location: 0, length: 6))
        attStr1.addAttribute(.link, value: "HDRulePopPrivacy://", range: NSRange(location: 7, length: 6))

        let attStr2 = NSMutableAttributedString(string: "详细描述了我们如何收集、使用，存储和分享用户的个人信息，这些内容包括但不限于：我们收集的信息范围，使用用途；我们如何保护用户的个人信息安全；您对您的个人信息享有的权利等。\n\n如您已理解并同意上述协议与政策，请点击该弹窗「同意按钮」开始使用\(mAppTitle)，我们会尽全力保护您的信息安全。\n如您拒绝遵守上述协议与政策，则只能使用\(mAppTitle)基础的浏览功能!")
        mutAttStr.append(attStr1)
        mutAttStr.append(attStr2)
        //行高
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .justified
        paragraphStyle.lineHeightMultiple = 1.4
        mutAttStr.addAttributes([NSAttributedString.Key.paragraphStyle : paragraphStyle, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.dd.color(hexValue: 0x666666)], range: NSRange(location: 0, length: mutAttStr.length))

        self.mContentTextView.attributedText = mutAttStr
    }
    
    func _showConfirmContent() {
        self.isConfirmPop = true
        self.mTitleLabel.text = NSLocalizedString("再次确认", comment: "")
        self.mLeftButton.setTitle(NSLocalizedString("依旧拒绝", comment: ""), for: .normal)
        self.mRightButton.setTitle(NSLocalizedString("同意并继续", comment: ""), for: .normal)
        let mutAttStr = NSMutableAttributedString(string: "您未同意我们的")

        let attStr1 = NSMutableAttributedString(string: "《用户协议》和《隐私政策》")
        attStr1.addAttribute(.link, value: "HDRulePopUserRule://", range: NSRange(location: 0, length: 6))
        attStr1.addAttribute(.link, value: "HDRulePopPrivacy://", range: NSRange(location: 7, length: 6))

        let attStr2 = NSMutableAttributedString(string: "，根据相关法律法规，我们无法向您提供完整的产品功能，仅能使用简单的浏览功能。为了更好的体验，我们建议您同意并遵守上述协议内容。\n\n我们在协议中详细描述了我们的责任义务、您可享受到的权益和规则，收集、使用和存储用户个人信息的方式等，如果您拒绝遵守，将无法使用登录注册、信息同步、反馈投诉、添加信息以及解锁高级功能等诸多功能！\n\n如您改变选择，请点击该弹窗「同意按钮」开始使用\(mAppTitle)完整功能。")
        mutAttStr.append(attStr1)
        mutAttStr.append(attStr2)
        //行高
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .justified
        paragraphStyle.lineHeightMultiple = 1.4
        mutAttStr.addAttributes([NSAttributedString.Key.paragraphStyle : paragraphStyle, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.dd.color(hexValue: 0x666666)], range: NSRange(location: 0, length: mutAttStr.length))

        self.mContentTextView.attributedText = mutAttStr
    }
    
}

extension HDRulePopView: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.scheme == "HDRulePopUserRule" {
            self.clickSubject.onNext(HDPopButtonClickInfo(clickType: .custom, info: 0))
            return false
        } else if URL.scheme == "HDRulePopPrivacy" {
            self.clickSubject.onNext(HDPopButtonClickInfo(clickType: .custom, info: 1))
            return false
        }
        return false
    }

    
}
