//
//  SettleSwiftCodePop.swift
//  easyart
//
//  Created by Damon on 2025/6/18.
//

import UIKit
import RxRelay
import DDUtils

class SettleSwiftCodePop: DDView {
    let clickPublish = PublishRelay<Void>()

    override func createUI() {
        super.createUI()
        self.backgroundColor = ThemeColor.white.color()
        self.snp.makeConstraints { make in
            make.width.equalTo(UIScreenWidth)
        }
        
        self.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(35)
            make.right.equalToSuperview().offset(-35)
            make.top.equalToSuperview().offset(30)
        }
        
        self.addSubview(mDesLabel)
        mDesLabel.snp.makeConstraints { make in
            make.left.right.equalTo(mTitleLabel)
            make.top.equalTo(mTitleLabel.snp.bottom).offset(15)
        }
        
        self.addSubview(mTitleLabel2)
        mTitleLabel2.snp.makeConstraints { make in
            make.left.right.equalTo(mTitleLabel)
            make.top.equalTo(mDesLabel.snp.bottom).offset(30)
        }
        
        self.addSubview(mDesLabel2)
        mDesLabel2.snp.makeConstraints { make in
            make.left.right.equalTo(mTitleLabel)
            make.top.equalTo(mTitleLabel2.snp.bottom).offset(15)
        }
        
        self.addSubview(mImageView)
        mImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mDesLabel2.snp.bottom).offset(20)
            make.width.equalTo(300)
            make.height.equalTo(170)
        }
        
        self.addSubview(mConfirmButton)
        mConfirmButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mImageView.snp.bottom).offset(40)
            make.width.equalTo(340)
            make.height.equalTo(45)
            make.bottom.equalToSuperview().offset(-40)
        }
        
        self._bindView()
    }
    
    //MARK: UI
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "What is SWIFT code?".localString
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mDesLabel: UILabel = {
        let label = UILabel()
        label.text = "A SWIFT code is an international bank code that identifies particular banks worldwide. It's also known as a Bank Identifier Code (BIC). CommBank uses SWIFT codes tosend money to overseas banks.".localString
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 13)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mTitleLabel2: UILabel = {
        let label = UILabel()
        label.text = "How do I find out my SWIFT code?".localString
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mDesLabel2: UILabel = {
        let label = UILabel()
        label.text = "To locate your SWIFT/BIC code, check any paper or digital banking statements, or look at your account details on your online banking profile. You can also search for your BIC code using a digital SWIFT/BIC search tool by providing your country and bank location data.".localString
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 13)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "swift-code"))
        return imageView
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

extension SettleSwiftCodePop {
    func _bindView() {
        _ = self.mConfirmButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.clickPublish.accept(())
        })
    }
}
