//
//  SearchAuthorTableViewCell.swift
//  easyart
//
//  Created by Damon on 2024/10/24.
//

import UIKit

class SearchAuthorTableViewCell: DDTableViewCell {

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
            make.width.height.equalTo(46)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
        }
        
        self.contentView.addSubview(mNameLabel)
        mNameLabel.snp.makeConstraints { make in
            make.left.equalTo(mImageView.snp.right).offset(10)
            make.top.equalTo(mImageView).offset(4)
        }
        
        self.contentView.addSubview(mLineView)
        mLineView.snp.makeConstraints { make in
            make.left.equalTo(mNameLabel)
            make.bottom.equalTo(mImageView)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(1)
        }
        
        self.contentView.addSubview(mCategoryLabel)
        mCategoryLabel.snp.makeConstraints { make in
            make.left.equalTo(mNameLabel)
            make.top.equalTo(mNameLabel.snp.bottom).offset(3)
        }
    }

    func updateUI(model: DDSearchAuthorModel) {
        self.mImageView.kf.setImage(with: URL(string: model.head))
        self.mNameLabel.text = model.name
        self.mCategoryLabel.text = model.category
    }
    
    //MARK: UI
    lazy var mImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var mLineView: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeColor.line.color()
        return view
    }()
    
    lazy var mNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mCategoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = ThemeColor.gray.color()
        return label
    }()
}
