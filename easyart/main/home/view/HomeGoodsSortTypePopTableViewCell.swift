//
//  HomeGoodsSortTypePopTableViewCell.swift
//  easyart
//
//  Created by Damon on 2025/6/19.
//

import UIKit

class HomeGoodsSortTypePopTableViewCell: DDTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        mIconImageView.image = selected ? UIImage(named: "home_icon_sort_selected"): UIImage(named: "home_icon_sort_normal")
        mTitleLabel.textColor = selected ? ThemeColor.black.color() : ThemeColor.gray.color()
    }
    
    override func createUI() {
        super.createUI()
        self.contentView.addSubview(mIconImageView)
        mIconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(23)
        }
        
        self.contentView.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(mIconImageView.snp.right).offset(20)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
    func updateUI(model: HomeGoodsSortType) {
        mTitleLabel.text = model.title
    }
    
    //MARK: UI
    lazy var mIconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "home_icon_sort_normal"))
        return imageView
    }()

    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.gray.color()
        return label
    }()
}
