//
//  OrgBankInfoVC.swift
//  easyart
//
//  Created by 崭新的旧刀 on 2026/3/25.
//

import HDHUD
import RxRelay
import SwiftyJSON
import UIKit

class OrgBankInfoVC: BaseVC {
    var profileModel = OrgProfileModel()
    var bankTypeList = [OrgBankInfoType]()
    var isPreviewMode = false {
        didSet {
            mAccountNameTextField.mTextField.mTextField.isEnabled = !isPreviewMode
            mAccountNameTextField.mTextField.mTextField.textColor = isPreviewMode ? ThemeColor.lightGray.color() : ThemeColor.black.color()
            
            mAccountCodeTextField.mTextField.mTextField.isEnabled = !isPreviewMode
            mAccountCodeTextField.mTextField.mTextField.textColor = isPreviewMode ? ThemeColor.lightGray.color() : ThemeColor.black.color()
            
            mAccountNumberTextField.mTextField.mTextField.isEnabled = !isPreviewMode
            mAccountNumberTextField.mTextField.mTextField.textColor = isPreviewMode ? ThemeColor.lightGray.color() : ThemeColor.black.color()
            
            if isPreviewMode {
                mConfirmButton.setTitle("Edit".localString, for: .normal)
            } else {
                mConfirmButton.setTitle("Confirm".localString, for: .normal)
            }
        }
    }
    
    init(model: OrgProfileModel) {
        self.profileModel = model
        super.init(bottomPadding: 50)
    }
    
    @available(*, unavailable)
    @MainActor required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._loadBankTypeList()
        self._bindView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self._reloadData()
    }
    
    override func createUI() {
        super.createUI()
        self.mSafeView.contentType = .flex
        
        self.mSafeView.addSubview(self.mAccountNameTextField)
        self.mAccountNameTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(20)
        }
        self.mSafeView.addSubview(self.mAccountTypeSelectCell)
        self.mAccountTypeSelectCell.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(self.mAccountNameTextField.snp.bottom)
        }
        self.mSafeView.addSubview(self.mAccountCodeTextField)
        self.mAccountCodeTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(self.mAccountTypeSelectCell.snp.bottom)
        }
        self.mSafeView.addSubview(self.mAccountNumberTextField)
        self.mAccountNumberTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(self.mAccountCodeTextField.snp.bottom)
        }
        self.view.addSubview(self.mConfirmButton)
        self.mConfirmButton.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(50 + BottomSafeAreaHeight)
        }
    }
    
    // MARK: UI

    lazy var mAccountNameTextField: OrgVerifField = .init(title: "Account name *".localString)
    
    lazy var mAccountTypeSelectCell: OrgVerifSelectCell = {
        let view = OrgVerifSelectCell(title: "Account type *".localString)
        view.mDesLabel.text = "Please select".localString
        view.mArrowImageView.image = UIImage(named: "home_audio_arrow")
        return view
    }()
    
    lazy var mAccountCodeTextField: OrgVerifField = {
        let view = OrgVerifField(title: "")
        let attributedString = NSMutableAttributedString(string: "Swift/BIC code *".localString)
        let edit = NSAttributedString(string: "Tips".localString, attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, .underlineColor: ThemeColor.lightGray.color(), .foregroundColor: ThemeColor.lightGray.color()])
        attributedString.append(NSAttributedString(string: " "))
        attributedString.append(edit)
        view.mTitleLabel.attributedText = attributedString
        return view
    }()
    
    lazy var mAccountNumberTextField: OrgVerifField = .init(title: "Account number *".localString)
    
    lazy var mConfirmButton: UIButton = {
        let tButton = UIButton(type: .custom)
        tButton.setBackgroundImage(UIImage.dd.getImage(color: ThemeColor.black.color()), for: .normal)
        tButton.setBackgroundImage(UIImage.dd.getImage(color: ThemeColor.gray.color()), for: .disabled)
        tButton.titleLabel?.font = .systemFont(ofSize: 14)
        tButton.setTitleColor(UIColor.dd.color(hexValue: 0xffffff), for: .normal)
        tButton.setTitle("Confirm".localString, for: .normal)
        tButton.isEnabled = false
        return tButton
    }()
}

extension OrgBankInfoVC {
    func _reloadData() {
        print(self.profileModel.bankInfo.name)
        self.mAccountNameTextField.text = self.profileModel.bankInfo.name
        if String.isAvailable(self.profileModel.bankInfo.bankType.name) {
            self.mAccountTypeSelectCell.text = self.profileModel.bankInfo.bankType.name
        }
        self.mAccountCodeTextField.text = self.profileModel.bankInfo.swiftCode
        self.mAccountNumberTextField.text = self.profileModel.bankInfo.number
        
        self._updateButton()
    }
    
    func _updateButton() {
        self.mConfirmButton.isEnabled = self.profileModel.bankInfo.isAvailable() || self.isPreviewMode
    }
    
    func _bindView() {
        _ = self.mAccountNameTextField.mTextField.mTextField.rx.controlEvent(.editingDidEnd).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.profileModel.bankInfo.name = self.mAccountNameTextField.text ?? ""
            self._updateButton()
        })
        _ = self.mAccountCodeTextField.mTextField.mTextField.rx.controlEvent(.editingDidEnd).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.profileModel.bankInfo.swiftCode = self.mAccountCodeTextField.text ?? ""
            self._updateButton()
        })
        _ = self.mAccountNumberTextField.mTextField.mTextField.rx.controlEvent(.editingDidEnd).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.profileModel.bankInfo.number = self.mAccountNumberTextField.text ?? ""
            self._updateButton()
        })
        
        let tap = UITapGestureRecognizer()
        _ = tap.rx.event.subscribe(onNext: { _ in
            let pop = OrgSwiftCodePop()
            _ = pop.clickPublish.subscribe(onNext: { _ in
                DDPopView.hide()
            })
            DDPopView.show(view: pop, animationType: .bottom)
            DDPopView.mShouldCloseIfClickBG = true
        })
        self.mAccountCodeTextField.mTitleLabel.addGestureRecognizer(tap)
        
        _ = self.mAccountTypeSelectCell.clickPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self, self.isPreviewMode == false else { return }
            // 弹窗
            let pop = OrgBankTypeListPop()
            pop.list = self.bankTypeList
            _ = pop.clickPublish.subscribe(onNext: { [weak self] clickInfo in
                DDPopView.hide()
                guard let self = self else { return }
                if clickInfo.clickType == .confirm, let bankType = clickInfo.info as? OrgBankInfoType {
                    self.profileModel.bankInfo.bankType = bankType
                    self._reloadData()
                }
            })
            DDPopView.show(view: pop, animationType: .bottom)
        })
        
        // 确定
        _ = self.mConfirmButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            if self.isPreviewMode {
                self.isPreviewMode = !self.isPreviewMode
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        })
    }

    func _loadBankTypeList() {
        _ = DDServerConfigTools.shared.updateConfig().subscribe(onSuccess: { [weak self] json in
            guard let self = self else { return }
            if let list = json["receive_account_type_list"].arrayObject as? [[String: Any]] {
                self.bankTypeList = list.kj.modelArray(OrgBankInfoType.self)
            }
        })
    }
}
