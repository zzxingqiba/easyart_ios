//
//  OrgVerificationVC.swift
//  easyart
//
//  Created by 崭新的旧刀 on 2026/3/24.
//

import HDHUD
import RxRelay
import SwiftyJSON
import UIKit

class OrgVerifVC: BaseVC {
    var profileModel = OrgProfileModel()
    private var countryList = [AddressCountryInfo]()
    private var isEdit = false

    var isPreviewMode = false

    convenience init(isEdit: Bool) {
        self.init()
        self.isEdit = isEdit
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        _bindView()
        _loadData()
        _loadCountry()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _reloadData()
    }

    override func createUI() {
        super.createUI()
        mSafeView.contentType = .flex

        mSafeView.addSubview(mOrgNameTextField)
        mOrgNameTextField.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }

        mSafeView.addSubview(mOrgIDCardTextField)
        mOrgIDCardTextField.snp.makeConstraints { make in
            make.top.equalTo(mOrgNameTextField.snp.bottom)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }

        mSafeView.addSubview(mOrgIDSelectCell)
        mOrgIDSelectCell.snp.makeConstraints { make in
            make.top.equalTo(mOrgIDCardTextField.snp.bottom)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }

        mSafeView.addSubview(mOrgPhoneTextField)
        mOrgPhoneTextField.snp.makeConstraints { make in
            make.top.equalTo(mOrgIDSelectCell.snp.bottom)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }

        mSafeView.addSubview(mOrgCountrySelectCell)
        mOrgCountrySelectCell.snp.makeConstraints { make in
            make.top.equalTo(mOrgPhoneTextField.snp.bottom)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }

        mSafeView.addSubview(mOrgAddressTextView)
        mOrgAddressTextView.snp.makeConstraints { make in
            make.top.equalTo(mOrgCountrySelectCell.snp.bottom)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        self.mSafeView.addSubview(mOrgBankSelectCell)
        mOrgBankSelectCell.snp.makeConstraints { make in
            make.top.equalTo(mOrgAddressTextView.snp.bottom)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        self.mSafeView.addSubview(mTipLabel)
        mTipLabel.snp.makeConstraints { make in
            make.top.equalTo(mOrgBankSelectCell.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        self.view.addSubview(mConfirmButton)
        mConfirmButton.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(50 + BottomSafeAreaHeight)
        }
        
        self.view.addSubview(mCancelButton)
        mCancelButton.snp.makeConstraints { make in
            make.right.equalTo(self.view.snp.centerX)
            make.left.bottom.equalToSuperview()
            make.height.equalTo(50 + BottomSafeAreaHeight)
        }
        
        self.view.addSubview(mSaveButton)
        mSaveButton.snp.makeConstraints { make in
            make.left.equalTo(self.view.snp.centerX)
            make.right.bottom.equalToSuperview()
            make.height.equalTo(50 + BottomSafeAreaHeight)
        }
    }

    // MARK: UI

    lazy var mOrgNameTextField: OrgVerifField = .init(title: "机构法人姓名 *".localString)

    lazy var mOrgIDCardTextField: OrgVerifField = .init(title: "法人身份证号 *".localString)

    lazy var mOrgIDSelectCell: OrgVerifSelectCell = {
        let view = OrgVerifSelectCell(title: "Personal ID *".localString)
        view.mDesLabel.text = "Upload".localString
        return view
    }()

    lazy var mOrgPhoneTextField: OrgVerifField = {
        let view = OrgVerifField(title: "Phone *".localString)
        view.setupAsMobileField(countryCode: "+86")
        return view
    }()

    lazy var mOrgCountrySelectCell: OrgVerifSelectCell = {
        let view = OrgVerifSelectCell(title: "Country *".localString)
        view.mDesLabel.text = "Choose".localString
        return view
    }()

    lazy var mOrgAddressTextView: OrgVerifTextView = .init(title: "Address *".localString)
    
    lazy var mOrgBankSelectCell:OrgVerifSelectCell = {
        let view = OrgVerifSelectCell(title: "")
        let attributed = NSMutableAttributedString(string: "Bank account *".localString)
        let desAttributed = NSAttributedString(string: "\n" + "For receiving payments only".localString, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 11), .foregroundColor: ThemeColor.textPlaceholder.color()])
        attributed.append(desAttributed)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.1
        paragraphStyle.alignment = .left
        attributed.addAttributes([NSAttributedString.Key.paragraphStyle : paragraphStyle], range: NSRange(location: 0, length: attributed.length))
        view.mTitleLabel.attributedText = attributed
        view.mDesLabel.text = nil
        return view
    }()
    

    lazy var mTipLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.numberOfLines = 0
        let attributed = NSMutableAttributedString(string: "All personal information furnished shall be processed in strict compliance with the ".localString)
        let link = NSAttributedString(string: "Privacy Policy".localString, attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, .underlineColor: ThemeColor.main.color()])
        attributed.append(link)
        label.attributedText = attributed
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.main.color()
        return label
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
    
    lazy var mCancelButton: UIButton = {
        let tButton = UIButton(type: .custom)
        tButton.isHidden = true
        tButton.setBackgroundImage(UIImage.dd.getImage(color: ThemeColor.white.color()), for: .normal)
        tButton.setBackgroundImage(UIImage.dd.getImage(color: ThemeColor.gray.color()), for: .disabled)
        tButton.titleLabel?.font = .systemFont(ofSize: 14)
        tButton.setTitleColor(ThemeColor.black.color(), for: .normal)
        tButton.setTitle("Cancel".localString, for: .normal)
        let line = UIView()
        line.backgroundColor = ThemeColor.black.color()
        tButton.addSubview(line)
        line.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(1)
        }
        return tButton
    }()
    
    lazy var mSaveButton: UIButton = {
        let tButton = UIButton(type: .custom)
        tButton.isHidden = true
        tButton.setBackgroundImage(UIImage.dd.getImage(color: ThemeColor.black.color()), for: .normal)
        tButton.setBackgroundImage(UIImage.dd.getImage(color: ThemeColor.gray.color()), for: .disabled)
        tButton.titleLabel?.font = .systemFont(ofSize: 14)
        tButton.setTitleColor(UIColor.dd.color(hexValue: 0xffffff), for: .normal)
        tButton.setTitle("Submit".localString, for: .normal)
        return tButton
    }()
}

extension OrgVerifVC {
    func _reloadData() {
        mOrgNameTextField.text = profileModel.name
        mOrgIDCardTextField.text = profileModel.idNumber
        if String.isAvailable(profileModel.idFile.filename) {
            mOrgIDSelectCell.mDesLabel.textColor = isPreviewMode ? ThemeColor.lightGray.color() : ThemeColor.black.color()
            mOrgIDSelectCell.text = profileModel.idFile.filename
        }
        // 手机号
        mOrgPhoneTextField.setupAsMobileField(countryCode: profileModel.country.phone_code)
        if String.isAvailable(profileModel.mobile) {
            mOrgPhoneTextField.text = profileModel.mobile
        }
        mOrgCountrySelectCell.text = profileModel.country.name
        if String.isAvailable(profileModel.country.name) {
            mOrgCountrySelectCell.mDesLabel.textColor = isPreviewMode ? ThemeColor.lightGray.color() : ThemeColor.black.color()
        }
        mOrgAddressTextView.text = profileModel.address

        _updateButton()
    }

    func _updateButton() {
        self.mConfirmButton.isEnabled = self.profileModel.isAvailable() || self.isPreviewMode
    }

    func _bindView() {
        _ = mOrgNameTextField.mTextField.mTextField.rx.controlEvent(.editingDidEnd).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.profileModel.name = self.mOrgNameTextField.mTextField.mTextField.text ?? ""
            self._updateButton()
        })
        
        _ = mOrgIDCardTextField.mTextField.mTextField.rx.controlEvent(.editingDidEnd).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.profileModel.idNumber = self.mOrgIDCardTextField.mTextField.mTextField.text ?? ""
            self._updateButton()
        })

        _ = mOrgIDSelectCell.clickPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self, self.isPreviewMode == false else { return }
            let vc = OrgVerifIDCardVC(model: self.profileModel)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        })

        _ = mOrgPhoneTextField.mTextField.mTextField.rx.controlEvent(.editingDidEnd).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.profileModel.mobile = self.mOrgPhoneTextField.mTextField.mTextField.text ?? ""
            self._updateButton()
        })

        _ = mOrgCountrySelectCell.clickPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self, self.isPreviewMode == false else { return }
            // 弹窗
            let pop = DDAddressCountryListPop()
            pop.list = self.countryList
            _ = pop.clickPublish.subscribe(onNext: { [weak self] clickInfo in
                DDPopView.hide()
                guard let self = self else { return }
                if clickInfo.clickType == .confirm, let country = clickInfo.info as? AddressCountryInfo {
                    self.profileModel.country = country
                    self._reloadData()
                }
            })
            DDPopView.show(view: pop, animationType: .bottom)
        })
        
        _ = self.mOrgAddressTextView.mTextView.mTextView.rx.text.skip(1).subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            self.profileModel.address = text ?? ""
            self._updateButton()
        })
        
        _ = self.mOrgBankSelectCell.clickPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let vc = OrgBankInfoVC(model: self.profileModel)
            vc.isPreviewMode = self.isPreviewMode
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        })

        let tap = UITapGestureRecognizer()
        _ = tap.rx.event.subscribe(onNext: { _ in
            UIApplication.shared.open(URL(string: "https://www.easyartonline.com/agreement")!)
        })
        mTipLabel.addGestureRecognizer(tap)
        
        //确定
        _ = self.mConfirmButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            if self.isPreviewMode {
                self.isPreviewMode = false
                self.mConfirmButton.isHidden = true
                self.mCancelButton.isHidden = false
                self.mSaveButton.isHidden = false
            } else {
                self._saveInfo()
            }
        })
        
        _ = self.mSaveButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self._saveInfo()
        })
        
        _ = self.mCancelButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.isPreviewMode = true
            self.mConfirmButton.isHidden = false
            self.mCancelButton.isHidden = true
            self.mSaveButton.isHidden = true
            let userModel = DDUserTools.shared.userInfo.value
            self.profileModel.update(model: userModel.userRoleDetail)
            self._reloadData()
        })
    }
    
    
    func _saveInfo() {
        if self.isEdit {
            //保存信息
            self._editInfo()
        } else {
            //弹窗用户协议
            let vc = OrgAgreementVC(profileModel: self.profileModel)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func _editInfo() {
        let user = DDUserTools.shared.userInfo.value.userRoleDetail
        let url = "settled/submitSave"
        let data: [String: Any] = [
            "is_only_edit": 1,
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
            "name": user.name,
            "info": user.intro,
            "head": user.imgUrl.filename,
            "id_number": self.profileModel.idNumber
        ]
        _ = DDAPI.shared.request(url, data: data).subscribe(onSuccess: { [weak self] response in
            guard let self = self else { return }
            //更新信息
            _ = DDUserTools.shared.updateUserInfo(getRoleInfo: true).subscribe(onSuccess: { isUpdate in
                print("更新成功")
            })
            self.navigationController?.popToRootViewController(animated: true)
        })
    }

    func _loadData() {
//        let userModel = DDUserTools.shared.userInfo.value
//        //审核被拒绝，编辑更新重新审核
//        if userModel.role.status == 7 {
//            self.profileModel.update(model: userModel.userRoleDetail)
//            self._reloadData()
//        }
    }

    func _loadCountry() {
        _ = DDAPI.shared.request("config/countryList").subscribe(onSuccess: { [weak self] response in
            guard let self = self else { return }
            let data = JSON(response.data)
            if let list = data["country_list"].arrayObject as? [[String: Any]] {
                self.countryList = list.kj.modelArray(AddressCountryInfo.self)
                if self.profileModel.country.id.isEmpty, let country = self.countryList.first {
                    self.profileModel.country = country
                    self._reloadData()
                }
            }
        })
    }
}
