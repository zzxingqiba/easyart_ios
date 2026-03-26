//
//  OrgUpdateCoverVC.swift
//  easyart
//
//  Created by 崭新的旧刀 on 2026/3/26.
//

import UIKit
import ZLPhotoBrowser
import SwiftyJSON
import HDHUD

class OrgUpdateCoverVC: BaseVC{
    var profileModel = OrgProfileModel()
    var model: OrgIntroModel
    
    init(profileModel: OrgProfileModel, model: OrgIntroModel) {
        self.profileModel = profileModel
        self.model = model
        defer {
            self.imageUrl = self.model.coverFile.fileurl
        }
        super.init()
    }
    
    @MainActor required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var imageUrl: String? {
        didSet {
            self.mOrgUpdateCoverView.imageUrl = imageUrl
            self.mConfirmButton.isEnabled = String.isAvailable(imageUrl)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._bindView()
    }
    
    override func createUI() {
        super.createUI()
        self.mSafeView.contentType = .flex
        self.mSafeView.addSubview(mOrgUpdateCoverView)
        mOrgUpdateCoverView.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(50)
            make.width.height.equalTo(192)
        }
        self.mSafeView.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(45)
            make.right.equalToSuperview().offset(-45)
            make.top.equalTo(mOrgUpdateCoverView.snp.bottom).offset(35)
        }
        
        self.view.addSubview(mConfirmButton)
        mConfirmButton.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(50 + BottomSafeAreaHeight)
        }
    }
    
    //MARK: UI
    lazy var mOrgUpdateCoverView:OrgUpdateCoverView = .init()
    
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "This image will be used as the background image for your personal homepage. It is recommended to choose your most representative artwork image.\n\nThe artist's image display size is 750x750px. It is recommended to use a square image that meets the display resolution requirements and has a capacity of<2mb (no-square images will be automatically cropped by the system).".localString
        label.font = .systemFont(ofSize: 13)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mConfirmButton: UIButton = {
        let tButton = UIButton(type: .custom)
        tButton.setBackgroundImage(UIImage.dd.getImage(color: ThemeColor.black.color()), for: .normal)
        tButton.setBackgroundImage(UIImage.dd.getImage(color: ThemeColor.gray.color()), for: .disabled)
        tButton.titleLabel?.font = .systemFont(ofSize: 14)
        tButton.setTitleColor(UIColor.dd.color(hexValue: 0xffffff), for: .normal)
        tButton.setTitle("Next step".localString, for: .normal)
        tButton.isEnabled = false
        return tButton
    }()
}

extension OrgUpdateCoverVC {
    func _bindView(){
        let tap = UITapGestureRecognizer()
        _ = tap.rx.event.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            ZLPhotoConfiguration.default().allowSelectVideo = false
            ZLPhotoConfiguration.default().maxSelectCount = 1
            let ps = ZLPhotoPicker()
            ps.selectImageBlock = { results, isOriginal in
                // your code
                if let image = results.first?.image.pngData() {
                    HDHUD.show(icon: .loading, duration: -1)
                    _ = DDAPI.shared.upload("settled/uploadPhoto", params: [:], data: image).subscribe(onNext: { response in
                        HDHUD.hide()
                        let json = JSON(response.data)
                        self.imageUrl = json["fileurl"].stringValue
                        self.model.coverFile.fileurl = json["fileurl"].stringValue
                        self.model.coverFile.filename = json["filename"].stringValue
                    }, onError: { _ in
                        HDHUD.hide()
                    })
                }
            }
            ps.showPhotoLibrary(sender: self)
        })
        self.mOrgUpdateCoverView.addGestureRecognizer(tap)
        
        //确定
        _ = self.mConfirmButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            //简介
            let vc = OrgIntroVC(profileModel: self.profileModel, model: self.model)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        })
    }
}
