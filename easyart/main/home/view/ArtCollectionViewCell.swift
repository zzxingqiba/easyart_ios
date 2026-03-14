//
//  ArtCollectionViewCell.swift
//  easyart
//
//  Created by Damon on 2024/9/11.
//

import UIKit
import RxRelay

class ArtCollectionViewCell: DDCollectionViewCell {
    let favClickPublish = PublishRelay<Void>()
    let imgClickPublish = PublishRelay<Void>()
    let authorClickPublish = PublishRelay<Void>()
    
    override func createUI() {
        super.createUI()
        self.contentView.addSubview(mImageView)
        mImageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(self.contentView.snp.width)
        }
        
        self.contentView.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(mImageView).offset(8)
            make.top.equalTo(mImageView.snp.bottom).offset(14)
            make.right.equalToSuperview().offset(-80)
        }
        
        self.contentView.addSubview(mAuthorLabel)
        mAuthorLabel.snp.makeConstraints { make in
            make.left.equalTo(mTitleLabel)
            make.top.equalTo(mTitleLabel.snp.bottom).offset(3)
            make.right.equalToSuperview().offset(-8)
        }
        
        self.contentView.addSubview(mPriceLabel)
        mPriceLabel.snp.makeConstraints { make in
            make.left.equalTo(mTitleLabel)
            make.top.equalTo(mAuthorLabel.snp.bottom).offset(5)
        }
        
        self.contentView.addSubview(mFavButton)
        mFavButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-8)
            make.centerY.equalTo(mTitleLabel)
        }
        
        self.contentView.addSubview(mSoldOutView)
        mSoldOutView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
            make.width.height.equalTo(26)
        }
        
        self._bindView()
    }
    
    func updateUI(model: ArtModel) {
        mImageView.kf.setImage(with: URL(string: model.photo_url))
        mTitleLabel.text = model.name
        mAuthorLabel.attributedText = NSAttributedString(string: model.artist_name, attributes: [NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue, .underlineColor: ThemeColor.gray.color()])
        let attributedString = NSMutableAttributedString(string: "$", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)])
        attributedString.append(NSAttributedString(string: model.pay_price, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)]))
        if (!model.price.isEmpty && model.price != "0") {
            attributedString.append(NSAttributedString(string: " "))
            attributedString.append(NSAttributedString(string: model.price, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12), .foregroundColor: ThemeColor.gray.color(), .strikethroughStyle: NSUnderlineStyle.single.rawValue, .strokeColor: ThemeColor.gray.color()]))
        }
        self.mPriceLabel.attributedText = attributedString
        mFavButton.mTitleLabel.text = "\(model.collect_num)"
        if model.is_collect {
            mFavButton.normalImage = UIImage(named: "home_aixin")
        } else {
            mFavButton.normalImage = UIImage(named: "home_aixin-h")
        }
        if model.show_status == GoodsShowStatus.sold.rawValue {
            mSoldOutView.isHidden = false
            mSoldOutView.text = "Sold".localString
            mSoldOutView.backgroundColor = ThemeColor.red.color()
        } else if model.show_status == GoodsShowStatus.new.rawValue {
            mSoldOutView.isHidden = false
            mSoldOutView.text = "New release".localString
            mSoldOutView.backgroundColor = ThemeColor.main.color()
        } else {
            mSoldOutView.isHidden = true
        }
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
    
    lazy var mAuthorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = ThemeColor.gray.color()
        label.isUserInteractionEnabled = true
        return label
    }()
    
    lazy var mPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mFavButton: DDButton = {
        let button = DDButton(imagePosition: .right)
        button.normalImage = UIImage(named: "home_aixin-h")
        button.mTitleLabel.text = "0"
        button.mTitleLabel.font = .systemFont(ofSize: 12)
        button.mTitleLabel.textColor = ThemeColor.gray.color()
        button.imageSize = CGSize(width: 10, height: 10)
        button.contentType = .contentFit(padding: .zero, gap: 3)
        return button
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
}

extension ArtCollectionViewCell {
    func _bindView() {
        _ = self.mFavButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.favClickPublish.accept(())
        })
        
        let tap = UITapGestureRecognizer()
        _ = tap.rx.event.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.imgClickPublish.accept(())
        })
        self.mImageView.addGestureRecognizer(tap)
        
        let tap2 = UITapGestureRecognizer()
        _ = tap2.rx.event.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.authorClickPublish.accept(())
        })
        self.mAuthorLabel.addGestureRecognizer(tap2)
    }
}
