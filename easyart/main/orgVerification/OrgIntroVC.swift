//
//  OrgIntroVC.swift
//  easyart
//
//  Created by 崭新的旧刀 on 2026/3/26.
//

import UIKit

class OrgIntroVC: BaseVC {
    var profileModel = OrgProfileModel()
    var model: OrgIntroModel
    
    init(profileModel: OrgProfileModel, model: OrgIntroModel) {
        self.profileModel = profileModel
        self.model = model
        super.init()
    }
    
    @available(*, unavailable)
    @MainActor required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._bindView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self._reloadData()
    }
    
    override func createUI() {
        super.createUI()
        self.mSafeView.contentType = .flex
        
        self.mSafeView.addSubview(mNameTextFiled)
        mNameTextFiled.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.top.equalToSuperview().offset(30)
        }
        
        self.mSafeView.addSubview(mNameTipLabel)
        mNameTipLabel.snp.makeConstraints { make in
            make.left.right.equalTo(mNameTextFiled)
            make.top.equalTo(mNameTextFiled.snp.bottom).offset(10)
        }
        
        self.mSafeView.addSubview(mIntroTitleLabel)
        mIntroTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(mNameTipLabel)
            make.top.equalTo(mNameTipLabel.snp.bottom).offset(30)
        }
        
        self.mSafeView.addSubview(mNumberLabel)
        mNumberLabel.snp.makeConstraints { make in
            make.right.equalTo(mNameTextFiled)
            make.centerY.equalTo(mIntroTitleLabel)
        }
        
        self.mSafeView.addSubview(mIntroTipLabel)
        mIntroTipLabel.snp.makeConstraints { make in
            make.left.equalTo(mIntroTitleLabel)
            make.right.equalTo(mNumberLabel)
            make.top.equalTo(mIntroTitleLabel.snp.bottom).offset(10)
        }
        
        self.mSafeView.addSubview(mUnderlinedTextView)
        mUnderlinedTextView.snp.makeConstraints { make in
            make.left.right.equalTo(mNameTextFiled)
            make.top.equalTo(mIntroTipLabel.snp.bottom).offset(10)
            make.height.equalTo(500)
        }
        
        self.view.addSubview(mConfirmButton)
        mConfirmButton.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(50 + BottomSafeAreaHeight)
        }
    }
    
    // MARK: UI

    lazy var mNameTextFiled: OrgVerifField = .init(title: "Organization name *".localString)
    
    lazy var mNameTipLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Up to two modifications per calendar year".localString + " (0/2)"
        label.font = .systemFont(ofSize: 13)
        label.textColor = ThemeColor.gray.color()
        return label
    }()
    
    lazy var mIntroTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Organization Introduction​ *".localString
        label.font = .systemFont(ofSize: 13)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mNumberLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "0/2000"
        label.font = .systemFont(ofSize: 13)
        label.textColor = ThemeColor.gray.color()
        return label
    }()
    
    lazy var mIntroTipLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "The language you fill out will be displayed directly on your organization introduction​ page.".localString
        label.font = .systemFont(ofSize: 13)
        label.textColor = ThemeColor.gray.color()
        return label
    }()
    
    lazy var mUnderlinedTextView: UnderlinedTextView = {
        let view = UnderlinedTextView()
        view.font = .systemFont(ofSize: 14)
        view.textColor = ThemeColor.black.color()
        view.text = " Please enter"
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

extension OrgIntroVC {
    func _bindView() {
        _ = self.mUnderlinedTextView.rx.observe(CGSize.self, "contentSize").subscribe(onNext: { [weak self] (contentSize) in
            guard let self = self, let contentSize = contentSize else { return }
                self.mUnderlinedTextView.snp.updateConstraints { (make) in
                    make.height.equalTo(max(500, contentSize.height))
                }
        })
        
        _ = self.mNameTextFiled.mTextField.mTextField.rx.controlEvent(.editingDidEnd).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.model.name = self.mNameTextFiled.text ?? ""
            self._updateButton()
        })
        
        _ = self.mUnderlinedTextView.rx.text.skip(1).subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            self.model.intro = (text ?? "").dd.subString(rang: NSRange(location: 0, length: 2000))
            self.mNumberLabel.text = "\(self.model.intro.count)/2000"
            self._updateButton()
        })
        
        _ = self.mConfirmButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            //简介
            self._saveOrgProfile()
        })
        
        _ = DDUserTools.shared.userInfo.subscribe(onNext: { [weak self] userModel in
            guard let self = self else { return }
            self.mNameTipLabel.text = "Up to two modifications per calendar year".localString + " (\(userModel.userRoleDetail.use_update_num)/2)"
        })
        
    }
    
    func _saveOrgProfile(){
        let user = DDUserTools.shared.userInfo.value.userRoleDetail
        var url = "settled/submitSave"
        var data: [String: Any] = [
            "real_name": self.profileModel.name,
            "attestation": 2,
            "passport": self.profileModel.idFile.filename,
            "other_passport": self.profileModel.otherIDFile.filename,
            "phone": self.profileModel.mobile,
            "country_id": self.profileModel.country.id,
            "address": self.profileModel.address,
            "account_name": self.profileModel.bankInfo.name,
            "account_type": self.profileModel.bankInfo.bankType.id,
            "swift_code": self.profileModel.bankInfo.swiftCode,
            "account_number": self.profileModel.bankInfo.number,
            "name": self.model.name,
            "info": self.model.intro,
            "head": self.model.coverFile.filename,
            "id_number": self.profileModel.idNumber
        ]
        if user.is_over {
            url = "settled/updateShow"
            data["artist_id"] = DDUserTools.shared.userInfo.value.role.id
            data["free"] = "1"
        }
        _ = DDAPI.shared.request(url, data: data).subscribe(onSuccess: { [weak self] response in
            guard let self = self else { return }
            //更新信息
            _ = DDUserTools.shared.updateUserInfo(getRoleInfo: true).subscribe(onSuccess: { isUpdate in
                print("更新成功")
            })
            //返回
            if user.is_over {
                let click = SettleWarnPopView()
                _ = click.clickPublish.subscribe(onNext: { _ in
                    DDPopView.hide()
                    let vc = SettleInResultVC()
                    vc.status = SettleInResultStatus.process
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                })
                DDPopView.show(view: click)
            } else {
                let vc = SettleInResultVC()
                vc.status = SettleInResultStatus.process
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
    }
    
    func _reloadData() {
        self.mNameTextFiled.text = self.model.name
        self.mUnderlinedTextView.text = self.model.intro
        self.mNumberLabel.text = "\(self.model.intro.count)/2000"
        self._updateButton()
    }
    
    func _updateButton() {
        self.mConfirmButton.isEnabled = String.isAvailable(self.model.name) && String.isAvailable(self.model.intro)
    }
}
