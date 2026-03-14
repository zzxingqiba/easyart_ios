//
//  DDLanguageCollectionViewCell.swift
//  HiTalk
//
//  Created by Damon on 2024/8/6.
//

import UIKit
import Kingfisher

class DDLanguageCollectionViewCell: DDCollectionViewCell {
    override func createUI() {
        super.createUI()
        self.addSubview(mIconImageView)
        mIconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.width.equalTo(40)
            make.height.equalTo(30)
        }
        
        self.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(mIconImageView.snp.right).offset(10)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
    func updateUI(icon: String, title: String) {
        mIconImageView.kf.setImage(with: URL(string: icon))
        mTitleLabel.text = title
    }
    
    //MARK: UI
    lazy var mIconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var mTitleLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.font = .systemFont(ofSize: 14, weight: .bold)
        tLabel.textColor = UIColor.dd.color(hexValue: 0x000000)
        return tLabel
    }()
}
