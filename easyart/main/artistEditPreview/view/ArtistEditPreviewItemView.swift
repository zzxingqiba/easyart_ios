//
//  ArtistEditPreviewItemView.swift
//  easyart
//
//  Created by Damon on 2025/1/24.
//

import UIKit
import RxRelay

class ArtistEditPreviewItemView: DDView {
    let editPublish = PublishRelay<Void>()
    
    var showEditButton = false {
        didSet {
            self.mTitleLabel.isHidden = !showEditButton
            mEditButton.isHidden = !showEditButton
            mArtwordView.snp.updateConstraints { make in
                make.top.equalTo(mTitleLabel.snp.bottom).offset(showEditButton ? 20 : -20)
            }
        }
    }
    
    var showProfile = false {
        didSet {
            mArtworkProfileView.isHidden = !showProfile
            if !showProfile {
                mArtwordView.mContentLabel.text = nil
            }
            mArtworkProfileView.snp.updateConstraints { make in
                make.height.greaterThanOrEqualTo( showProfile ? 24 : 0)
            }
        }
    }
    
    override func createUI() {
        super.createUI()
        
        self.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(10)
        }
        
        self.addSubview(mEditButton)
        mEditButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalTo(mTitleLabel)
            make.height.equalTo(30)
        }
        
        self.addSubview(mArtwordView)
        mArtwordView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(mTitleLabel.snp.bottom).offset(4)
            make.height.equalTo(16)
        }
        
        self.addSubview(mPriceView)
        mPriceView.snp.makeConstraints { make in
            make.left.right.equalTo(mArtwordView)
            make.top.equalTo(mArtwordView.snp.bottom).offset(10)
            make.height.equalTo(mArtwordView)
        }
        
        self.addSubview(mIncomeView)
        mIncomeView.snp.makeConstraints { make in
            make.left.right.equalTo(mArtwordView)
            make.top.equalTo(mPriceView.snp.bottom).offset(10)
            make.height.equalTo(mArtwordView)
        }
        
        self.addSubview(mInfoTitleLabel)
        mInfoTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(mIncomeView.snp.bottom).offset(22)
        }
        
        let lineView = UIView()
        lineView.backgroundColor = ThemeColor.line.color()
        self.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.left.equalTo(mInfoTitleLabel.snp.right).offset(10)
            make.centerY.equalTo(mInfoTitleLabel)
            make.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        self.addSubview(mMediumView)
        mMediumView.snp.makeConstraints { make in
            make.left.right.equalTo(mArtwordView)
            make.top.equalTo(mInfoTitleLabel.snp.bottom).offset(10)
            make.height.equalTo(mArtwordView)
        }
        
        self.addSubview(mYearView)
        mYearView.snp.makeConstraints { make in
            make.left.right.equalTo(mArtwordView)
            make.top.equalTo(mMediumView.snp.bottom).offset(10)
            make.height.equalTo(mArtwordView)
        }
        
        self.addSubview(mMaterialView)
        mMaterialView.snp.makeConstraints { make in
            make.left.right.equalTo(mArtwordView)
            make.top.equalTo(mYearView.snp.bottom).offset(10)
            make.height.equalTo(mArtwordView)
        }
        
        self.addSubview(mSizeView)
        mSizeView.snp.makeConstraints { make in
            make.left.right.equalTo(mArtwordView)
            make.top.equalTo(mMaterialView.snp.bottom).offset(10)
            make.height.equalTo(mArtwordView)
        }
        
        self.addSubview(mFrameView)
        mFrameView.snp.makeConstraints { make in
            make.left.right.equalTo(mArtwordView)
            make.top.equalTo(mSizeView.snp.bottom).offset(10)
            make.height.equalTo(mArtwordView)
        }
        
        self.addSubview(mFormatView)
        mFormatView.snp.makeConstraints { make in
            make.left.right.equalTo(mArtwordView)
            make.top.equalTo(mFrameView.snp.bottom).offset(10)
            make.height.equalTo(24)
        }
        
        self.addSubview(mSellableView)
        mSellableView.snp.makeConstraints { make in
            make.left.right.equalTo(mArtwordView)
            make.top.equalTo(mFormatView.snp.bottom).offset(10)
            make.height.equalTo(mArtwordView)
        }
        
        self.addSubview(mRarityView)
        mRarityView.snp.makeConstraints { make in
            make.left.right.equalTo(mArtwordView)
            make.top.equalTo(mSellableView.snp.bottom).offset(10)
            make.height.equalTo(mArtwordView)
        }
        
        self.addSubview(mSignatureView)
        mSignatureView.snp.makeConstraints { make in
            make.left.right.equalTo(mArtwordView)
            make.top.equalTo(mRarityView.snp.bottom).offset(10)
            make.height.equalTo(mArtwordView)
        }
        
        self.addSubview(mArtworkProfileView)
        mArtworkProfileView.snp.makeConstraints { make in
            make.left.right.equalTo(mArtwordView)
            make.top.equalTo(mSignatureView.snp.bottom).offset(10)
            make.height.greaterThanOrEqualTo(24)
        }
        
        let bottomLineView = UIView()
        bottomLineView.backgroundColor = ThemeColor.line.color()
        self.addSubview(bottomLineView)
        bottomLineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(0.5)
            make.top.equalTo(mArtworkProfileView.snp.bottom).offset(20)
            make.bottom.equalToSuperview()
        }
        
        self._bindView()
    }

    //MARK: UI
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mEditButton: DDButton = {
        let button = DDButton(imagePosition: .none)
        button.isHidden = true
        button.contentType = .contentFit(padding: .zero, gap: 0)
        button.mTitleLabel.attributedText = NSAttributedString(string: "Edit".localString, attributes: [NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue, .underlineColor: ThemeColor.black.color()])
        button.mTitleLabel.font = .systemFont(ofSize: 13)
        button.mTitleLabel.textColor = ThemeColor.black.color()
        return button
    }()
    
    lazy var mArtwordView: DDSpaceBetweenView = {
        let view = DDSpaceBetweenView()
        view.mTitleLabel.text = "Artwork".localString
        view.mContentLabel.text = "EASYART".localString
        return view
    }()
    
    lazy var mPriceView: DDSpaceBetweenView = {
        let view = DDSpaceBetweenView()
        view.mTitleLabel.text = "Price".localString
        view.mContentLabel.text = "$ 10000".localString
        return view
    }()
    
    lazy var mIncomeView: DDSpaceBetweenView = {
        let view = DDSpaceBetweenView()
        view.mTitleLabel.text = "Expected income".localString
        view.mContentLabel.text = "$ 10000".localString
        return view
    }()
    
    lazy var mInfoTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Detailed information".localString
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.gray.color()
        return label
    }()
    
    lazy var mMediumView: DDSpaceBetweenView = {
        let view = DDSpaceBetweenView()
        view.mTitleLabel.text = "Medium".localString
        view.mTitleLabel.textColor = ThemeColor.gray.color()
        view.mContentLabel.text = "$ 10000".localString
        view.mContentLabel.textColor = ThemeColor.gray.color()
        return view
    }()
    
    lazy var mYearView: DDSpaceBetweenView = {
        let view = DDSpaceBetweenView()
        view.mTitleLabel.text = "Year".localString
        view.mTitleLabel.textColor = ThemeColor.gray.color()
        view.mContentLabel.text = "2023".localString
        view.mContentLabel.textColor = ThemeColor.gray.color()
        return view
    }()

    lazy var mMaterialView: DDSpaceBetweenView = {
        let view = DDSpaceBetweenView()
        view.mTitleLabel.text = "Material".localString
        view.mTitleLabel.textColor = ThemeColor.gray.color()
        view.mContentLabel.text = "blown glass".localString
        view.mContentLabel.textColor = ThemeColor.gray.color()
        return view
    }()
    
    lazy var mSizeView: DDSpaceBetweenView = {
        let view = DDSpaceBetweenView()
        view.mTitleLabel.text = "Size".localString
        view.mTitleLabel.textColor = ThemeColor.gray.color()
        view.mContentLabel.text = "55 x 55".localString
        view.mContentLabel.textColor = ThemeColor.gray.color()
        return view
    }()
    
    lazy var mFrameView: DDSpaceBetweenView = {
        let view = DDSpaceBetweenView()
        view.mTitleLabel.text = "Frame".localString
        view.mTitleLabel.textColor = ThemeColor.gray.color()
        view.mContentLabel.text = "Not Include".localString
        view.mContentLabel.textColor = ThemeColor.gray.color()
        return view
    }()
    
    lazy var mFormatView: DDSpaceBetweenView = {
        let view = DDSpaceBetweenView()
        view.mTitleLabel.text = "Format".localString
        view.mTitleLabel.textColor = ThemeColor.gray.color()
        view.mContentLabel.textColor = ThemeColor.gray.color()
        return view
    }()
    
    lazy var mSellableView: DDSpaceBetweenView = {
        let view = DDSpaceBetweenView()
        view.mTitleLabel.text = "Sellable quantity".localString
        view.mTitleLabel.textColor = ThemeColor.gray.color()
        view.mContentLabel.text = "1".localString
        view.mContentLabel.textColor = ThemeColor.gray.color()
        return view
    }()
    
    lazy var mRarityView: DDSpaceBetweenView = {
        let view = DDSpaceBetweenView()
        view.mTitleLabel.text = "Rarity".localString
        view.mTitleLabel.textColor = ThemeColor.gray.color()
        view.mContentLabel.text = "2023".localString
        view.mContentLabel.textColor = ThemeColor.gray.color()
        return view
    }()
    
    lazy var mSignatureView: DDSpaceBetweenView = {
        let view = DDSpaceBetweenView()
        view.mTitleLabel.text = "Signature".localString
        view.mTitleLabel.textColor = ThemeColor.gray.color()
        view.mContentLabel.text = "Printed signature".localString
        view.mContentLabel.textColor = ThemeColor.gray.color()
        return view
    }()
    
    lazy var mArtworkProfileView: DDSpaceBetweenView = {
        let view = DDSpaceBetweenView()
        view.mTitleLabel.text = "Artwork profile".localString
        view.mTitleLabel.textColor = ThemeColor.gray.color()
        view.mContentLabel.text = "-".localString
        view.mContentLabel.textColor = ThemeColor.gray.color()
        return view
    }()
}

extension ArtistEditPreviewItemView {
    func updateUI(model: ArtistEditModel, sku: ArtistEditSKUModel) {
        mArtwordView.mContentLabel.text = model.name
        mPriceView.mContentLabel.text = "\(sku.workPrice)"
        mIncomeView.mContentLabel.text = "\(Int(Double(sku.workPrice) * 0.6))"
        if model.categoryID > 0, let json = DDServerConfigTools.shared.getCategory(id: model.categoryID) {
            mMediumView.mContentLabel.text = json["title"].stringValue
        }
        if let year = sku.year, year > 0 {
            mYearView.mContentLabel.text = "\(year)"
        } else {
            mYearView.mContentLabel.text = "-"
        }
        mMaterialView.mContentLabel.text = sku.meterialString()
        var size = "\(sku.length) cm × \(sku.width) cm"
        if sku.height > 0 {
            size = size + " × \(sku.height) cm"
        }
        //装裱尺寸
        mSizeView.mContentLabel.text = size
        
        if let frameType = sku.frameType {
            mFrameView.mContentLabel.text = frameType.title()
        }
        if let numberType = sku.numberType {
            mRarityView.mContentLabel.text = numberType.title()
        }
        if sku.frameType == .include {
            var packageSize = "\(sku.length_mount) cm × \(sku.width_mount) cm"
            if sku.height_mount > 0 {
                packageSize = packageSize + " × \(sku.height_mount) cm"
            }
            mFormatView.mContentLabel.text = packageSize
            mFormatView.isHidden = false
            mFormatView.snp.updateConstraints { make in
                make.top.equalTo(mFrameView.snp.bottom).offset(10)
                make.height.equalTo(24)
            }
        } else {
            mFormatView.isHidden = true
            mFormatView.snp.updateConstraints { make in
                make.top.equalTo(mFrameView.snp.bottom).offset(0)
                make.height.equalTo(0)
            }
        }
        mSignatureView.mContentLabel.text = sku.hasSignature ? "YES".localString : "NO".localString
        mArtworkProfileView.mContentLabel.text = model.intro
    }
    
    func _bindView() {
        _ = self.mEditButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.editPublish.accept(())
        })
    }
}
