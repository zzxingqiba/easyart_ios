//
//  DDOrderTypeListCell.swift
//  easyart
//
//  Created by Damon on 2025/7/25.
//

import UIKit

class DDOrderTypeListCell: DDTableViewCell {

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
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        self.contentView.addSubview(mDesLabel)
        mDesLabel.snp.makeConstraints { make in
            make.left.equalTo(mTitleLabel.snp.right).offset(10)
            make.centerY.equalToSuperview()
        }
        
        self.contentView.addSubview(mImageView)
        mImageView.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(5)
            make.height.equalTo(8)
        }
        
        self.contentView.addSubview(mTagLabel)
        mTagLabel.snp.makeConstraints { make in
            make.left.equalTo(mTitleLabel.snp.right).offset(10)
            make.centerY.equalTo(mTitleLabel)
        }
        
        self.contentView.addSubview(mRedIconView)
        mRedIconView.snp.makeConstraints { make in
            make.left.equalTo(mTitleLabel.snp.right).offset(4)
            make.top.equalTo(mTitleLabel).offset(-2)
            make.width.height.equalTo(6)
        }
    }
    
    func updateUI(model: MeSettingModel) {
        mTitleLabel.text = model.title
        mDesLabel.text = model.des
    }

    //MARK: UI
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mDesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "me_jiantou"))
        return imageView
    }()
    
    lazy var mTagLabel: PaddingLabel = {
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
    
    lazy var mRedIconView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = .red
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 3
        return view
    }()
}
