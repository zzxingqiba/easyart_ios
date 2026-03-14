//
//  GoodsDetailAuthorView.swift
//  easyart
//
//  Created by Damon on 2024/11/15.
//

import UIKit
import SwiftyJSON
import RxRelay

class GoodsDetailAuthorView: DDView {
    let followPublish = PublishRelay<Bool>()
    private var isFollowed = false
    private var model = JSON()
    override func createUI() {
        super.createUI()
        let topLine = UIView()
        topLine.backgroundColor = ThemeColor.line.color()
        self.addSubview(topLine)
        topLine.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        self.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(topLine.snp.bottom).offset(16)
        }
        
        self.addSubview(mImageView)
        mImageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(mTitleLabel.snp.bottom).offset(22)
            make.width.height.equalTo(50)
        }
        
        self.addSubview(mFollowButton)
        mFollowButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalTo(mImageView)
        }
        
        self.addSubview(mNameLabel)
        mNameLabel.snp.makeConstraints { make in
            make.left.equalTo(mImageView.snp.right).offset(16)
            make.bottom.equalTo(mImageView.snp.centerY).offset(-3)
        }
        
        self.addSubview(mCityLabel)
        mCityLabel.snp.makeConstraints { make in
            make.left.equalTo(mImageView.snp.right).offset(16)
            make.top.equalTo(mImageView.snp.centerY).offset(3)
        }
        
        self.addSubview(mIntroLabel)
        mIntroLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(mImageView.snp.bottom).offset(25)
            make.bottom.equalToSuperview().offset(-25)
        }
        
        self._bindView()
    }
    
    func updateUI(model: JSON) {
        self.model = model
        self.mImageView.kf.setImage(with: URL(string: model["artist_face_url"].stringValue))
        self.mNameLabel.text = model["artist_name"].stringValue
        self.mCityLabel.text = model["artist_country_name"].stringValue
        var info = model["artist_info"].stringValue
        if info.length > 100 {
            info = info.dd.subString(rang: NSRange(location: 0, length: 100))
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 1.3
            let read = NSAttributedString(string: "Read more", attributes: [NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue, .underlineColor: ThemeColor.gray.color(), .foregroundColor: ThemeColor.black.color()])
            let attri = NSMutableAttributedString(string: info + "……")
            attri.append(read)
            attri.addAttributes([NSAttributedString.Key.paragraphStyle : paragraphStyle], range: NSRange(location: 0, length: attri.length))
            self.mIntroLabel.attributedText = attri
        } else {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 1.3
            self.mIntroLabel.attributedText = NSAttributedString(string: info, attributes: [NSAttributedString.Key.paragraphStyle : paragraphStyle])
        }
        self.follow(isFollow: model["artist_is_collect"].boolValue)
    }
    
    func follow(isFollow: Bool) {
        self.isFollowed = isFollow
        if isFollow {
            mFollowButton.backgroundColor = UIColor.dd.color(hexValue: 0xEDEDED)
            mFollowButton.mTitleLabel.text = "Followed".localString
            mFollowButton.layer.borderColor = UIColor.clear.cgColor
        } else {
            mFollowButton.backgroundColor = ThemeColor.white.color()
            mFollowButton.mTitleLabel.text = "Follow".localString
            mFollowButton.layer.borderColor = UIColor.dd.color(hexValue: 0xA39FAC).cgColor
        }
    }
    
    //MARK: UI
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Artist profile".localString
        label.font = .systemFont(ofSize: 15)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 25
        return imageView
    }()
    
    lazy var mNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mCityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = ThemeColor.gray.color()
        return label
    }()
    
    lazy var mIntroLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12)
        label.textColor = ThemeColor.black.color()
        return label
    }()

    lazy var mFollowButton: DDButton = {
        let button = DDButton(imagePosition: .none)
        button.imageSize = CGSizeMake(0, 30)
        button.contentType = .contentFit(padding: UIEdgeInsets(top: 3, left: 12, bottom: 3, right: 12), gap: 0)
        button.backgroundColor = ThemeColor.white.color()
        button.mTitleLabel.text = "Follow".localString
        button.mTitleLabel.textColor = ThemeColor.black.color()
        button.layer.borderColor = UIColor.dd.color(hexValue: 0xA39FAC).cgColor
        button.layer.borderWidth = 0.5
        return button
    }()
    
}

extension GoodsDetailAuthorView {
    func _bindView() {
        let tap = UITapGestureRecognizer()
        _ = tap.rx.event.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 1.3
            self.mIntroLabel.attributedText = NSAttributedString(string: model["artist_info"].stringValue, attributes: [NSAttributedString.Key.paragraphStyle : paragraphStyle])
        })
        self.mIntroLabel.addGestureRecognizer(tap)
        
        _ = mFollowButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.followPublish.accept(self.isFollowed)
        })
    }
}
