//
//  MessageFollowTableViewCell.swift
//  easyart
//
//  Created by Damon on 2025/6/20.
//

import UIKit

class MessageFollowTableViewCell: DDTableViewCell {

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
        self.contentView.backgroundColor = UIColor.dd.color(hexValue: 0xffffff)
        self.contentView.addSubview(mImageListView)
        mImageListView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(16)
            make.height.equalTo(65)
        }
        
        self.contentView.addSubview(mCountLabel)
        mCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(mImageListView)
            make.right.equalToSuperview().offset(-12)
        }
        
        self.contentView.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(mImageListView.snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        self.contentView.addSubview(mTimeLabel)
        mTimeLabel.snp.makeConstraints { make in
            make.left.right.equalTo(mTitleLabel)
            make.top.equalTo(mTitleLabel.snp.bottom).offset(5)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        self.contentView.addSubview(mArrowIcon)
        mArrowIcon.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalTo(mTimeLabel)
            make.width.equalTo(5)
            make.height.equalTo(8)
        }
        
        self.contentView.addSubview(mBlueIcon)
        mBlueIcon.snp.makeConstraints { make in
            make.centerY.equalTo(mArrowIcon)
            make.right.equalTo(mArrowIcon.snp.left).offset(-6)
            make.width.height.equalTo(6)
        }
    }

    func updateUI(model: FollowMessageModel) {
        self.mTitleLabel.text = model.desc
        self.mTimeLabel.text = "Follow" + " - " + model.date_desc
        self.mBlueIcon.isHidden = model.is_read
        if model.goods_num - 4 > 0 {
            self.mCountLabel.text = "+ \(model.goods_num - 4)"
        } else {
            self.mCountLabel.text = nil
        }
        //image
        for view in self.mImageListView.arrangedSubviews {
            view.removeFromSuperview()
        }
        for index in 0..<min(model.photo_list.count, 4) {
            let url = model.photo_list[index]
            let imageView = UIImageView()
            imageView.layer.masksToBounds = true
            imageView.contentMode = .scaleAspectFill
            imageView.snp.makeConstraints { make in
                make.width.height.equalTo(64)
            }
            imageView.kf.setImage(with: URL(string: url))
            self.mImageListView.addArrangedSubview(imageView)
        }
    }
    
    //MARK: UI
    lazy var mImageListView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    lazy var mCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = ThemeColor.lightGray.color()
        return label
    }()
    
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11)
        label.textColor = ThemeColor.lightGray.color()
        return label
    }()
    
    lazy var mBlueIcon: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.dd.color(hexValue: 0x1053FF)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 3
        return view
    }()
    
    lazy var mArrowIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "icon-message-arrow"))
        return imageView
    }()
}
