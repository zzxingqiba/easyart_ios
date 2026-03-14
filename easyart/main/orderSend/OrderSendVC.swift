//
//  OrderSendVC.swift
//  easyart
//
//  Created by Damon on 2025/6/24.
//

import UIKit
import RxRelay

class OrderSendVC: BaseVC {
    private var orderNumber: String
    var modelRelay = BehaviorRelay(value: LogisticsModel())
    
    init(orderNumber: String) {
        self.orderNumber = orderNumber
        super.init(bottomPadding: 150)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self._bindView()
    }
    
    override func createUI() {
        super.createUI()
        self.mSafeView.ignoreSafeAreaType = .bottom
        self.mSafeView.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(16)
        }
        
        self.mSafeView.addSubview(mLogisticsListNameView)
        mLogisticsListNameView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(mTitleLabel.snp.bottom).offset(16)
            make.height.equalTo(50)
        }
        mLogisticsListNameView.addSubview(mLogisticsListNameLabel)
        mLogisticsListNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        let imageView = UIImageView(image: UIImage(named: "xiala"))
        mLogisticsListNameView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
            make.width.equalTo(8)
            make.height.equalTo(4.5)
        }
        
        self.mSafeView.addSubview(mTextField)
        mTextField.snp.makeConstraints { make in
            make.left.right.equalTo(mLogisticsListNameView)
            make.top.equalTo(mLogisticsListNameView.snp.bottom).offset(16)
            make.height.equalTo(50)
        }
        
        mTextField.addSubview(mScanImageView)
        mScanImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
            make.width.equalTo(15)
            make.height.equalTo(15)
        }
        
        self.mTextField.addSubview(mAddressTitleLabel)
        mAddressTitleLabel.snp.makeConstraints { make in
            make.left.right.equalTo(mTitleLabel)
            make.top.equalTo(mTextField.snp.bottom).offset(20)
        }
        
        self.mSafeView.addSubview(mAddressContentView)
        mAddressContentView.snp.makeConstraints { make in
            make.left.right.equalTo(mTitleLabel)
            make.top.equalTo(mAddressTitleLabel.snp.bottom).offset(12)
        }
        mAddressContentView.addSubview(mAddressNameLabel)
        mAddressNameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-80)
            make.top.equalToSuperview().offset(16)
        }
        mAddressContentView.addSubview(mAddressPhoneLabel)
        mAddressPhoneLabel.snp.makeConstraints { make in
            make.left.right.equalTo(mAddressNameLabel)
            make.top.equalTo(mAddressNameLabel.snp.bottom).offset(10)
        }
        
        mAddressContentView.addSubview(mAddressDetailLabel)
        mAddressDetailLabel.snp.makeConstraints { make in
            make.left.right.equalTo(mAddressNameLabel)
            make.top.equalTo(mAddressPhoneLabel.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        let lineView = UIView()
        lineView.backgroundColor = ThemeColor.line.color()
        mAddressContentView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-70)
            make.width.equalTo(1)
            make.height.equalTo(50)
        }
        mAddressContentView.addSubview(mAddressCopyLabel)
        mAddressCopyLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(lineView.snp.right)
            make.right.equalToSuperview()
        }
        
        self.mSafeView.addSubview(mConfirmButton)
        mConfirmButton.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(BottomSafeAreaHeight + 50)
        }
        
        //弹窗
        self.mSafeView.addSubview(mLogisticsListPopView)
        mLogisticsListPopView.snp.makeConstraints { make in
            make.left.right.top.equalTo(mLogisticsListNameView)
        }
    }
    
    //MARK: UI
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Please input the tracking number.".localString
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 13)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mLogisticsListNameView: UIView = {
        let view = UIView()
        view.layer.borderColor = ThemeColor.lightGray.color().cgColor
        view.layer.borderWidth = 0.5
        return view
    }()
    
    lazy var mLogisticsListPopView: LogisticsListPopView = {
        let view = LogisticsListPopView()
        view.isHidden = true
        return view
    }()
    
    lazy var mLogisticsListNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Please select the delivery company".localString
        label.font = .systemFont(ofSize: 13)
        label.textColor = ThemeColor.lightGray.color()
        return label
    }()
    
    lazy var mTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Please input the tracking number".localString
        textField.font = .systemFont(ofSize: 13)
        textField.textColor = ThemeColor.black.color()
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 1))
        textField.layer.borderColor = ThemeColor.lightGray.color().cgColor
        textField.layer.borderWidth = 0.5
        return textField
    }()
    
    lazy var mScanImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "scan"))
        imageView.isHidden = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var mAddressTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Address for easyart® verification".localString
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 13)
        label.textColor = ThemeColor.lightGray.color()
        return label
    }()
    
    lazy var mAddressContentView: UIView = {
        let view = UIView()
        view.layer.borderColor = ThemeColor.lightGray.color().cgColor
        view.layer.borderWidth = 0.5
        return view
    }()
    
    lazy var mAddressNameLabel: UILabel = {
        let label = UILabel()
        label.text = "艺直购™".localString
        label.font = .systemFont(ofSize: 13)
        label.textColor = ThemeColor.lightGray.color()
        return label
    }()
    
    lazy var mAddressPhoneLabel: UILabel = {
        let label = UILabel()
        label.text = "13774298809".localString
        label.font = .systemFont(ofSize: 13)
        label.textColor = ThemeColor.lightGray.color()
        return label
    }()
    
    lazy var mAddressDetailLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = "上海市普陀区莫干山路50号13幢2楼".localString
        label.font = .systemFont(ofSize: 13)
        label.textColor = ThemeColor.lightGray.color()
        return label
    }()
    
    lazy var mAddressCopyLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Copy".localString
        label.font = .systemFont(ofSize: 13)
        label.textColor = ThemeColor.lightGray.color()
        return label
    }()
    
    lazy var mConfirmButton: UIButton = {
        let tButton = UIButton(type: .custom)
        tButton.setBackgroundImage(UIImage.dd.getImage(color: ThemeColor.black.color()), for: .normal)
        tButton.setBackgroundImage(UIImage.dd.getImage(color: ThemeColor.gray.color()), for: .disabled)
        tButton.titleLabel?.font = .systemFont(ofSize: 14)
        tButton.setTitleColor(UIColor.dd.color(hexValue: 0xffffff), for: .normal)
        tButton.setTitle("Deliver".localString, for: .normal)
        return tButton
    }()
    
    
}

extension OrderSendVC {
    func _bindView() {
        let tap = UITapGestureRecognizer()
        _ = tap.rx.event.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            //弹窗
            self.mLogisticsListPopView.isHidden = false
        })
        self.mLogisticsListNameView.addGestureRecognizer(tap)
        
        let tap2 = UITapGestureRecognizer()
        _ = tap2.rx.event.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let vc = OrderQRScanVC()
            vc.model = self.modelRelay.value
            self.navigationController?.pushViewController(vc, animated: true)
        })
        self.mScanImageView.addGestureRecognizer(tap2)
        
        _ = self.mLogisticsListPopView.clickPublish.subscribe(onNext: { [weak self]  clickInfo in
            guard let self = self else { return }
            self.mLogisticsListPopView.isHidden = true
            if clickInfo.clickType == .confirm, let type = clickInfo.info as? LogisticsType {
                let model = self.modelRelay.value
                model.type = type
                self.modelRelay.accept(model)
            }
        })
        
        _ = self.mTextField.rx.text.orEmpty.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            let model = self.modelRelay.value
            model.number = text
            self.modelRelay.accept(model)
        })
        
        _ = self.mConfirmButton.rx.tap.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            let sheet = DDSheetView()
            sheet.mTitleLabel.text = "Initiate the delivery".localString
            _ = sheet.mClickSubject.subscribe(onNext: { [weak self] buttonType in
                guard let self = self else { return }
                DDPopView.hide()
                if buttonType == .confirm {
                    //发货
                    let model = self.modelRelay.value
                    _ = DDAPI.shared.request("logistics/saveLogistics", data: ["order_number": self.orderNumber, "logistics_company": model.type!.title(), "logistics_number": model.number]).subscribe(onSuccess: { [weak self] response in
                        guard let self = self else { return }
                        self.navigationController?.popViewController(animated: true)
                    })
                }
            })
            DDPopView.show(view: sheet, animationType: .bottom)
            
        })
        
        _ = self.modelRelay.subscribe(onNext: { [weak self] model in
            guard let self = self else { return }
            self.mConfirmButton.isEnabled = model.isAvailable()
            //
            self.mLogisticsListNameLabel.text = model.type != nil ? model.type!.title() : "Please select the delivery company"
            self.mLogisticsListNameLabel.textColor = model.type != nil ? ThemeColor.black.color() : ThemeColor.lightGray.color()
            self.mTextField.text = model.number
        })
    }
}
