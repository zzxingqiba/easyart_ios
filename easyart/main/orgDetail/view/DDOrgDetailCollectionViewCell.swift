//
//  DDOrgDetailCollectionViewCell.swift
//  easyart
//
//  Created by Damon on 2024/9/23.
//

import UIKit
import SwiftyJSON

class DDOrgDetailCollectionViewCell: DDCollectionViewCell {
    
    override func createUI() {
        super.createUI()
        self.contentView.addSubview(mImageView)
        mImageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(self.contentView.snp.width)
        }
        
        self.contentView.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(mImageView).offset(10)
            make.top.equalTo(mImageView.snp.bottom).offset(16)
        }
        
        self.contentView.addSubview(mAuthorLabel)
        mAuthorLabel.snp.makeConstraints { make in
            make.left.equalTo(mTitleLabel)
            make.top.equalTo(mTitleLabel.snp.bottom).offset(3)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
    func updateUI(model: JSON) {
        mImageView.kf.setImage(with: URL(string: model["head"].stringValue))
        mTitleLabel.text = model["name"].stringValue
        mAuthorLabel.text = model["categoryList"].stringValue
    }
    
    //MARK: UI
    lazy var mImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mAuthorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = ThemeColor.gray.color()
        return label
    }()
}
