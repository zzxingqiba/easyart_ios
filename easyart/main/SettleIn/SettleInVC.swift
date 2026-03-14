//
//  SettleInVC.swift
//  easyart
//
//  Created by Damon on 2024/12/16.
//

import UIKit
import HDHUD
import RxRelay
import SwiftyJSON

class SettleInVC: BaseVC {
    var profileModel = SettleInProfileModel()
    private var countryList = [AddressCountryInfo]()
    //修改编辑基本资料，无需审核
    private var isEdit = false
    
    var isPreviewMode = false {
        didSet {
            mNameSettleInTextField.mTextField.mTextField.isEnabled = !isPreviewMode
            mNameSettleInTextField.mTextField.mTextField.textColor = isPreviewMode ? ThemeColor.lightGray.color() : ThemeColor.black.color()
            
            mIDCardSettleInTextField.mTextField.mTextField.isEnabled = !isPreviewMode
            mIDCardSettleInTextField.mTextField.mTextField.textColor = isPreviewMode ? ThemeColor.lightGray.color() : ThemeColor.black.color()
            
            mMobileSettleInTextField.mTextField.mTextField.isEnabled = !isPreviewMode
            mMobileSettleInTextField.mTextField.mTextField.textColor = isPreviewMode ? ThemeColor.lightGray.color() : ThemeColor.black.color()
            
            mAddressSettleInTextView.mTextView.mTextView.isEditable = !isPreviewMode
            mAddressSettleInTextView.mTextView.mTextView.textColor = isPreviewMode ? ThemeColor.lightGray.color() : ThemeColor.black.color()
            
            if String.isAvailable(self.profileModel.IDFile.filename) {
                self.mIDSettleInSelectCell.mDesLabel.textColor = ThemeColor.black.color()
            }
            
            if String.isAvailable(self.profileModel.country.name) {
                self.mCountrySettleInTextField.mDesLabel.textColor = ThemeColor.black.color()
            }
            
            if isPreviewMode {
                self.mIDSettleInSelectCell.mDesLabel.textColor = ThemeColor.lightGray.color()
            }
            
            if isPreviewMode {
                mConfirmButton.setTitle("Edit".localString, for: .normal)
            } else {
                mConfirmButton.setTitle("Submit".localString, for: .normal)
            }
        }
    }
    
    convenience init(isEdit: Bool) {
        self.init()
        self.isEdit = isEdit
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._bindView()
        self._loadData()
        self._loadCountry()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self._reloadData()
    }
    
    override func createUI() {
        super.createUI()
        self.mSafeView.contentType = .flex
        
        self.mSafeView.addSubview(mNameSettleInTextField)
        mNameSettleInTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(20)
        }
        
        self.mSafeView.addSubview(mIDCardSettleInTextField)
        mIDCardSettleInTextField.snp.makeConstraints { make in
            make.left.right.equalTo(mNameSettleInTextField)
            make.top.equalTo(mNameSettleInTextField.snp.bottom)
        }
        
        self.mSafeView.addSubview(mIDSettleInSelectCell)
        mIDSettleInSelectCell.snp.makeConstraints { make in
            make.left.right.equalTo(mNameSettleInTextField)
            make.top.equalTo(mIDCardSettleInTextField.snp.bottom)
        }
        
        self.mSafeView.addSubview(mCountrySettleInTextField)
        mCountrySettleInTextField.snp.makeConstraints { make in
            make.left.right.equalTo(mNameSettleInTextField)
            make.top.equalTo(mIDSettleInSelectCell.snp.bottom)
        }
        
        self.mSafeView.addSubview(mMobileSettleInTextField)
        mMobileSettleInTextField.snp.makeConstraints { make in
            make.left.right.equalTo(mNameSettleInTextField)
            make.top.equalTo(mCountrySettleInTextField.snp.bottom)
        }
        
        self.mSafeView.addSubview(mAddressSettleInTextView)
        mAddressSettleInTextView.snp.makeConstraints { make in
            make.left.right.equalTo(mNameSettleInTextField)
            make.top.equalTo(mMobileSettleInTextField.snp.bottom)
        }
        
        self.mSafeView.addSubview(mBankSettleInSelectCell)
        mBankSettleInSelectCell.snp.makeConstraints { make in
            make.left.right.equalTo(mNameSettleInTextField)
            make.top.equalTo(mAddressSettleInTextView.snp.bottom)
        }
        
        self.mSafeView.addSubview(mTipLabel)
        mTipLabel.snp.makeConstraints { make in
            make.left.right.equalTo(mNameSettleInTextField)
            make.top.equalTo(mBankSettleInSelectCell.snp.bottom).offset(16)
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
    
    //MARK: UI
    lazy var mNameSettleInTextField: SettleInTextField = {
        let view = SettleInTextField(title: "Name *".localString)
        return view
    }()
    
    lazy var mIDSettleInSelectCell: SettleInSelectCell = {
        let view = SettleInSelectCell(title: "Personal ID *".localString)
        view.mDesLabel.text = "Upload".localString
        return view
    }()
    
    lazy var mIDCardSettleInTextField: SettleInTextField = {
        let view = SettleInTextField(title: "ID Number *".localString)
        return view
    }()
    
    lazy var mMobileSettleInTextField: SettleInMobileTextField = {
        let view = SettleInMobileTextField(title: "Phone *".localString)
        return view
    }()
    
    lazy var mCountrySettleInTextField: SettleInSelectCell = {
        let view = SettleInSelectCell(title: "Country *".localString)
        view.mDesLabel.text = "Choose".localString
        return view
    }()
    
    lazy var mAddressSettleInTextView: SettleInTextView = {
        let view = SettleInTextView(title: "Address *".localString)
        return view
    }()
    
    lazy var mBankSettleInSelectCell: SettleInSelectCell = {
        let view = SettleInSelectCell(title: "")
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
        let link = NSAttributedString(string: "Privacy Policy".localString, attributes: [NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue, .underlineColor: ThemeColor.main.color()])
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

extension SettleInVC {
    func _loadData() {
        let userModel = DDUserTools.shared.userInfo.value
        //审核被拒绝，编辑更新重新审核
        if userModel.role.status == 7 {
            self.profileModel.update(model: userModel.userRoleDetail)
            self._reloadData()
        }
    }
    
    func _reloadData() {
        self.mNameSettleInTextField.text = self.profileModel.name
        self.mIDCardSettleInTextField.text = self.profileModel.IDNumber
        if String.isAvailable(self.profileModel.IDFile.filename) {
            self.mIDSettleInSelectCell.mDesLabel.textColor = isPreviewMode ? ThemeColor.lightGray.color() : ThemeColor.black.color()
            self.mIDSettleInSelectCell.text = self.profileModel.IDFile.filename
        }
        self.mAddressSettleInTextView.text = self.profileModel.address
        self.mCountrySettleInTextField.text = self.profileModel.country.name
        if String.isAvailable(self.profileModel.country.name) {
            self.mCountrySettleInTextField.mDesLabel.textColor = isPreviewMode ? ThemeColor.lightGray.color() : ThemeColor.black.color()
        }
        //手机号
        self.mMobileSettleInTextField.mobilePre = self.profileModel.country.phone_code
        if String.isAvailable(self.profileModel.mobile) {
            self.mMobileSettleInTextField.text = self.profileModel.mobile
        }
        
        self._updateButton()
    }
    
    func _updateButton() {
        self.mConfirmButton.isEnabled = self.profileModel.isAvailable() || self.isPreviewMode
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
    
    func _saveSettled() {
        if self.isEdit {
            //保存信息
            self._editSettled()
        } else {
            //弹窗用户协议
            let vc = SettleInRuleVC(profileModel: self.profileModel)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func _editSettled() {
        let user = DDUserTools.shared.userInfo.value.userRoleDetail
        let url = "settled/submitSave"
        let data: [String: Any] = [
            "is_only_edit": 1,
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
            "name": user.name,
            "info": user.intro,
            "head": user.imgUrl.filename,
            "id_number": self.profileModel.IDNumber
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
    
    func _bindView() {
        _ = self.mNameSettleInTextField.mTextField.mTextField.rx.controlEvent(.editingDidEnd).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.profileModel.name = self.mNameSettleInTextField.mTextField.mTextField.text ?? ""
            self._updateButton()
        })
        
        _ = self.mIDCardSettleInTextField.mTextField.mTextField.rx.controlEvent(.editingDidEnd).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.profileModel.IDNumber = self.mIDCardSettleInTextField.mTextField.mTextField.text ?? ""
            self._updateButton()
        })
        
        _ = self.mMobileSettleInTextField.mTextField.mTextField.rx.controlEvent(.editingDidEnd).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.profileModel.mobile = self.mMobileSettleInTextField.mTextField.mTextField.text ?? ""
            self._updateButton()
        })
        
        _ = self.mAddressSettleInTextView.mTextView.mTextView.rx.text.skip(1).subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            self.profileModel.address = text ?? ""
            self._updateButton()
        })
        
        _ = self.mIDSettleInSelectCell.clickPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self, self.isPreviewMode == false else { return }
            let vc = SettleInIDCardVC(model: self.profileModel)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
        _ = self.mCountrySettleInTextField.clickPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self, self.isPreviewMode == false else { return }
            //弹窗
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
        
        _ = self.mBankSettleInSelectCell.clickPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let vc = SettleInBankInfoVC(model: self.profileModel)
            vc.isPreviewMode = self.isPreviewMode
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
        let tap = UITapGestureRecognizer()
        _ = tap.rx.event.subscribe(onNext: { _ in
            UIApplication.shared.open(URL(string: "https://www.easyartonline.com/agreement")!)
        })
        self.mTipLabel.addGestureRecognizer(tap)
                
        //确定
        _ = self.mConfirmButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            if self.isPreviewMode {
                self.isPreviewMode = false
                self.mConfirmButton.isHidden = true
                self.mCancelButton.isHidden = false
                self.mSaveButton.isHidden = false
            } else {
                self._saveSettled()
            }
        })
        
        _ = self.mSaveButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self._saveSettled()
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
}
