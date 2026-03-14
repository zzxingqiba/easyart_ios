//
//  AddressEditVC.swift
//  easyart
//
//  Created by Damon on 2024/9/19.
//

import UIKit
import HDHUD
import RxRelay
import SwiftyJSON
import RxSwift

class AddressEditVC: BaseVC {
    var model: DDAddressModel
    let addressChangeRelay = PublishRelay<DDAddressModel>()
    
    init(model: DDAddressModel? = nil) {
        self.model = model ?? DDAddressModel()
        super.init(bottomPadding: 100 + BottomSafeAreaHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._bindView()
        self._loadData()
        self._loadCountry()
    }
    
    override func createUI() {
        super.createUI()
        self.mSafeView.contentType = .flex
        self.mSafeView.addSubview(mNameEditLabelView)
        mNameEditLabelView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
        }
        
        self.mSafeView.addSubview(mSecondNameEditLabelView)
        mSecondNameEditLabelView.snp.makeConstraints { make in
            make.left.right.equalTo(mNameEditLabelView)
            make.top.equalTo(mNameEditLabelView.snp.bottom).offset(25)
        }
        
        self.mSafeView.addSubview(mCountryEditLabelView)
        mCountryEditLabelView.snp.makeConstraints { make in
            make.left.right.equalTo(mNameEditLabelView)
            make.top.equalTo(self.mSecondNameEditLabelView.snp.bottom).offset(25)
        }
        
        self.mSafeView.addSubview(mPhoneEditLabelView)
        mPhoneEditLabelView.snp.makeConstraints { make in
            make.left.right.equalTo(mNameEditLabelView)
            make.top.equalTo(self.mCountryEditLabelView.snp.bottom).offset(25)
        }
        
        self.mSafeView.addSubview(mCityEditLabelView)
        mCityEditLabelView.snp.makeConstraints { make in
            make.left.right.equalTo(mNameEditLabelView)
            make.top.equalTo(self.mPhoneEditLabelView.snp.bottom).offset(25)
        }
        
        self.mSafeView.addSubview(mAreaEditLabelView)
        mAreaEditLabelView.snp.makeConstraints { make in
            make.left.right.equalTo(mNameEditLabelView)
            make.top.equalTo(self.mCityEditLabelView.snp.bottom).offset(25)
        }
        
        self.mSafeView.addSubview(mAddressEditLabelView)
        mAddressEditLabelView.snp.makeConstraints { make in
            make.left.right.equalTo(mNameEditLabelView)
            make.top.equalTo(self.mAreaEditLabelView.snp.bottom).offset(25)
        }
        
        self.mSafeView.addSubview(mCodeEditLabelView)
        mCodeEditLabelView.snp.makeConstraints { make in
            make.left.right.equalTo(mNameEditLabelView)
            make.top.equalTo(self.mAddressEditLabelView.snp.bottom).offset(25)
        }
        
        self.mSafeView.addSubview(mProvinceEditLabelView)
        mProvinceEditLabelView.snp.makeConstraints { make in
            make.left.right.equalTo(mNameEditLabelView)
            make.top.equalTo(self.mCodeEditLabelView.snp.bottom).offset(25)
        }
        
        self.mSafeView.addSubview(mDefaultButton)
        mDefaultButton.snp.makeConstraints { make in
            make.left.right.equalTo(mNameEditLabelView)
            make.top.equalTo(mProvinceEditLabelView.snp.bottom).offset(20)
            make.height.equalTo(50)
        }
        
        self.mSafeView.addSubview(mTipLabel)
        mTipLabel.snp.makeConstraints { make in
            make.left.equalTo(mDefaultButton)
            make.top.equalTo(mDefaultButton.snp.bottom)
        }
        
        self.mSafeView.addSubview(mDeleteButton)
        mDeleteButton.snp.makeConstraints { make in
            make.left.right.equalTo(mNameEditLabelView)
            make.top.equalTo(mTipLabel.snp.bottom).offset(30)
            make.height.equalTo(50)
        }
        
        let line3 = UIView()
        line3.backgroundColor = ThemeColor.line.color()
        self.mDeleteButton.addSubview(line3)
        line3.snp.makeConstraints { make in
            make.left.right.equalTo(mNameEditLabelView)
            make.bottom.equalTo(mDeleteButton.snp.bottom)
            make.height.equalTo(1)
        }
        
        self.view.addSubview(mAddButton)
        mAddButton.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(50 + BottomSafeAreaHeight)
        }
    }
    
    //MARK: UI
    lazy var mNameEditLabelView: DDAddressEditLabelView = {
        let view = DDAddressEditLabelView(title: "FirstName".localString + " *")
        view.errorTitle = "FirstName".localString + " " + "is required".localString
        return view
    }()
    
    lazy var mSecondNameEditLabelView: DDAddressEditLabelView = {
        let view = DDAddressEditLabelView(title: "LastName".localString + " *")
        view.errorTitle = "LastName".localString + " " + "is required".localString
        return view
    }()
    
    lazy var mPhoneEditLabelView: DDAddressEditLabelView = {
        let view = DDAddressEditLabelView(title: "Phone number".localString + " *")
        view.mTextField.mTextField.keyboardType = .phonePad
        view.errorTitle = "Phone number".localString + " " + "is required".localString
        view.placeholder = "Please enter a valid contact information".localString
        return view
    }()
    
    lazy var mCountryEditLabelView: DDAddressCountryView = {
        let view = DDAddressCountryView(title: "Country".localString + " *")
        view.errorTitle = "Country".localString + " " + "is required".localString
        return view
    }()
    
    lazy var mCityEditLabelView: DDAddressEditLabelView = {
        let view = DDAddressEditLabelView(title: "City".localString + " *")
        view.errorTitle = "City".localString + " " + "is required".localString
        return view
    }()
    
    lazy var mAreaEditLabelView: DDAddressTextViewEditView = {
        let view = DDAddressTextViewEditView(title: "Address line 1".localString + " *")
        view.errorTitle = "Address line 1".localString + " " + "is required".localString
        return view
    }()
    
    lazy var mAddressEditLabelView: DDAddressTextViewEditView = {
        let view = DDAddressTextViewEditView(title: "Address line 2 (optional)".localString)
        return view
    }()
    
    lazy var mCodeEditLabelView: DDAddressEditLabelView = {
        let view = DDAddressEditLabelView(title: "ZIP code".localString + " *")
        view.errorTitle = "ZIP code".localString + " " + "is required".localString
        return view
    }()
    
    lazy var mProvinceEditLabelView: DDAddressEditLabelView = {
        let view = DDAddressEditLabelView(title: "State".localString)
        return view
    }()
    
    lazy var mDefaultButton: DDButton = {
        let button = DDButton()
        button.contentType = .left(gap: 5)
        button.mTitleLabel.font = .systemFont(ofSize: 14)
        button.mTitleLabel.textColor = ThemeColor.black.color()
        button.mTitleLabel.text = "Default shipping address".localString
        button.normalImage = UIImage(named: "icon_normal")
        button.selectedImage = UIImage(named: "icon_selected")
        button.imageSize = CGSize(width: 15, height: 15)
        return button
    }()
    
    lazy var mTipLabel: UILabel = {
        let label = UILabel()
        label.text = "* " + "Required field".localString
        label.font = .systemFont(ofSize: 12)
        label.textColor = ThemeColor.gray.color()
        return label
    }()
    
    lazy var mDeleteButton: DDButton = {
        let button = DDButton(imagePosition: .right)
        button.contentType = .between(insert: .zero)
        button.normalImage =  UIImage(named: "me_jiantou")
        button.imageSize = CGSize(width: 5, height: 8)
        button.mTitleLabel.text = "Delete shipping address".localString
        button.mTitleLabel.font = .systemFont(ofSize: 14)
        button.mTitleLabel.textColor = UIColor.dd.color(hexValue: 0xF50045)
        button.backgroundColor = UIColor.clear
        return button
    }()
    
    lazy var mAddButton: DDButton = {
        let button = DDButton(imagePosition: .none)
        button.mTitleLabel.text = "Save".localString
        button.mTitleLabel.font = .systemFont(ofSize: 14)
        button.mTitleLabel.textColor = UIColor.dd.color(hexValue: 0xffffff)
        button.backgroundColor = ThemeColor.black.color()
        return button
    }()
}

extension AddressEditVC {
    
    func _loadCountry() {
        _ = DDAPI.shared.request("config/countryList").subscribe(onSuccess: { [weak self] response in
            guard let self = self else { return }
            let data = JSON(response.data)
            if let list = data["country_list"].arrayObject as? [[String: Any]] {
                let countryList = list.kj.modelArray(AddressCountryInfo.self)
                self.mCountryEditLabelView.list = countryList.filter({ info in
                    return info.id != "1"
                })
            }
        })
    }
    
    func _loadData() {
        self.mNameEditLabelView.text = self.model.consignee
        self.mSecondNameEditLabelView.text = self.model.surname
       
        if String.isAvailable(self.model.country_id) {
            self.mCountryEditLabelView.selectedCountry.accept(AddressCountryInfo(id: self.model.country_id, name: self.model.country_name))
        } else {
            self.mCountryEditLabelView.selectedCountry.accept(nil)
        }
        if String.isAvailable(self.model.phone_number) {
            self.mPhoneEditLabelView.text = self.model.phone_number
        }
        self.mCityEditLabelView.text = self.model.city
        self.mAreaEditLabelView.text = self.model.area
        self.mAddressEditLabelView.text = self.model.full_address
        self.mCodeEditLabelView.text = self.model.zip_code
        self.mProvinceEditLabelView.text = self.model.province
        self.mDeleteButton.isHidden = !String.isAvailable(self.model.id)
        self.mDefaultButton.isSelected = self.model.is_default
    }
    
    func _bindView() {
        _ = self.mCountryEditLabelView.selectedCountry.subscribe(onNext: { [weak self] countryInfo in
            guard let self = self else { return }
            if let info = countryInfo {
                self.mPhoneEditLabelView.text = info.phone_code + " "
            }
        })
        
        _ = self.mDefaultButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.mDefaultButton.isSelected = !self.mDefaultButton.isSelected
            self.model.is_default = self.mDefaultButton.isSelected
        })
        
        _ = self.mDeleteButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            //
            let sheet = DDSheetView()
            sheet.mTitleLabel.text = "Do you want to delete the address".localString
            _ = sheet.mClickSubject.subscribe(onNext: { [weak self] buttonType in
                guard let self = self else { return }
                DDPopView.hide()
                if buttonType == .confirm {
                    _ = DDAPI.shared.request("home/addrDel", data: ["addr_id": self.model.id]).subscribe(onSuccess: { [weak self] response in
                        guard let self = self else { return }
                        HDHUD.show("Delete successful".localString)
                        self.navigationController?.popViewController(animated: true)
                    })
                }
            })
            DDPopView.show(view: sheet, animationType: .bottom)
        })
        
        _ = self.mAddButton.rx.tap.throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            
            if !String.isAvailable(self.mNameEditLabelView.text) {
                HDHUD.show(" Please enter".localString + "FirstName".localString)
                self.mNameEditLabelView.isError = true
                return
            }
            if !String.isAvailable(self.mSecondNameEditLabelView.text) {
                HDHUD.show(" Please enter".localString + "LastName".localString)
                self.mSecondNameEditLabelView.isError = true
                return
            }
            if !String.isAvailable(self.mPhoneEditLabelView.text) {
                HDHUD.show(" Please enter".localString + "Phone number".localString)
                self.mPhoneEditLabelView.isError = true
                return
            }
            if !String.isAvailable(self.mCountryEditLabelView.selectedCountry.value?.id) {
                HDHUD.show(" Please enter".localString + "Country".localString)
                self.mCountryEditLabelView.isError = true
                return
            }
            if !String.isAvailable(self.mCityEditLabelView.text) {
                HDHUD.show(" Please enter".localString + "City".localString)
                self.mCityEditLabelView.isError = true
                return
            }
            if !String.isAvailable(self.mAreaEditLabelView.text) {
                HDHUD.show(" Please enter".localString + "Address line 1".localString)
                self.mAreaEditLabelView.isError = true
                return
            }
            if !String.isAvailable(self.mCodeEditLabelView.text) {
                HDHUD.show(" Please enter".localString + "ZIP code".localString)
                self.mCodeEditLabelView.isError = true
                return
            }
            
            self.model.consignee = self.mNameEditLabelView.text!
            self.model.surname = self.mSecondNameEditLabelView.text!
            self.model.phone_number = self.mPhoneEditLabelView.text!
            self.model.country_name = self.mCountryEditLabelView.selectedCountry.value?.name ?? ""
            self.model.country_id = self.mCountryEditLabelView.selectedCountry.value?.id ?? ""
            self.model.city = self.mCityEditLabelView.text!
            self.model.area = self.mAreaEditLabelView.text!
            self.model.full_address = self.mAddressEditLabelView.text ?? ""
            self.model.zip_code = self.mCodeEditLabelView.text!
            self.model.province = self.mProvinceEditLabelView.text ?? ""
            
            self.model.is_default = self.mDefaultButton.isSelected
            let id = String.isAvailable(self.model.id) ? self.model.id : "0"
            _ = DDAPI.shared.request("home/addrSave", data: ["addr_id": id, "consignee": self.model.consignee, "surname": self.model.surname, "phone_number": self.model.phone_number, "country_id": self.model.country_id, "city": self.model.city, "area": self.model.area, "full_address": self.model.full_address,"zip_code": self.model.zip_code, "province": self.model.province, "is_default": self.model.is_default ? "1" : "0"]).subscribe(onSuccess: { [weak self] response in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            })
        })
        
    }
}
