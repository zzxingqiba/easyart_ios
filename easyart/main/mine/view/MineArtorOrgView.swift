//
//  MineArtorOrgView.swift
//  easyart
//
//  Created by 崭新的旧刀 on 2026/3/18.
//
import RxRelay
import SnapKit
import UIKit

class MineArtorOrgView: DDView {
    let joinPlatformClick = PublishRelay<Void>()
    override func createUI() {
        super.createUI()
        addSubview(artWorksView)
        artWorksView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        addSubview(orgView)
        orgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(60)
            make.right.equalToSuperview().offset(-60)
            make.top.equalToSuperview().offset(60)
        }
        addSubview(emptyButton)
        emptyButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(emptyLabel.snp.bottom).offset(15)
            make.height.equalTo(40)
//            make.bottom.equalToSuperview()
        }

        _bindView()
        _loadData()
    }

    // MARK: UI

    lazy var artWorksView: MineArtworksView = {
        let view = MineArtworksView()
        view.isHidden = true
        return view
    }()

    lazy var orgView: MineOrgView = {
        let view = MineOrgView()
        view.isHidden = true
        return view
    }()

    lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "您不是平台入驻艺术家".localString
        label.font = .systemFont(ofSize: 13)
        label.textColor = ThemeColor.gray.color()
        return label
    }()

    lazy var emptyButton: DDButtonFixed = {
        let button = DDButtonFixed(imagePosition: .none)
        button.contentType = .contentFit(padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10), gap: 0)
        button.mTitleLabel.text = "Join the platform".localString
        button.mTitleLabel.font = .systemFont(ofSize: 13)
        button.mTitleLabel.textColor = ThemeColor.black.color()
        button.layer.borderColor = ThemeColor.black.color().cgColor
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 20
        return button
    }()
}

extension MineArtorOrgView {
    func _bindView() {
        _ = self.emptyButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.joinPlatformClick.accept(())
        })
    }

    func _loadData() {
        _ = DDUserTools.shared.userInfo.subscribe(onNext: {
            [weak self] userModel in
            guard let self = self else { return }
            if userModel.role.user_role == 1 {
                self.emptyLabel.isHidden = false
                self.emptyButton.isHidden = false
                self.artWorksView.isHidden = true
                self.orgView.isHidden = true
                self.emptyLabel.text = "您不是平台入驻艺术家".localString
                self.emptyButton.mTitleLabel.text = "Join the platform".localString
            } else if userModel.role.user_role == 2 {
                if userModel.role.user_role == 2 && userModel.role.status == 1 {
                    self.emptyLabel.isHidden = true
                    self.emptyButton.isHidden = true
                    self.artWorksView.isHidden = false
                    self.orgView.isHidden = true
                } else if userModel.role.status == 5 || userModel.role.status == 7 || userModel.role.status == 8 {
                    //审核拒绝
                    self.emptyLabel.isHidden = false
                    self.emptyButton.isHidden = false
                    self.artWorksView.isHidden = true
                    self.orgView.isHidden = true
                    self.emptyLabel.text = "Review failed, please re-submit.".localString
                    self.emptyButton.mTitleLabel.text = "Review".localString
                } else if userModel.role.status == 4 {
                    //审核拒绝
                    self.emptyLabel.isHidden = false
                    self.emptyButton.isHidden = false
                    self.artWorksView.isHidden = true
                    self.orgView.isHidden = true
                    self.emptyLabel.text = "You have completed personal information authentication and can continue to the artist application process.".localString
                    self.emptyButton.mTitleLabel.text = "Continue to apply".localString
                } else {
                    //等待审核
                    self.emptyLabel.isHidden = false
                    self.emptyButton.isHidden = false
                    self.artWorksView.isHidden = true
                    self.orgView.isHidden = true
                    self.emptyLabel.text = "Your artist profile has been submitted.\nThe verification process is expected to be completed within 3 business days.\nWe appreciate your patience.".localString
                    self.emptyButton.mTitleLabel.text = "View Details".localString
                }
                
            } else if userModel.role.user_role == 3 {
                self.emptyLabel.isHidden = true
                self.emptyButton.isHidden = true
                self.artWorksView.isHidden = true
                self.orgView.isHidden = false
            }
            reloadData()
        })
    }

    func reloadData() {
        if !self.artWorksView.isHidden {
            self.artWorksView.loadData()
        } else if(self.orgView.isHidden) {
            self.orgView.loadData()
        }
    }
}
