//
//  ArtistEditSelecteTableViewCell.swift
//  easyart
//
//  Created by Damon on 2025/1/16.
//

import UIKit

class ArtistEditSelecteTableViewCell: DDTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.mArrowImageView.image = selected ? UIImage(named: "artist_edit_selected") :  UIImage(named: "artist_edit_normal")
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
        
        self.contentView.addSubview(mLineView)
        mLineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
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
        let imageView = UIImageView(image: UIImage(named: "artist_edit_normal"))
        return imageView
    }()
    
    lazy var mLineView: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeColor.line.color()
        return view
    }()

}
