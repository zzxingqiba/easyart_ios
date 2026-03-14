//
//  DDFavCollectionViewCell.swift
//  easyart
//
//  Created by Damon on 2024/9/23.
//

import UIKit
import SwiftyJSON

class DDFavCollectionViewCell: DDCollectionViewCell {
    
    override func createUI() {
        super.createUI()
        self.contentView.addSubview(mImageView)
        mImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.contentView.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-16)
        }
    }
    
    func updateUI(model: JSON) {
        mImageView.kf.setImage(with: URL(string: model["photo_url"].stringValue))
        mTitleLabel.isHidden = !model["is_new"].boolValue
    }
    
    //MARK: UI
    lazy var mImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var mTitleLabel: PaddingLabel = {
        let label = PaddingLabel(withInsets: 0, 0, 4, 4)
        label.text = "new"
        label.isHidden = true
        label.font = .systemFont(ofSize: 12)
        label.textColor = UIColor.dd.color(hexValue: 0xffffff)
        label.backgroundColor = ThemeColor.black.color()
        label.layer.cornerRadius = 8;
        label.layer.masksToBounds = true
        return label
    }()
}
