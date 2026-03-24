//
//  OrgVerifIDCardVC.swift
//  easyart
//
//  Created by 崭新的旧刀 on 2026/3/24.
//

//
//  SettleInIDCardVC.swift
//  easyart
//
//  Created by Damon on 2024/12/17.
//

import UIKit
import ZLPhotoBrowser
import SwiftyJSON
import HDHUD
import DDLoggerSwift

class OrgVerifIDCardVC: BaseVC {
    var model: OrgProfileModel
    
    init(model: OrgProfileModel) {
        self.model = model
        defer {
            self.imageUrl = self.model.idFile.fileurl
            self.otherImageUrl = self.model.otherIDFile.fileurl
            
        }
        super.init(bottomPadding: 100)
    }
    
    @MainActor required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var imageUrl: String? {
        didSet {
            self.mOrgUpdateIDCoverView.imageUrl = imageUrl
            self.mConfirmButton.isEnabled = String.isAvailable(imageUrl)
        }
    }
    
    var otherImageUrl: String? {
        didSet {
            self.mOrgUpdateOtherCoverView.imageUrl = otherImageUrl
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._bindView()
    }
    
    override func createUI() {
        super.createUI()
        self.mSafeView.contentType = .flex
        
        self.mSafeView.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(35)
            make.right.equalToSuperview().offset(-35)
            make.top.equalToSuperview().offset(35)
        }
        
        self.mSafeView.addSubview(mOrgUpdateIDCoverView)
        mOrgUpdateIDCoverView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mTitleLabel.snp.bottom).offset(10)
            make.left.right.equalTo(mTitleLabel)
            make.height.equalTo(250)
        }
        
        self.mSafeView.addSubview(mTitleLabel2)
        mTitleLabel2.snp.makeConstraints { make in
            make.left.right.equalTo(mTitleLabel)
            make.top.equalTo(mOrgUpdateIDCoverView.snp.bottom).offset(20)
        }
        
        self.mSafeView.addSubview(mOrgUpdateOtherCoverView)
        mOrgUpdateOtherCoverView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mTitleLabel2.snp.bottom).offset(10)
            make.width.height.equalTo(mOrgUpdateIDCoverView)
        }
        
        self.view.addSubview(mConfirmButton)
        mConfirmButton.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(50 + BottomSafeAreaHeight)
        }
    }
    
    //MARK: UI
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        let attributedText = NSMutableAttributedString(string: "Personal ID * ", attributes: [NSAttributedString.Key.foregroundColor : ThemeColor.black.color()])
        attributedText.append(NSAttributedString(string: "(e.g. ID card, Driver's license, etc.)", attributes: [NSAttributedString.Key.foregroundColor : ThemeColor.lightGray.color()]))
        label.attributedText = attributedText
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    lazy var mOrgUpdateIDCoverView: OrgUpdateIDCoverView = {
        let view = OrgUpdateIDCoverView()
        view.mTitleLabel.text = "Please upload your Personal ID document".localString
        view.mTitleLabel.textColor = ThemeColor.lightGray.color()
        return view
    }()
    
    lazy var mTitleLabel2: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        let attributedText = NSMutableAttributedString(string: "Other ", attributes: [NSAttributedString.Key.foregroundColor : ThemeColor.black.color()])
        attributedText.append(NSAttributedString(string: "(Optional)", attributes: [NSAttributedString.Key.foregroundColor : ThemeColor.lightGray.color()]))
        label.attributedText = attributedText
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    lazy var mOrgUpdateOtherCoverView: OrgUpdateIDCoverView = {
        let view = OrgUpdateIDCoverView()
        view.mTitleLabel.text = "Please upload your other ID documents".localString
        view.mTitleLabel.textColor = ThemeColor.lightGray.color()
        return view
    }()

    lazy var mConfirmButton: UIButton = {
        let tButton = UIButton(type: .custom)
        tButton.setBackgroundImage(UIImage.dd.getImage(color: ThemeColor.black.color()), for: .normal)
        tButton.setBackgroundImage(UIImage.dd.getImage(color: ThemeColor.gray.color()), for: .disabled)
        tButton.titleLabel?.font = .systemFont(ofSize: 14)
        tButton.setTitleColor(UIColor.dd.color(hexValue: 0xffffff), for: .normal)
        tButton.setTitle("Submit".localString, for: .normal)
        tButton.isEnabled = false
        return tButton
    }()
}

extension OrgVerifIDCardVC {
    func _bindView() {
        let tap = UITapGestureRecognizer()
        _ = tap.rx.event.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            ZLPhotoConfiguration.default().allowSelectVideo = false
            ZLPhotoConfiguration.default().maxSelectCount = 1
            let ps = ZLPhotoPicker()
            ps.selectImageBlock = { results, isOriginal in
                printLog("res", results.count)
                // your code
                if let image = results.first?.image.pngData() {
                    HDHUD.show(icon: .loading, duration: -1)
                    _ = DDAPI.shared.upload("settled/uploadCard", params: [:], data: image).subscribe(onNext: { response in
                        HDHUD.hide()
                        let json = JSON(response.data)
                        self.imageUrl = json["fileurl"].stringValue
                        self.model.idFile.fileurl = json["fileurl"].stringValue
                        self.model.idFile.filename = json["filename"].stringValue
                    }, onError: { _ in
                        HDHUD.hide()
                    })
                }
            }
            ps.showPhotoLibrary(sender: self)
        })
        self.mOrgUpdateIDCoverView.addGestureRecognizer(tap)
        
        
        let tap2 = UITapGestureRecognizer()
        _ = tap2.rx.event.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            ZLPhotoConfiguration.default().allowSelectVideo = false
            ZLPhotoConfiguration.default().maxSelectCount = 1
            let ps = ZLPhotoPicker()
            ps.selectImageBlock = { results, isOriginal in
                printLog("res", results.count)
                // your code
                if let image = results.first?.image.pngData() {
                    HDHUD.show(icon: .loading, duration: -1)
                    _ = DDAPI.shared.upload("settled/uploadCard", params: [:], data: image).subscribe(onNext: { response in
                        HDHUD.hide()
                        let json = JSON(response.data)
                        self.otherImageUrl = json["fileurl"].stringValue
                        self.model.otherIDFile.fileurl = json["fileurl"].stringValue
                        self.model.otherIDFile.filename = json["filename"].stringValue
                    }, onError: { _ in
                        HDHUD.hide()
                    })
                }
            }
            ps.showPhotoLibrary(sender: self)
        })
        self.mOrgUpdateOtherCoverView.addGestureRecognizer(tap2)
        
        //确定
        _ = self.mConfirmButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    
}
