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
}

extension OrgVerifVC {
    func _reloadData() {
        mOrgNameTextField.text = profileModel.name
        mOrgIDCardTextField.text = profileModel.idNumber
        if String.isAvailable(profileModel.idFile.filename) {
            mOrgIDSelectCell.mDesLabel.textColor = isPreviewMode ? ThemeColor.lightGray.color() : ThemeColor.black.color()
            mOrgIDSelectCell.text = profileModel.idFile.filename
        }
        mOrgCountrySelectCell.text = profileModel.country.name
        if String.isAvailable(profileModel.country.name) {
            mOrgCountrySelectCell.mDesLabel.textColor = isPreviewMode ? ThemeColor.lightGray.color() : ThemeColor.black.color()
        }
        // 手机号
        mOrgPhoneTextField.setupAsMobileField(countryCode: profileModel.country.phone_code)
        if String.isAvailable(profileModel.mobile) {
            mOrgPhoneTextField.text = profileModel.mobile
        }
        mOrgAddressTextView.text = profileModel.address

        _updateButton()
    }

    func _updateButton() {
//        print(self.profileModel.name)
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

        let tap = UITapGestureRecognizer()
        _ = tap.rx.event.subscribe(onNext: { _ in
            UIApplication.shared.open(URL(string: "https://www.easyartonline.com/agreement")!)
        })
        mTipLabel.addGestureRecognizer(tap)
    }

    func _loadData() {}

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
