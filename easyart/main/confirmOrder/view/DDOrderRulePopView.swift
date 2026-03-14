//
//  DDOrderRulePopView.swift
//  easyart
//
//  Created by Damon on 2024/9/29.
//

import UIKit
import DDUtils
import RxRelay
import WebKit

class DDOrderRulePopView: DDView {
    let mClickSubject = PublishRelay<DDPopButtonClickInfo>()
    private var buyName = ""
    private var artistName = ""
    private var artworkName = ""
    private var payPrice: String = ""
    private var address: String = ""
    
    init(buyName: String, artistName: String, artworkName: String, payPrice: String, address: String) {
        self.buyName = buyName
        self.artistName = artistName
        self.artworkName = artworkName
        self.payPrice = payPrice
        self.address = address
        super.init(frame: .zero)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createUI() {
        super.createUI()
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 12
        self.backgroundColor = UIColor.dd.color(hexValue: 0xffffff)
        self.snp.makeConstraints { make in
            make.width.equalTo(340)
        }
        self.addSubview(mCloseButton)
        mCloseButton.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(16)
            make.width.height.equalTo(30)
        }
        
        self.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(35)
        }
        
        self.addSubview(mContentView)
        mContentView.snp.makeConstraints { make in
            make.top.equalTo(mTitleLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(330)
        }
        
        self.addSubview(mRuleView)
        mRuleView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mContentView.snp.bottom).offset(30)
        }
        
        self.addSubview(mConfirmButton)
        mConfirmButton.snp.makeConstraints { make in
            make.top.equalTo(mRuleView.snp.bottom).offset(30)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
            make.bottom.equalToSuperview()
        }
        
        self._bindView()
    }
    
    //MARK: UI
    public private(set) lazy var mTitleLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.textColor = ThemeColor.black.color()
        tLabel.font = .systemFont(ofSize: 20, weight: .medium)
        tLabel.numberOfLines = 2
        tLabel.textAlignment = .center
        return tLabel
    }()
    
//    public private(set) lazy var mContentTextView: UITextView = {
//        let tTextView = UITextView()
//        tTextView.isEditable = false
//        tTextView.isSelectable = true
//        tTextView.delegate = self
//        tTextView.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.dd.color(hexValue: 0xff7e67)]
//        tTextView.text = self._updateText()
//        return tTextView
//    }()
    
    lazy var mContentView: WKWebView = {
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences.preferredContentMode = .mobile
        let webView = WKWebView(frame: .zero, configuration: config)
//        webView.load(URLRequest(url: URL(string: "https://www.easyartonline.com/agreement/buy")!))
        webView.loadHTMLString(String.getRuleHtml(buyName: self.buyName, artistName: self.artistName, artworkName: self.artworkName, payPrice: self.payPrice, address: self.address), baseURL: nil)
        return webView
    }()
    
    public private(set) lazy var mConfirmButton: UIButton = {
        let tButton = UIButton(type: .custom)
        tButton.backgroundColor = ThemeColor.black.color()
        tButton.titleLabel?.font = .systemFont(ofSize: 14)
        tButton.setTitleColor(UIColor.dd.color(hexValue: 0xffffff), for: .normal)
        tButton.setTitle("Next step".localString, for: .normal)
        return tButton
    }()
    
    lazy var mRuleView: DDRuleView = {
        let view = DDRuleView()
        view.updateRule(text: self._ruleText())
        view.mRuleTextView.delegate = self
        return view
    }()
    
    lazy var mCloseButton: DDButton = {
        let button = DDButton()
        button.imageSize = CGSize(width: 18, height: 18)
        button.contentType = .center(gap: 0)
        button.normalImage = UIImage(named: "home_guanbi")
        return button
    }()

}

extension DDOrderRulePopView {
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
        
        _ = self.mCloseButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.mClickSubject.accept(.init(clickType: .close, info: self.mConfirmButton.isEnabled))
        })
        
        _ = self.mConfirmButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.mClickSubject.accept(.init(clickType: .confirm, info: self.mConfirmButton.isEnabled))
        })
    }
}

extension DDOrderRulePopView: UITextViewDelegate {
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
