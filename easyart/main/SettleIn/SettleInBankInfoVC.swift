//
//  SettleInBankInfoVC.swift
//  easyart
//
//  Created by Damon on 2024/12/18.
//

import UIKit
import HDHUD
import RxRelay
import SwiftyJSON


class SettleInBankInfoVC: BaseVC {
    var profileModel = SettleInProfileModel()
    var bankTypeList = [SettleBankInfoType]()
    var isPreviewMode = false {
        didSet {
            mBankNameSettleInTextField.mTextField.mTextField.isEnabled = !isPreviewMode
            mBankNameSettleInTextField.mTextField.mTextField.textColor = isPreviewMode ? ThemeColor.lightGray.color() : ThemeColor.black.color()
            
            mBankCodeSettleInTextField.mTextField.mTextField.isEnabled = !isPreviewMode
            mBankCodeSettleInTextField.mTextField.mTextField.textColor = isPreviewMode ? ThemeColor.lightGray.color() : ThemeColor.black.color()
            
            mBankNumberSettleInTextField.mTextField.mTextField.isEnabled = !isPreviewMode
            mBankNumberSettleInTextField.mTextField.mTextField.textColor = isPreviewMode ? ThemeColor.lightGray.color() : ThemeColor.black.color()
            
            if isPreviewMode {
                mConfirmButton.setTitle("Edit".localString, for: .normal)
            } else {
                mConfirmButton.setTitle("Confirm".localString, for: .normal)
            }
        }
    }
    
    init(model: SettleInProfileModel) {
        self.profileModel = model
        super.init(bottomPadding: 50)
    }
    
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
        
        self.mSafeView.addSubview(mBankNameSettleInTextField)
        mBankNameSettleInTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(20)
        }
        
        self.mSafeView.addSubview(mBankTypeSettleInSelectCell)
        mBankTypeSettleInSelectCell.snp.makeConstraints { make in
            make.left.right.equalTo(mBankNameSettleInTextField)
            make.top.equalTo(mBankNameSettleInTextField.snp.bottom)
        }
        
        self.mSafeView.addSubview(mBankCodeSettleInTextField)
        mBankCodeSettleInTextField.snp.makeConstraints { make in
            make.left.right.equalTo(mBankNameSettleInTextField)
            make.top.equalTo(mBankTypeSettleInSelectCell.snp.bottom)
        }
        
        self.mSafeView.addSubview(mBankNumberSettleInTextField)
        mBankNumberSettleInTextField.snp.makeConstraints { make in
            make.left.right.equalTo(mBankNameSettleInTextField)
            make.top.equalTo(mBankCodeSettleInTextField.snp.bottom)
        }
        
        
        self.mSafeView.addSubview(mTipLabel)
        mTipLabel.snp.makeConstraints { make in
            make.left.right.equalTo(mBankNameSettleInTextField)
            make.top.equalTo(mBankNumberSettleInTextField.snp.bottom).offset(16)
        }
        
        self.view.addSubview(mConfirmButton)
        mConfirmButton.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(50 + BottomSafeAreaHeight)
        }
    }
    
    //MARK: UI
    lazy var mBankNameSettleInTextField: SettleInTextField = {
        let view = SettleInTextField(title: "Account name *".localString)
        return view
    }()
    
    lazy var mBankTypeSettleInSelectCell: SettleInSelectCell = {
        let view = SettleInSelectCell(title: "Account type *".localString)
        view.mDesLabel.text = "Please select".localString
        view.mArrowImageView.image = UIImage(named: "home_audio_arrow")
        return view
    }()
    
    lazy var mBankCodeSettleInTextField: SettleInTextField = {
        let view = SettleInTextField(title: "")
        let attributedString = NSMutableAttributedString(string: "Swift/BIC code *".localString)
        let edit = NSAttributedString(string: "Tips".localString, attributes: [NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue, .underlineColor: ThemeColor.lightGray.color(), .foregroundColor: ThemeColor.lightGray.color()])
        attributedString.append(NSAttributedString(string: " "))
        attributedString.append(edit)
        view.mTitleLabel.attributedText = attributedString
        
        return view
    }()
    
    lazy var mBankNumberSettleInTextField: SettleInTextField = {
        let view = SettleInTextField(title: "Account number *".localString)
        return view
    }()
    
    lazy var mTipLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.numberOfLines = 0
        label.text = "After entering your details, you'll see a test deposit for less than $1 within 3 business days".localString
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
        tButton.setTitle("Confirm".localString, for: .normal)
        tButton.isEnabled = false
        return tButton
    }()
}

extension SettleInBankInfoVC {
    func _reloadData() {
        print(self.profileModel.bankInfo.name)
        self.mBankNameSettleInTextField.text = self.profileModel.bankInfo.name
        self.mBankCodeSettleInTextField.text = self.profileModel.bankInfo.swiftCode
        self.mBankNumberSettleInTextField.text = self.profileModel.bankInfo.number
        if String.isAvailable(self.profileModel.bankInfo.bankType.name) {
            self.mBankTypeSettleInSelectCell.text = self.profileModel.bankInfo.bankType.name
        }
        
        self._updateButton()
    }
    
    func _updateButton() {
        self.mConfirmButton.isEnabled = self.profileModel.bankInfo.isAvailable() || self.isPreviewMode
    }
    
    func _loadBankTypeList() {
        _ = DDServerConfigTools.shared.updateConfig().subscribe(onSuccess: { [weak self] json in
            guard let self = self else { return }
            if let list = json["receive_account_type_list"].arrayObject as? [[String: Any]] {
                self.bankTypeList = list.kj.modelArray(SettleBankInfoType.self)
            }
        })
    }
    
    func _bindView() {
        _ = self.mBankNameSettleInTextField.mTextField.mTextField.rx.controlEvent(.editingDidEnd).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.profileModel.bankInfo.name = self.mBankNameSettleInTextField.mTextField.mTextField.text ?? ""
            print(self.profileModel.bankInfo.name)
            self._updateButton()
        })
        
        _ = self.mBankCodeSettleInTextField.mTextField.mTextField.rx.controlEvent(.editingDidEnd).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.profileModel.bankInfo.swiftCode = self.mBankCodeSettleInTextField.mTextField.mTextField.text ?? ""
            self._updateButton()
        })
        
        _ = self.mBankNumberSettleInTextField.mTextField.mTextField.rx.controlEvent(.editingDidEnd).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.profileModel.bankInfo.number = self.mBankNumberSettleInTextField.mTextField.mTextField.text ?? ""
            self._updateButton()
            
        })
        
        let tap = UITapGestureRecognizer()
        _ = tap.rx.event.subscribe(onNext: { _ in
            let pop = SettleSwiftCodePop()
            _ = pop.clickPublish.subscribe(onNext: { _ in
                DDPopView.hide()
            })
            DDPopView.show(view: pop, animationType: .bottom)
            DDPopView.mShouldCloseIfClickBG = true
        })
        mBankCodeSettleInTextField.mTitleLabel.addGestureRecognizer(tap)
        
        
        _ = self.mBankTypeSettleInSelectCell.clickPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self, self.isPreviewMode == false else { return }
            //弹窗
            let pop = SettleInBankTypeListPop()
            pop.list = self.bankTypeList
            _ = pop.clickPublish.subscribe(onNext: { [weak self] clickInfo in
                DDPopView.hide()
                guard let self = self else { return }
                if clickInfo.clickType == .confirm, let bankType = clickInfo.info as? SettleBankInfoType {
                    self.profileModel.bankInfo.bankType = bankType
                    self._reloadData()
                }
            })
            DDPopView.show(view: pop, animationType: .bottom)
        })
        
        //确定
        _ = self.mConfirmButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            if self.isPreviewMode {
                self.isPreviewMode = !self.isPreviewMode
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
}
