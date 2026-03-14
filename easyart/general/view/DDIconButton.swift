//
//  DDIconButton.swift
//  Menses
//
//  Created by Damon on 2020/7/8.
//  Copyright © 2020 Damon. All rights reserved.
//  上面是图标，下面是文字的按钮

import UIKit
import DDUtils

class DDIconButton: UIButton {

    init(icon: UIImage? = nil, title: String? = nil) {
        super.init(frame: CGRect.zero)
        self.mTitleImageView.image = icon
        self.mTitleLabel.text = title
        self.createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createUI() {
        self.addSubview(mTitleImageView)
        mTitleImageView.snp.makeConstraints { (make) in
            make.top.centerX.equalToSuperview()
            make.width.height.equalTo(30)
            
        }
        
        self.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(mTitleImageView.snp.bottom).offset(5)
            make.centerX.equalTo(mTitleImageView)
            make.bottom.equalToSuperview()
        }
    }

    func updateUI(icon: UIImage? = nil, title: String? = nil, imageSize: CGSize = CGSize(width: 30, height: 30)) {
        self.mTitleImageView.image = icon
        self.mTitleLabel.text = title

        self.mTitleImageView.snp.updateConstraints { (make) in
            make.width.equalTo(imageSize.width)
            make.height.equalTo(imageSize.height)
        }
    }
    
    //MARK: Lazyload
    lazy var mTitleImageView: UIImageView = {
        let tImageView = UIImageView()
        return tImageView
    }()
    
    lazy var mTitleLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.font = UIFont.systemFont(ofSize: 15)
        tLabel.textColor =  UIColor.dd.color(hexValue: 0x000000)
        return tLabel
    }()
}
