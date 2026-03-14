//
//  DDUserRulePopView.swift
//  Menses
//
//  Created by Damon on 2020/8/21.
//  Copyright © 2020 Damon. All rights reserved.
//

import UIKit
import RxSwift
import BSText
import DDUtils
import HDHUD

class DDUserRulePopView: UIView {
    var mClickSubject = PublishSubject<DDPopButtonType>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.p_createUI()
        self.p_bindSubject()
        self.p_configRuleConetnt()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func p_bindSubject() {
        let _ = self.mAgreeBtn.rx.tap.subscribe(onNext: { [weak self] () in
            self?.mClickSubject.onNext(.confirm)
        })

        let _ = self.mCancelBtn.rx.tap.subscribe(onNext: { [weak self] () in
            HDHUD.show("我们会在后续请求权限时继续请求授权，请您同意授权，否则将无法使用经期宝APP功能")
            self?.mClickSubject.onNext(.confirm)
        })
    }

    private func p_createUI() {
        self.backgroundColor = UIColor.dd.color(hexValue: 0xFFFFFF)
        self.layer.cornerRadius = 15
        self.snp.makeConstraints { (make) in
            make.width.equalTo(282)
        }

        self.addSubview(self.mTitleLabel)
        self.mTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(14)
            make.top.equalToSuperview().offset(25)
        }

        self.addSubview(self.mDescLabel)
        self.mDescLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.mTitleLabel.snp.bottom).offset(4)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }

        self.addSubview(self.mBottomline)
        self.mBottomline.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.mDescLabel.snp.bottom).offset(10)
            make.height.equalTo(1)
        }

        self.addSubview(self.mAgreeBtn)
        self.mAgreeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(mBottomline.snp.bottom).offset(10)
            make.left.equalTo(self.snp.centerX)
            make.size.equalTo(CGSize(width: 120, height: 40))
            make.bottom.equalToSuperview().offset(-15)
        }

        self.addSubview(self.mCancelBtn)
        self.mCancelBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.mAgreeBtn)
            make.right.equalTo(self.snp.centerX)
            make.size.equalTo(CGSize(width: 120, height: 40))
        }
    }

    private func p_configRuleConetnt() {
//        let mutAttStr = NSMutableAttributedString(string: "经期宝非常重视您的个人信息安全和隐私保护。我们在")
//
//        let attStr1 = NSMutableAttributedString(string: "《用户协议》和《隐私政策》")
//
//        attStr1.bs_set(textHighlightRange: NSRange(location: 0, length: 6), color: UIColor.dd.color(hexValue: 0xFB4374), backgroundColor: UIColor.clear) { (containerView, text, range, rect) in
//            DDPopView.hide()
//            let ruleVC = QLWebViewController(url: URL(string: UserRuleURL)!)
//            ruleVC.loadBarTitle(title: "用户协议", textColor: UIColor.dd.color(hexValue: 0x333333))
//            ruleVC.hidesBottomBarWhenPushed = true
//            DDUtils.shared.getCurrentVC()?.navigationController?.pushViewController(ruleVC, animated: true)
//        }
//
//        attStr1.bs_set(textHighlightRange: NSRange(location: 7, length: 6), color: UIColor.dd.color(hexValue: 0xFB4374), backgroundColor: UIColor.clear) { (containerView, text, range, rect) in
//            DDPopView.hide()
//            let ruleVC = QLWebViewController(url: URL(string: PrivacyRuleURL)!)
//            ruleVC.loadBarTitle(title: "Privacy Agreement", textColor: UIColor.dd.color(hexValue: 0x333333))
//            ruleVC.hidesBottomBarWhenPushed = true
//            DDUtils.shared.getCurrentVC()?.navigationController?.pushViewController(ruleVC, animated: true)
//        }
//
//        let attStr2 = NSMutableAttributedString(string: "描述了我们如何收集、使用，存储和分享用户的个人信息，这些内容包括但不限于：我们收集的信息范围，使用用途；我们如何保护用户的个人信息安全；您对您的个人信息享有的权利等。\n如果您继续使用我们的服务，表明您理解并接受我们")
//        let attStr3 = NSMutableAttributedString(string: "的全部内容。\n为了实现推送消息功能，我们使用了MobTech的MobPush产品，此产品的隐私策略条款，可以参考：http://www.mob.com/about/policy。")
//        mutAttStr.append(attStr1)
//        mutAttStr.append(attStr2)
//        mutAttStr.append(attStr1)
//        mutAttStr.append(attStr3)
//        mutAttStr.bs_lineHeightMultiple = 1.3
//        self.mDescLabel.attributedText = mutAttStr
    }

    //MARK:Lazy
    private(set) lazy var mBottomline: UILabel = {
        let tmpLabel = UILabel()
        tmpLabel.backgroundColor = UIColor.dd.color(hexValue: 0x000000, alpha: 0.2)
        return tmpLabel
    }()

    private(set) lazy var mTitleLabel: UILabel = {
        let tmpLabel = UILabel()
        tmpLabel.text = "欢迎使用经期宝："
        tmpLabel.font = .boldSystemFont(ofSize: 17)
        tmpLabel.textAlignment = .center
        tmpLabel.textColor = UIColor.dd.color(hexValue: 0x333333)
        return tmpLabel
    }()

    private(set) lazy var mDescLabel: BSLabel = {
        let tmpLabel = BSLabel()
        tmpLabel.isUserInteractionEnabled = true
        tmpLabel.preferredMaxLayoutWidth = 250
        tmpLabel.font = .boldSystemFont(ofSize: 15)
        tmpLabel.numberOfLines = 0
        tmpLabel.textColor = UIColor.dd.color(hexValue: 0x333333)
        return tmpLabel
    }()

    private(set) lazy var mAgreeBtn: UIButton = {
        let tmpBtn = UIButton.init(type: .custom)
        let attStr = NSAttributedString(string: "同意并继续", attributes: [NSAttributedString.Key.font :UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.dd.color(hexValue: 0xFFFFFF)])
        tmpBtn.setAttributedTitle(attStr, for: .normal)
        tmpBtn.backgroundColor = UIColor.dd.color(hexValue: 0xFB4374)
        tmpBtn.layer.masksToBounds = true
        tmpBtn.layer.cornerRadius = 20
        return tmpBtn
    }()

    private(set) lazy var mCancelBtn: UIButton = {
        let tmpBtn = UIButton(type: UIButton.ButtonType.custom)
        tmpBtn.setTitle("不同意", for: .normal)
        tmpBtn.setTitleColor(UIColor.dd.color(hexValue: 0xAD111B, alpha: 0.4), for: .normal)
        tmpBtn.titleLabel?.font = .systemFont(ofSize: 15)
        tmpBtn.backgroundColor = UIColor.dd.color(hexValue: 0xFB4374, alpha: 0)
        tmpBtn.layer.masksToBounds = true
        tmpBtn.layer.cornerRadius = 20
        return tmpBtn
    }()


}
