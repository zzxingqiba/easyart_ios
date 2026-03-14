//
//  DDArtistSearchTableViewCell.swift
//  easyart
//
//  Created by Damon on 2024/11/21.
//

import UIKit

class DDArtistSearchTableViewCell: DDTableViewCell {

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
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.width.height.equalTo(45)
        }
        
        self.contentView.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(mImageView.snp.right).offset(17)
            make.bottom.equalTo(mImageView.snp.centerY).offset(-2)
        }
        self.contentView.addSubview(mDesLabel)
        mDesLabel.snp.makeConstraints { make in
            make.left.equalTo(mTitleLabel)
            make.top.equalTo(mTitleLabel.snp.bottom).offset(2)
        }
        self.contentView.addSubview(mArrowImageView)
        mArrowImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalTo(7)
            make.height.equalTo(13)
        }
    }
    
    func updateUI(model: DDArtistSearchModel) {
        mImageView.kf.setImage(with: URL(string: model.face_url))
        mTitleLabel.text = model.name
        mDesLabel.text = model.country_name
    }

    //
    lazy var mImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mDesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = ThemeColor.gray.color()
        return label
    }()
    
    lazy var mArrowImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "icon-arrow-solid"))
        return imageView
    }()
}
