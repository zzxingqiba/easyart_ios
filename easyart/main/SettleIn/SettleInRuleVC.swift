//
//  SettleInRuleVC.swift
//  easyart
//
//  Created by Damon on 2024/12/16.
//

import UIKit
import DDUtils
import RxRelay
import WebKit

class SettleInRuleVC: BaseVC {
    var profileModel = SettleInProfileModel()
    var authorModel = SettleInAuthorModel()
    
    init(profileModel: SettleInProfileModel) {
        super.init()
        self.profileModel = profileModel
        //用户信息
        let userModel = DDUserTools.shared.userInfo.value
        //审核被拒绝，编辑更新重新审核
        if userModel.role.status == 7 {
            self.authorModel.update(model: userModel.userRoleDetail)
        }
    }
    
    @MainActor required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._bindView()
    }
    
    override func createUI() {
        super.createUI()
        
        self.mSafeView.addSubview(mRuleContentView)
        mRuleContentView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-120 - BottomSafeAreaHeight)
        }
        
        self.mSafeView.addSubview(mRuleView)
        mRuleView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-80 - BottomSafeAreaHeight)
        }
        
        self.view.addSubview(mConfirmButton)
        mConfirmButton.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(50 + BottomSafeAreaHeight)
        }
    }
    
    //MARK: UI
    lazy var mRuleContentView: WKWebView = {
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences.preferredContentMode = .mobile
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.loadHTMLString(String.getSettleRuleHtml(profile: self.profileModel), baseURL: nil)
        return webView
    }()
    
    lazy var mRuleView: DDRuleView = {
        let view = DDRuleView()
        view.updateRule(text: self._ruleText())
        view.mRuleTextView.delegate = self
        return view
    }()
    
    public private(set) lazy var mConfirmButton: UIButton = {
        let tButton = UIButton(type: .custom)
        tButton.setBackgroundImage(UIImage.dd.getImage(color: ThemeColor.black.color()), for: .normal)
        tButton.setBackgroundImage(UIImage.dd.getImage(color: ThemeColor.gray.color()), for: .disabled)
        tButton.titleLabel?.font = .systemFont(ofSize: 14)
        tButton.setTitleColor(UIColor.dd.color(hexValue: 0xffffff), for: .normal)
        tButton.setTitle("Next step".localString, for: .normal)
        return tButton
    }()

}

extension SettleInRuleVC {
    func _ruleText() -> NSAttributedString {
        let mutAttStr = NSMutableAttributedString(string: "I have read and agree to the purchase agreement".localString, attributes: [.foregroundColor: UIColor.dd.color(hexValue: 0x000000)])
        mutAttStr.addAttributes([.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.dd.color(hexValue: 0x000000)], range: NSRange(location: 0, length: mutAttStr.length))
        
        return mutAttStr
    }
    
    func _bindView() {
        _ = self.mRuleView.selectChange.subscribe(onNext: { [weak self] isSelected in
            guard let self = self else { return }
            if isSelected {
                self.mConfirmButton.isEnabled = true
            } else {
                self.mConfirmButton.isEnabled = false
            }
        })
        
        _ = self.mConfirmButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            
            let vc = SettleInUpdateCoverVC(profileModel: self.profileModel, model: self.authorModel)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        })
    }
}

extension SettleInRuleVC: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if url.scheme == "HDRulePopUserRule" {
            
            return false
        } else if url.scheme == "HDRulePopPrivacy" {
            let vc = QLWebViewController(url: URL(string: WWWUrl_Base + "privacy/" + DDConfigTools.shared.getLanguage() )!)
            DDUtils.shared.getCurrentVC()?.present(vc, animated: true)
            return false
        }
        return false
    }
}
