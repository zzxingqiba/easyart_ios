//
//  ArtistCollectionViewCell.swift
//  easyart
//
//  Created by Damon on 2025/1/7.
//

import UIKit

class ArtistCollectionViewCell: DDCollectionViewCell {
    
    override func createUI() {
        super.createUI()
        self.contentView.addSubview(mNormalView)
        mNormalView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mNormalView.addSubview(mImageView)
        mImageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(self.contentView.snp.width)
        }
        
        mImageView.addSubview(mMaskView)
        mMaskView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mNormalView.addSubview(mStatusLabel)
        mStatusLabel.snp.makeConstraints { make in
            make.left.right.equalTo(mImageView)
            make.top.equalTo(mImageView)
            make.height.equalTo(20)
        }
        
        mNormalView.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(mImageView).offset(8)
            make.top.equalTo(mImageView.snp.bottom).offset(14)
            make.right.equalToSuperview().offset(-80)
        }
        
        mNormalView.addSubview(mPriceLabel)
        mPriceLabel.snp.makeConstraints { make in
            make.left.equalTo(mTitleLabel)
            make.top.equalTo(mTitleLabel.snp.bottom).offset(5)
        }
        
        self.contentView.addSubview(mSoldOutView)
        mSoldOutView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
            make.width.height.equalTo(26)
        }
        
        //
        self.contentView.addSubview(mEmptyView)
        mEmptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mEmptyView.addSubview(mMaskImageView)
        mMaskImageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(self.contentView.snp.width)
        }
        mMaskImageView.addSubview(mAddImageView)
        mAddImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(13)
            make.height.equalTo(13)
        }
        mMaskImageView.addSubview(mAddTitleLabel)
        mAddTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mAddImageView.snp.bottom).offset(7)
        }
        
    }
    
    func updateUI(model: MeArtistModel?) {
        if let model = model {
            self.mSoldOutView.isHidden = true
            self.mNormalView.isHidden = false
            self.mEmptyView.isHidden = true
            mImageView.kf.setImage(with: URL(string: model.photo_url))
            mTitleLabel.text = model.name
            //
            let attributedString = NSMutableAttributedString(string: "$", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)])
            attributedString.append(NSAttributedString(string: model.pay_price, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)]))
            self.mPriceLabel.attributedText = attributedString
            self.mMaskView.isHidden = true
            self.mMaskView.attributedText = nil
            if model.status == 1 {
                mStatusLabel.isHidden = false
                mStatusLabel.backgroundColor = ThemeColor.black.color()
                mStatusLabel.text = "Removed".localString
                self.mMaskView.isHidden = false
                self.mMaskView.attributedText = NSAttributedString(string: "Edite".localString, attributes: [NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue, .underlineColor: ThemeColor.white.color()])
            } else if model.status == 1 {
                mStatusLabel.isHidden = false
                mStatusLabel.backgroundColor = ThemeColor.black.color()
                mStatusLabel.text = "未发布".localString
                self.mMaskView.isHidden = true
            } else if model.show_status == GoodsShowStatus.draf.rawValue {
                mStatusLabel.isHidden = false
                mStatusLabel.backgroundColor = ThemeColor.black.color()
                mStatusLabel.text = "draft".localString
                self.mMaskView.isHidden = false
                self.mMaskView.attributedText = NSAttributedString(string: "Edite".localString, attributes: [NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue, .underlineColor: ThemeColor.white.color()])
            } else if model.show_status == GoodsShowStatus.reviewFail.rawValue {
                mStatusLabel.isHidden = false
                mStatusLabel.backgroundColor = UIColor.dd.color(hexValue: 0xF50045)
                mStatusLabel.text = "failed".localString
                self.mMaskView.isHidden = false
                self.mMaskView.attributedText = NSAttributedString(string: "Re-submit".localString, attributes: [NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue, .underlineColor: ThemeColor.white.color()])
            } else if model.show_status == GoodsShowStatus.waitReview.rawValue {
                mStatusLabel.isHidden = false
                mStatusLabel.backgroundColor = UIColor.dd.color(hexValue: 0x1053FF)
                mStatusLabel.text = "pending".localString
//                self.mMaskView.isHidden = false
//                self.mMaskView.attributedText = NSAttributedString(string: "查看".localString, attributes: [NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue, .underlineColor: ThemeColor.white.color()])
            } else if model.show_status == GoodsShowStatus.new.rawValue {
                mStatusLabel.isHidden = false
                mStatusLabel.backgroundColor = ThemeColor.main.color()
                mStatusLabel.text = "New".localString
            } else if model.show_status == GoodsShowStatus.sold.rawValue {
                mStatusLabel.isHidden = true
                mSoldOutView.isHidden = false
                mSoldOutView.text = "Sold".localString
                mSoldOutView.backgroundColor = ThemeColor.red.color()
            } else {
                mStatusLabel.isHidden = true
            }
        } else {
            //添加
            self.mNormalView.isHidden = true
            self.mEmptyView.isHidden = false
        }
    }
    
    //MARK: UI
    lazy var mNormalView: UIView = {
        let view = UIView()
        return view
    }()
    
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
    
    lazy var mStatusLabel: PaddingLabel = {
        let label = PaddingLabel(withInsets: 5, 5, 8, 8)
        label.isHidden = true
        label.font = .systemFont(ofSize: 12)
        label.textColor = ThemeColor.white.color()
        label.text = "New"
        label.backgroundColor = ThemeColor.main.color()
        return label
    }()
    
    lazy var mPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mMaskView: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.textColor = ThemeColor.white.color()
        view.isHidden = true
        view.font = .systemFont(ofSize: 18)
        view.backgroundColor = UIColor.dd.color(hexValue: 0x000000, alpha: 0.6)
        return view
    }()
    
    lazy var mSoldOutView: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.isHidden = true
        label.font = .systemFont(ofSize: 10)
        label.backgroundColor = UIColor.dd.color(hexValue: 0xF50045)
        label.textColor = UIColor.dd.color(hexValue: 0xffffff)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 13
        return label
    }()
    
    //默认样式
    lazy var mEmptyView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    lazy var mAddImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "icon-me-cell-add"))
        return imageView
    }()
    
    lazy var mAddTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Add artwork".localString
        label.font = .systemFont(ofSize: 12)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mMaskImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "me-artist-border"))
        return imageView
    }()
}
