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
    
    /// 👇 只加这一句
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
        
        self.addSubview(self.mArtistTipView)
        self.mArtistTipView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.mListTitleLabel.snp.bottom).offset(40)
            make.height.lessThanOrEqualTo(400)
        }
        
        self.addSubview(self.mCollectionView)
        self.mCollectionView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(self.mArtistTipView.snp.bottom).offset(20)
            make.bottom.equalToSuperview()
            make.height.equalTo(200)
        }
        
        self._bindView()
//        self.loadData()
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
    
    lazy var mArtistTipView: MineArtistTipView = .init()
    
    lazy var mCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.itemSize = CGSize(width: (UIScreenWidth - 48) / 2, height: (UIScreenWidth - 48) / 2 + 70)
        let tCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        tCollection.allowsMultipleSelection = false
        tCollection.showsVerticalScrollIndicator = false
        tCollection.backgroundColor = UIColor.clear
        tCollection.delegate = self
        tCollection.dataSource = self
        tCollection.register(ArtistCollectionViewCell.self, forCellWithReuseIdentifier: "MineArtistCollectionViewCell")
        return tCollection
    }()
}

extension MineArtworksView {
    func _bindView() {
        // 简介展开收回手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapIntro))
        self.mIntroLabel.addGestureRecognizer(tap)
        
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
        
        _ = self.mCollectionView.rx.observe(CGSize.self, "contentSize").subscribe(onNext: { [weak self] contentSize in
            guard let self = self, let contentSize = contentSize else { return }
            self.mCollectionView.snp.updateConstraints { make in
                make.height.equalTo(max(300, contentSize.height + 100))
            }
        })
        // 编辑
        _ = self.mEditButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            // TODO: 编辑
            let model = DDUserTools.shared.userInfo.value.userRoleDetail
            let profileModel = SettleInProfileModel()
            profileModel.update(model: model)
            let authorModel = SettleInAuthorModel()
            authorModel.update(model: model)
            let vc = SettleInUpdateCoverVC(profileModel: profileModel, model: authorModel)
            vc.hidesBottomBarWhenPushed = true
            DDUtils.shared.getCurrentVC()?.navigationController?.pushViewController(vc, animated: true)
        })
        
        _ = self.mSortButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let vc = ArtistSortVC()
            vc.hidesBottomBarWhenPushed = true
            DDUtils.shared.getCurrentVC()?.navigationController?.pushViewController(vc, animated: true)
        })
        
        // 头像
        let avatarTap = UITapGestureRecognizer()
        _ = avatarTap.rx.event.subscribe(onNext: { [weak self] _ in
            guard let self = self, let vc = DDUtils.shared.getCurrentVC() else { return }
            // 上传头像
            ZLPhotoConfiguration.default().allowSelectVideo = false
            ZLPhotoConfiguration.default().maxSelectCount = 1
            let ps = ZLPhotoPicker()
            ps.selectImageBlock = { results, _ in
                // your code
                if let image = results.first?.image.pngData() {
                    HDHUD.show(icon: .loading, duration: -1)
                    _ = DDAPI.shared.upload("settled/uploadCard", params: [:], data: image).subscribe(onNext: { response in
                        HDHUD.hide()
                        let json = JSON(response.data)
                        self._saveSettled(fileName: json["filename"].stringValue)
                    }, onError: { _ in
                        HDHUD.hide()
                    })
                }
            }
            ps.showPhotoLibrary(sender: vc)
        })
        self.mImageView.addGestureRecognizer(avatarTap)
    }
    
    ///  修改头像
    func _saveSettled(fileName: String) {
        var url = "settled/submitSave"
        var data: [String: Any] = [
            "real_name": self.profileModel.name,
            "attestation": 2,
            "passport": self.profileModel.IDFile.filename,
            "other_passport": self.profileModel.otherIDFile.filename,
            "phone": self.profileModel.mobile,
            "country_id": self.profileModel.country.id,
            "address": self.profileModel.address,
            "account_name": self.profileModel.bankInfo.name,
            "account_type": self.profileModel.bankInfo.bankType.id,
            "swift_code": self.profileModel.bankInfo.swiftCode,
            "account_number": self.profileModel.bankInfo.number,
            "name": self.authorModel.name,
            "info": self.authorModel.intro,
            "head": fileName,
            "id_number": self.profileModel.IDNumber
        ]
        if DDUserTools.shared.userInfo.value.userRoleDetail.is_over {
            url = "settled/updateShow"
            data["artist_id"] = DDUserTools.shared.userInfo.value.role.id
            data["free"] = "1"
        }
        _ = DDAPI.shared.request(url, data: data).subscribe(onSuccess: { _ in
            let click = SettleWarnPopView()
            _ = click.clickPublish.subscribe(onNext: { _ in
                DDPopView.hide()
            })
            DDPopView.show(view: click)
        })
    }

    /// 点击展开/收起
    @objc private func didTapIntro() {
        self.isIntroExpanded.toggle()
        self.updateIntroLabel()
    }
    
    /// 👇 公共方法：统一刷新简介
    private func updateIntroLabel() {
        let fullText = self.authorModel.intro
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.3
        paragraphStyle.lineBreakMode = .byTruncatingTail
        
        if self.isIntroExpanded {
            // 展开
            self.mIntroLabel.attributedText = NSAttributedString(
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
                self.mIntroLabel.attributedText = attr
            } else {
                self.mIntroLabel.attributedText = NSAttributedString(
                    string: fullText,
                    attributes: [.paragraphStyle: paragraphStyle]
                )
            }
        }
    }

    func loadData() {
        if DDUserTools.shared.userInfo.value.role.user_role == 1 || DDUserTools.shared.userInfo.value.role.status != 1 {
            self.list = [nil]
            self.mCollectionView.reloadData()
        } else {
            _ = DDAPI.shared.request("settled/goodsList", data: ["page_type": 0]).subscribe(onSuccess: { [weak self] response in
                guard let self = self else { return }
                let data = JSON(response.data)
                let goodsList = (data["goods_list"].arrayObject as? [[String: Any]]) ?? []
                let list = goodsList.kj.modelArray(MeArtistModel.self)
                self.list = [nil]
                self.list.append(contentsOf: list)
                if self.list.count > 1 {
                    self.mArtistTipView.isHidden = true
                    self.mArtistTipView.snp.updateConstraints { make in
                        make.top.equalTo(self.mListTitleLabel.snp.bottom).offset(0)
                        make.height.lessThanOrEqualTo(1)
                    }
                } else {
                    self.mArtistTipView.isHidden = false
                    self.mArtistTipView.snp.updateConstraints { make in
                        make.top.equalTo(self.mListTitleLabel.snp.bottom).offset(40)
                        make.height.lessThanOrEqualTo(400)
                    }
                }
                self.mCollectionView.reloadData()
            })
        }
    }
}

extension MineArtworksView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = self.list[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MineArtistCollectionViewCell", for: indexPath) as! ArtistCollectionViewCell
        cell.updateUI(model: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            // 跳转添加作品
            let vc = ArtistEditPublishTipsVC(bottomPadding: 150)
            vc.hidesBottomBarWhenPushed = true
            DDUtils.shared.getCurrentVC()?.navigationController?.pushViewController(vc, animated: true)
        } else {
            let model = self.list[indexPath.item]
            let vc = DetailVC(goodsID: "\(model!.id)")
            vc.isOwner = true
            vc.hidesBottomBarWhenPushed = true
            DDUtils.shared.getCurrentVC()?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
