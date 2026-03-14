//
//  MeArtworksView.swift
//  easyart
//
//  Created by Damon on 2025/1/7.
//

import UIKit
import DDUtils
import SwiftyJSON
import RxRelay

class MeArtworksView: DDView {
    let becomeArtistClick = PublishRelay<Void>()
    
    override func createUI() {
        self.addSubview(mMeArtworksInfoView)
        mMeArtworksInfoView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        self.addSubview(mEmptyLabel)
        mEmptyLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(60)
            make.right.equalToSuperview().offset(-60)
            make.top.equalToSuperview().offset(60)
        }
        
        self.addSubview(mEmptyButton)
        mEmptyButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mEmptyLabel.snp.bottom).offset(15)
            make.height.equalTo(40)
        }
        
        self._bindView()
        self._loadData()
    }
    
    //MARK: UI
    lazy var mMeArtworksInfoView: MeArtworksInfoView = {
        let view = MeArtworksInfoView()
        return view
    }()
    
    lazy var mEmptyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "You're not a platform artist yet".localString
        label.font = .systemFont(ofSize: 13)
        label.textColor = ThemeColor.gray.color()
        return label
    }()
    
    lazy var mEmptyButton: DDButton = {
        let button = DDButton(imagePosition: .none)
        button.contentType = .contentFit(padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10), gap: 0)
        button.mTitleLabel.text = "Becoming an artist".localString
        button.mTitleLabel.font = .systemFont(ofSize: 13)
        button.mTitleLabel.textColor = ThemeColor.black.color()
        button.layer.borderColor = ThemeColor.black.color().cgColor
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 20
        return button
    }()
}

extension MeArtworksView {
    func reloadData() {
        self.mMeArtworksInfoView.loadData()
    }
}

extension MeArtworksView {
    func _bindView() {
        _ = self.mEmptyButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.becomeArtistClick.accept(())
        })
    }
    
    func _loadData() {
        _ = DDUserTools.shared.userInfo.subscribe(onNext: { [weak self] userModel in
            guard let self = self else { return }
            //入驻
            if userModel.role.user_role == 1 {
                //申请入驻
                self.mEmptyLabel.isHidden = false
                self.mEmptyButton.isHidden = false
                self.mEmptyLabel.text = "You're not a platform artist yet".localString
                self.mEmptyButton.mTitleLabel.text = "Becoming an artist".localString
                self.mMeArtworksInfoView.isHidden = true
            } else {
                //正常用户
                if userModel.role.user_role == 2 && userModel.role.status == 1 {
                    self.mEmptyLabel.isHidden = true
                    self.mEmptyButton.isHidden = true
                    self.mMeArtworksInfoView.isHidden = false
                } else if userModel.role.status == 5 || userModel.role.status == 7 || userModel.role.status == 8 {
                    //审核拒绝
                    self.mEmptyLabel.isHidden = false
                    self.mEmptyButton.isHidden = false
                    self.mMeArtworksInfoView.isHidden = true
                    self.mEmptyLabel.text = "Review failed, please re-submit.".localString
                    self.mEmptyButton.mTitleLabel.text = "Review".localString
                } else if userModel.role.status == 4 {
                    //审核拒绝
                    self.mEmptyLabel.isHidden = false
                    self.mEmptyButton.isHidden = false
                    self.mMeArtworksInfoView.isHidden = true
                    self.mEmptyLabel.text = "You have completed personal information authentication and can continue to the artist application process.".localString
                    self.mEmptyButton.mTitleLabel.text = "Continue to apply".localString
                } else {
                    //等待审核
                    self.mEmptyLabel.isHidden = false
                    self.mEmptyButton.isHidden = false
                    self.mMeArtworksInfoView.isHidden = true
                    self.mEmptyLabel.text = "Your artist profile has been submitted.\nThe verification process is expected to be completed within 3 business days.\nWe appreciate your patience.".localString
                    self.mEmptyButton.mTitleLabel.text = "View Details".localString
                }
            }
            
            
        })
    }
}
