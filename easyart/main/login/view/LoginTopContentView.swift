//
//  LoginTopContentView.swift
//  HiTalk
//
//  Created by Damon on 2024/6/11.
//

import UIKit
import RxSwift

class LoginTopContentView: DDView {
    let clickSubject = PublishSubject<DDPopButtonClickInfo>()
    
    override func createUI() {
        super.createUI()
        self.backgroundColor = UIColor.dd.color(hexValue: 0xfb9005)
        
        self.addSubview(mLogoImageView)
        mLogoImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(60)
            make.top.equalToSuperview().offset(20)
            make.width.height.equalTo(40)
        }
        
        self.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(mLogoImageView)
            make.top.equalTo(mLogoImageView.snp.bottom).offset(10)
        }
        self.addSubview(mLoginImageView)
        mLoginImageView.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(93)
        }
        
    }

    //MARK :UI
    lazy var mLogoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "icon_logo"))
        return imageView
    }()
    
    lazy var mTitleLabel: PaddingLabel = {
        let label = PaddingLabel(withInsets: 8, 8, 8, 8)
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = UIColor.dd.color(hexValue: 0xffffff)
        label.text = "easyart"
        return label
    }()
    
    lazy var mLoginImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "login-h5-bg"))
        return imageView
    }()
}
