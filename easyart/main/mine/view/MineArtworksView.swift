//
//  MineArtworks.swift
//  easyart
//
//  Created by 崭新的旧刀 on 2026/3/18.
//

import DDUtils
import HDHUD
import RxRelay
import SwiftyJSON
import UIKit
import ZLPhotoBrowser

class MineArtworksView: DDView {
    let clickPublish = PublishRelay<Void>()
    private var authorModel = SettleInAuthorModel()
    private var profileModel = SettleInProfileModel()
    
    private var list = [MeArtistModel?]()
    
    // 👇 只加这一句
    private var isIntroExpanded = false

    override func createUI() {
        super.createUI()
        
        self.addSubview(self.mTitleLabel)
        self.mTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        self.addSubview(self.mEditButton)
        self.mEditButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.mTitleLabel)
            make.right.equalToSuperview()
            make.height.equalTo(23)
        }
        
        self.addSubview(self.mImageView)
        self.mImageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(self.mTitleLabel.snp.bottom).offset(22)
            make.width.height.equalTo(50)
        }
        
        self.addSubview(self.mAddImageView)
        self.mAddImageView.snp.makeConstraints { make in
            make.right.top.equalTo(self.mImageView)
            make.width.height.equalTo(14)
        }
        
        self.addSubview(self.mNameLabel)
        self.mNameLabel.snp.makeConstraints { make in
            make.left.equalTo(self.mImageView.snp.right).offset(16)
            make.bottom.equalTo(self.mImageView.snp.centerY).offset(-3)
        }
        
        self.addSubview(self.mCityLabel)
        self.mCityLabel.snp.makeConstraints { make in
            make.left.equalTo(self.mImageView.snp.right).offset(16)
            make.top.equalTo(self.mImageView.snp.centerY).offset(3)
        }
        
        self.addSubview(self.mIntroLabel)
        self.mIntroLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(self.mImageView.snp.bottom).offset(25)
        }
        
        self.addSubview(self.mListTitleLabel)
        self.mListTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(self.mIntroLabel.snp.bottom).offset(25)
        }
        
        self.addSubview(self.mSortButton)
        self.mSortButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalTo(self.mListTitleLabel)
            make.height.equalTo(23)
        }
        
        self.addSubview(self.mMeArtistTipView)
        self.mMeArtistTipView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.mListTitleLabel.snp.bottom).offset(40)
            make.height.lessThanOrEqualTo(400)
            make.bottom.equalToSuperview()
        }
        
        self._bindView()
        self.loadData()
    }
    
    // MARK: UI
    
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Artist profile".localString
        label.font = .systemFont(ofSize: 15)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mEditButton: DDButtonFixed = {
        let button = DDButtonFixed(imagePosition: .none)
        button.contentType = .contentFit(padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0), gap: 0)
        button.mTitleLabel.attributedText = NSAttributedString(string: "Edit".localString, attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, .underlineColor: ThemeColor.black.color()])
        button.mTitleLabel.font = .systemFont(ofSize: 13)
        button.mTitleLabel.textColor = ThemeColor.black.color()
        return button
    }()
    
    lazy var mImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.kf.indicatorType = .activity
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 25
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var mAddImageView: UIImageView = .init(image: UIImage(named: "icon-add-me"))
    
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
    
    lazy var mListTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Artworks".localString
        label.font = .systemFont(ofSize: 15)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mSortButton: DDButtonFixed = {
        let button = DDButtonFixed(imagePosition: .none)
        button.contentType = .contentFit(padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0), gap: 0)
        button.mTitleLabel.attributedText = NSAttributedString(string: "Sort".localString, attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, .underlineColor: ThemeColor.black.color()])
        button.mTitleLabel.font = .systemFont(ofSize: 13)
        button.mTitleLabel.textColor = ThemeColor.black.color()
        return button
    }()
    
    lazy var mMeArtistTipView: MeArtistTipView = .init()
}

extension MineArtworksView {
    func _bindView() {
        // 简介展开收回手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapIntro))
        mIntroLabel.addGestureRecognizer(tap)
    }

    // 点击展开/收起
    @objc private func didTapIntro() {
        isIntroExpanded.toggle()
        updateIntroLabel()
    }
    
    // 👇 公共方法：统一刷新简介
    private func updateIntroLabel() {
        let fullText = self.authorModel.intro
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.3
        paragraphStyle.lineBreakMode = .byTruncatingTail
        
        if isIntroExpanded {
            // 展开
            mIntroLabel.attributedText = NSAttributedString(
                string: fullText,
                attributes: [.paragraphStyle: paragraphStyle]
            )
        } else {
            // 折叠
            if fullText.count > 100 {
                let short = String(fullText.prefix(100))
                let readMore = NSAttributedString(
                    string: "Read more",
                    attributes: [
                        .underlineStyle: NSUnderlineStyle.single.rawValue,
                        .underlineColor: ThemeColor.gray.color(),
                        .foregroundColor: ThemeColor.black.color()
                    ]
                )
                let attr = NSMutableAttributedString(string: short + "……")
                attr.append(readMore)
                attr.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attr.length))
                mIntroLabel.attributedText = attr
            } else {
                mIntroLabel.attributedText = NSAttributedString(
                    string: fullText,
                    attributes: [.paragraphStyle: paragraphStyle]
                )
            }
        }
    }

    func loadData() {
        _ = DDUserTools.shared.userInfo.subscribe(onNext: { [weak self] userModel in
            guard let self = self else { return }
            self.authorModel.update(model: userModel.userRoleDetail)
            self.profileModel.update(model: userModel.userRoleDetail)
            
            self.mImageView.kf.setImage(with: URL(string: self.authorModel.coverFile.fileurl))
            self.mNameLabel.text = self.authorModel.name
            self.mCityLabel.text = userModel.userRoleDetail.country_name
            
            // 展开收回
            self.updateIntroLabel()
        })
     }
}
