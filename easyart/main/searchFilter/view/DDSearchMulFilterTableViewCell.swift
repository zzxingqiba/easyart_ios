//
//  DDSearchMulFilterTableViewCell.swift
//  easyart
//
//  Created by Damon on 2024/11/25.
//

import UIKit

class DDSearchMulFilterTableViewCell: DDTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.mArrowImageView.image = selected ? UIImage(named: "cell_selected_blue") :  UIImage(named: "icon_normal_solid")
    }
    
    override func createUI() {
        super.createUI()
        self.contentView.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        self.contentView.addSubview(mArrowImageView)
        mArrowImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalTo(15)
            make.height.equalTo(15)
        }
    }
    
    func updateUI(model: DDSearchMulFilterModel) {
        if let attributed = model.attributed {
            mTitleLabel.attributedText = attributed
        } else {
            mTitleLabel.text = model.title
        }
    }

    //MARK: UI
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mArrowImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "icon_normal_solid"))
        return imageView
    }()
}
