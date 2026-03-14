//
//  MeArtworksInfoView.swift
//  easyart
//
//  Created by Damon on 2025/1/7.
//

import UIKit
import DDUtils
import RxRelay
import ZLPhotoBrowser
import HDHUD
import SwiftyJSON

class MeArtworksInfoView: DDView {
    let clickPublish = PublishRelay<Void>()
    private var authorModel = SettleInAuthorModel()
    private var profileModel = SettleInProfileModel()
    
    private var list = [MeArtistModel?]()
    
    override func createUI() {
        super.createUI()
        
        self.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        self.addSubview(mEditButton)
        mEditButton.snp.makeConstraints { make in
            make.centerY.equalTo(mTitleLabel)
            make.right.equalToSuperview()
            make.height.equalTo(23)
        }
        
        self.addSubview(mImageView)
        mImageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(mTitleLabel.snp.bottom).offset(22)
            make.width.height.equalTo(50)
        }
        
        self.addSubview(mAddImageView)
        mAddImageView.snp.makeConstraints { make in
            make.right.top.equalTo(mImageView)
            make.width.height.equalTo(14)
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
        }
        
        self.addSubview(mListTitleLabel)
        mListTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(mIntroLabel.snp.bottom).offset(25)
        }
        
        self.addSubview(mSortButton)
        mSortButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalTo(mListTitleLabel)
            make.height.equalTo(23)
        }
        
        self.addSubview(mMeArtistTipView)
        mMeArtistTipView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(mListTitleLabel.snp.bottom).offset(20)
            make.height.lessThanOrEqualTo(400)
        }
        
        self.addSubview(mCollectionView)
        mCollectionView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(mMeArtistTipView.snp.bottom).offset(20)
            make.bottom.equalToSuperview()
            make.height.equalTo(200)
        }
        
        self._bindView()
        self.loadData()
    }
    
    //MARK: UI
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Artist profile".localString
        label.font = .systemFont(ofSize: 15)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mEditButton: DDButton = {
        let button = DDButton(imagePosition: .none)
        button.contentType = .contentFit(padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0), gap: 0)
        button.mTitleLabel.attributedText = NSAttributedString(string: "Edit".localString, attributes: [NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue, .underlineColor: ThemeColor.black.color()])
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
    
    lazy var mAddImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "icon-add-me"))
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
    
    lazy var mListTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Artworks".localString
        label.font = .systemFont(ofSize: 15)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mSortButton: DDButton = {
        let button = DDButton(imagePosition: .none)
        button.contentType = .contentFit(padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0), gap: 0)
        button.mTitleLabel.attributedText = NSAttributedString(string: "Sort".localString, attributes: [NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue, .underlineColor: ThemeColor.black.color()])
        button.mTitleLabel.font = .systemFont(ofSize: 13)
        button.mTitleLabel.textColor = ThemeColor.black.color()
        return button
    }()
    
    lazy var mMeArtistTipView: MeArtistTipView = {
        let view = MeArtistTipView()
        return view
    }()
    
    //
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
        tCollection.register(ArtistCollectionViewCell.self, forCellWithReuseIdentifier: "ArtistCollectionViewCell")
        return tCollection
    }()
}

extension MeArtworksInfoView {
    func _bindView() {
        let tap = UITapGestureRecognizer()
        _ = tap.rx.event.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 1.3
            self.mIntroLabel.attributedText = NSAttributedString(string: DDUserTools.shared.userInfo.value.userRoleDetail.intro, attributes: [NSAttributedString.Key.paragraphStyle : paragraphStyle])
        })
        self.mIntroLabel.addGestureRecognizer(tap)
        
        //
        _ = self.mCollectionView.rx.observe(CGSize.self, "contentSize").subscribe(onNext: { [weak self] (contentSize) in
            guard let self = self, let contentSize = contentSize else { return }
                self.mCollectionView.snp.updateConstraints { (make) in
                    make.height.equalTo(max(300, contentSize.height + 100))
                }
        })
        
        //编辑
        _ = self.mEditButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            //TODO: 编辑
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
        
        //头像
        let avatarTap = UITapGestureRecognizer()
        _ = avatarTap.rx.event.subscribe(onNext: { [weak self] _ in
            guard let self = self, let vc = DDUtils.shared.getCurrentVC() else { return }
            //上传头像
            ZLPhotoConfiguration.default().allowSelectVideo = false
            ZLPhotoConfiguration.default().maxSelectCount = 1
            let ps = ZLPhotoPicker()
            ps.selectImageBlock = { results, isOriginal in
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
        mImageView.addGestureRecognizer(avatarTap)
    }
    
//    修改头像
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
        _ = DDAPI.shared.request(url, data: data).subscribe(onSuccess: { response in
            let click = SettleWarnPopView()
            _ = click.clickPublish.subscribe(onNext: { _ in
                DDPopView.hide()
            })
            DDPopView.show(view: click)
        })
    }
    
    func loadData() {
        _ = DDUserTools.shared.userInfo.subscribe(onNext: { [weak self] userModel in
            guard let self = self else { return }
            self.authorModel.update(model: userModel.userRoleDetail)
            self.profileModel.update(model: userModel.userRoleDetail)
            //更新
            self.mImageView.kf.setImage(with: URL(string: self.authorModel.coverFile.fileurl))
            self.mNameLabel.text = self.authorModel.name
            self.mCityLabel.text = userModel.userRoleDetail.country_name
            var info = userModel.userRoleDetail.intro
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
        })
        
        //商品列表
        if DDUserTools.shared.userInfo.value.role.user_role == 1 || DDUserTools.shared.userInfo.value.role.status != 1  {
            self.list = [nil]
            self.mCollectionView.reloadData()
        } else {
            _ = DDAPI.shared.request("settled/goodsList", data: ["page_type": 0]).subscribe(onSuccess: {  [weak self] response in
                guard let self = self else { return }
                let data = JSON(response.data)
                let goodsList = (data["goods_list"].arrayObject as? [[String: Any]]) ?? []
                let list =  goodsList.kj.modelArray(MeArtistModel.self)
                self.list = [nil]
                self.list.append(contentsOf: list)
                if self.list.count > 1 {
                    self.mMeArtistTipView.isHidden = true
                    self.mMeArtistTipView.snp.updateConstraints { make in
                        make.height.lessThanOrEqualTo(1)
                    }
                } else {
                    self.mMeArtistTipView.isHidden = false
                    self.mMeArtistTipView.snp.updateConstraints { make in
                        make.height.lessThanOrEqualTo(400)
                    }
                }
                self.mCollectionView.reloadData()
            })
        }
    }
}

extension MeArtworksInfoView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = list[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArtistCollectionViewCell", for: indexPath) as! ArtistCollectionViewCell
        cell.updateUI(model: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            //跳转添加作品
            let vc = ArtistEditPublishTipsVC(bottomPadding: 150)
            vc.hidesBottomBarWhenPushed = true
            DDUtils.shared.getCurrentVC()?.navigationController?.pushViewController(vc, animated: true)
        } else {
            let model = list[indexPath.item]
            let vc = DetailVC(goodsID: "\(model!.id)")
            vc.isOwner = true
            vc.hidesBottomBarWhenPushed = true
            DDUtils.shared.getCurrentVC()?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
