//
//  DDSearchFilterTableViewCell.swift
//  easyart
//
//  Created by Damon on 2024/11/25.
//

import UIKit

class DDSearchFilterTableViewCell: DDTableViewCell {

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
        self.contentView.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        self.contentView.addSubview(mTagView)
        mTagView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(mTitleLabel.snp.right).offset(10)
            make.width.height.equalTo(3)
        }
        
        self.contentView.addSubview(mTagLabel)
        mTagLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(mTagView.snp.right).offset(5)
        }
        
        self.contentView.addSubview(mArrowImageView)
        mArrowImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalTo(7)
            make.height.equalTo(13)
        }
    }
    
    func updateUI(model: DDSearchFilterModel) {
        mTitleLabel.text = model.title
        mTagView.isHidden = model.tag == 0
        mTagLabel.isHidden = model.tag == 0
        mTagLabel.text = "\(model.tag)"
    }

    //MARK: UI
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mTagView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = ThemeColor.main.color()
        return view
    }()
    
    lazy var mTagLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.main.color()
        return label
    }()
    
    lazy var mArrowImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "icon-arrow-solid"))
        return imageView
    }()
}
