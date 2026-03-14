//
//  ArtistSortVCTableViewCell.swift
//  easyart
//
//  Created by Damon on 2025/2/27.
//

import UIKit

class ArtistSortVCTableViewCell: DDTableViewCell {

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
            make.width.height.equalTo(60)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        self.contentView.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(mImageView).offset(5)
            make.left.equalTo(mImageView.snp.right).offset(20)
        }
        
        self.contentView.addSubview(mCatograyLabel)
        mCatograyLabel.snp.makeConstraints { make in
            make.left.equalTo(mTitleLabel)
            make.top.equalTo(mTitleLabel.snp.bottom).offset(5)
        }
        
        self.contentView.addSubview(mLineView)
        mLineView.snp.makeConstraints { make in
            make.left.equalTo(mTitleLabel)
            make.right.equalToSuperview()
            make.bottom.equalTo(mImageView)
            make.height.equalTo(1)
        }
    }
    
    func updateUI(model: MeArtistModel) {
        mImageView.kf.setImage(with: URL(string: model.photo_url))
        mTitleLabel.text = model.name
        mCatograyLabel.text = model.category_name
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
    
    lazy var mCatograyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = ThemeColor.gray.color()
        return label
    }()
    
    lazy var mLineView: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeColor.line.color()
        return view
    }()


}
