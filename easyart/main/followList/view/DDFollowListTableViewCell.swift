//
//  DDFollowListTableViewCell.swift
//  easyart
//
//  Created by Damon on 2024/12/3.
//

import UIKit
import SwiftyJSON

class DDFollowListTableViewCell: DDTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func createUI() {
        super.createUI()
        self.contentView.addSubview(mImageView)
        mImageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        self.contentView.addSubview(mNameLabel)
        mNameLabel.snp.makeConstraints { make in
            make.left.equalTo(mImageView.snp.right).offset(15)
            make.bottom.equalTo(mImageView.snp.centerY).offset(-2)
        }
        
        self.contentView.addSubview(mCountryLabel)
        mCountryLabel.snp.makeConstraints { make in
            make.left.equalTo(mNameLabel)
            make.top.equalTo(mImageView.snp.centerY).offset(2)
        }
        
        self.contentView.addSubview(mArrowImageView)
        mArrowImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalTo(7)
            make.height.equalTo(13)
        }
    }

    func updateUI(model: JSON) {
        mImageView.kf.setImage(with: URL(string: model["face_url"].stringValue))
        mNameLabel.text = model["name"].stringValue
        mCountryLabel.text = model["country_name"].stringValue
    }
    
    //MARK: UI
    lazy var mImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.dd.color(hexValue: 0xcccccc)
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 25
        return imageView
    }()
    
    lazy var mNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mCountryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.gray.color()
        return label
    }()
    
    lazy var mArrowImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "icon-arrow-solid"))
        return imageView
    }()
}
