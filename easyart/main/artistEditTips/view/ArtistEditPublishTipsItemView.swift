//
//  ArtistEditPublishTipsItemView.swift
//  easyart
//
//  Created by Damon on 2025/1/16.
//

import UIKit

class ArtistEditPublishTipsItemView: DDView {
    
    override func createUI() {
        super.createUI()
        self.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(65)
        }
        
        self.addSubview(mImageView)
        mImageView.snp.makeConstraints { make in
            make.right.top.equalToSuperview()
            make.width.height.equalTo(65)
        }
        
        self.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalTo(mImageView.snp.left).offset(-30)
            make.top.equalToSuperview()
        }
        
        self.addSubview(mDesLabel)
        mDesLabel.snp.makeConstraints { make in
            make.left.right.equalTo(mTitleLabel)
            make.top.equalTo(mTitleLabel.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
        }
    }
    
    //MARK: UI
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mDesLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 13)
        label.textColor = ThemeColor.gray.color()
        return label
    }()
    
    lazy var mImageView: UIImageView = {
        let view = UIImageView()
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        view.backgroundColor = UIColor.dd.color(hexValue: 0xE6E6E6)
        return view
    }()

}
