//
//  SettleWarnPopView.swift
//  easyart
//
//  Created by Damon on 2025/2/27.
//

import UIKit
import RxRelay

class SettleWarnPopView: DDView {
    let clickPublish = PublishRelay<Void>()
    
    override func createUI() {
        super.createUI()
        self.backgroundColor = ThemeColor.white.color()
        self.snp.makeConstraints { make in
            make.width.equalTo(340)
        }
        
        self.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(50)
            make.centerX.equalToSuperview()
        }
        
        self.addSubview(mDesLabel)
        mDesLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(26)
            make.right.equalToSuperview().offset(-26)
            make.top.equalTo(mTitleLabel.snp.bottom).offset(30)
        }
        
        self.addSubview(mConfirmButton)
        mConfirmButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(26)
            make.right.equalToSuperview().offset(-26)
            make.top.equalTo(mDesLabel.snp.bottom).offset(30)
            make.bottom.equalToSuperview().offset(-50)
            make.height.equalTo(50)
        }
        
        self.addSubview(mCloseButton)
        mCloseButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(20)
            make.width.height.equalTo(24)
        }
        
        self._loadData()
        self._bindView()
    }

    //MARK: UI
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Notice".localString
        label.font = .systemFont(ofSize: 18)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mDesLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mCloseButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "home_guanbi"), for: .normal)
        return button
    }()
    
    lazy var mConfirmButton: UIButton = {
        let tButton = UIButton(type: .custom)
        tButton.setBackgroundImage(UIImage.dd.getImage(color: ThemeColor.black.color()), for: .normal)
        tButton.setBackgroundImage(UIImage.dd.getImage(color: ThemeColor.gray.color()), for: .disabled)
        tButton.titleLabel?.font = .systemFont(ofSize: 14)
        tButton.setTitleColor(UIColor.dd.color(hexValue: 0xffffff), for: .normal)
        tButton.setTitle("OK".localString, for: .normal)
        return tButton
    }()

}

extension SettleWarnPopView {
    func _loadData() {
        let content = "Dear User,\n\nEasyart will verify all the modifications after you submit a new request to modify your personal information. The verification process is expected to be completed within 2 business days.\n\nIf your modification request is approved, easyart will automatically update your personal information. If the review is not approved, your personal information will remain unchanged, and the previous information will continue to be exhibited.\n\nPlease take note of this and stay informed. \nIf you have any questions, feel free to contact our customer service.\n\nSincerely".localString
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1
        paragraphStyle.alignment = .left
        let attributed = NSAttributedString(string: content, attributes: [NSAttributedString.Key.paragraphStyle : paragraphStyle])
        self.mDesLabel.attributedText = attributed
    }
    
    func _bindView() {
        _ = self.mConfirmButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.clickPublish.accept(())
        })
        
        _ = self.mCloseButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.clickPublish.accept(())
        })
    }
}
