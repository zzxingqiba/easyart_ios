//
//  ArtistEditExpectedPriceView.swift
//  easyart
//
//  Created by Damon on 2025/1/10.
//

import UIKit

class ArtistEditExpectedPriceView: DDView {
    
    override func createUI() {
        super.createUI()
        self.addSubview(mBackgroundView)
        mBackgroundView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview()
        }
        
        self.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        mBackgroundView.addSubview(mExpectedBetweenView)
        mExpectedBetweenView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(16)
        }
        
        let lineView = UIView()
        lineView.backgroundColor = ThemeColor.line.color()
        mBackgroundView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.left.right.equalTo(mExpectedBetweenView)
            make.top.equalTo(mExpectedBetweenView.snp.bottom).offset(16)
            make.height.equalTo(0.5)
        }
        
        mBackgroundView.addSubview(mCNYView)
        mCNYView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(lineView.snp.bottom)
            make.height.lessThanOrEqualTo(500)
        }
        
        mCNYView.addSubview(mCNYBetweenView)
        mCNYBetweenView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(16)
        }
        
        let lineView2 = UIView()
        lineView2.backgroundColor = ThemeColor.line.color()
        mCNYView.addSubview(lineView2)
        lineView2.snp.makeConstraints { make in
            make.left.right.equalTo(mExpectedBetweenView)
            make.top.equalTo(mCNYBetweenView.snp.bottom).offset(16)
            make.height.equalTo(0.5)
            make.bottom.equalToSuperview()
        }
        
        mBackgroundView.addSubview(mDeductingBetweenView)
        mDeductingBetweenView.snp.makeConstraints { make in
            make.left.right.equalTo(mExpectedBetweenView)
            make.top.equalTo(mCNYView.snp.bottom).offset(16)
        }
        
        mBackgroundView.addSubview(mServiceFeeBetweenView)
        mServiceFeeBetweenView.snp.makeConstraints { make in
            make.left.right.equalTo(mExpectedBetweenView)
            make.top.equalTo(mDeductingBetweenView.snp.bottom).offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        self._bindView()
    }

    //MARK: UI
    lazy var mBackgroundView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.dd.color(hexValue: 0xE6E6E6).cgColor
        view.layer.borderWidth = 0.5
        return view
    }()
    
    lazy var mTitleLabel: PaddingLabel = {
        let label = PaddingLabel(withInsets: 0, 0, 3, 10)
        label.backgroundColor = ThemeColor.white.color()
        label.text = "Expected income".localString
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mExpectedBetweenView: DDSpaceBetweenView = {
        let view = DDSpaceBetweenView()
        view.mTitleLabel.text = "$"
        view.mContentLabel.text = "-"
        return view
    }()
    
    lazy var mCNYView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var mCNYBetweenView: DDSpaceBetweenView = {
        let view = DDSpaceBetweenView()
        view.mTitleLabel.text = "￥"
        view.mContentLabel.text = "-"
        return view
    }()
    
    lazy var mDeductingBetweenView: DDSpaceBetweenView = {
        let view = DDSpaceBetweenView()
        view.mTitleLabel.font = .systemFont(ofSize: 12)
        view.mTitleLabel.text = "Deducting expenses"
        view.mContentLabel.text = "$"
        view.mContentLabel.font = .systemFont(ofSize: 12)
        return view
    }()
    
    lazy var mServiceFeeBetweenView: DDSpaceBetweenView = {
        let view = DDSpaceBetweenView()
        view.heightPosView = 1
        view.mTitleLabel.text = "service fee 40.0%\n(Including apple tax)"
        view.mTitleLabel.numberOfLines = 0
        view.mTitleLabel.font = .systemFont(ofSize: 12)
        view.mTitleLabel.textColor = ThemeColor.gray.color()
        view.mContentLabel.text = "-"
        view.mContentLabel.font = .systemFont(ofSize: 12)
        view.mContentLabel.textColor = ThemeColor.gray.color()
        return view
    }()
}

extension ArtistEditExpectedPriceView {
    func _bindView() {
        _ = DDUserTools.shared.userInfo.subscribe(onNext: { [weak self] userModel in
            guard let self = self else { return }
            self.mCNYView.isHidden = !userModel.userRoleDetail.is_show_cny
            self.mCNYView.snp.updateConstraints { make in
                make.height.lessThanOrEqualTo(self.mCNYView.isHidden ? 0.1 : 500)
            }
        })
    }
}
