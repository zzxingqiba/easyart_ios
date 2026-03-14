//
//  DDAddressCountryView.swift
//  easyart
//
//  Created by Damon on 2024/10/31.
//

import UIKit
import KakaJSON
import RxRelay

struct AddressCountryInfo: Convertible {
    var id = ""
    var name = ""
    var phone_code = ""
}

class DDAddressCountryView: DDView {
    var errorTitle = ""
    var selectedCountry = BehaviorRelay<AddressCountryInfo?>(value: nil)
    var list = [AddressCountryInfo]()
    init(title: String) {
        super.init(frame: .zero)
        self.title = title
        self._bindView()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isError = false {
        didSet {
            if isError {
                mErrorLabel.text = self.errorTitle
                self.mTextField.mBottomLine.backgroundColor = ThemeColor.red.color()
            } else {
                mErrorLabel.text = nil
                self.mTextField.mBottomLine.backgroundColor = UIColor.dd.color(hexValue: 0x666666, alpha: 0.4)
            }
        }
    }
    
    var title: String? {
        get {
            return self.mTitleLabel.text
        }
        set {
            self.mTitleLabel.text = newValue
        }
    }
    
    var placeholder: String? {
        get {
            return mTextField.mTextField.placeholder
        }
        set {
            mTextField.mTextField.placeholder = newValue
        }
    }
    
    override func createUI() {
        self.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
        }
        
        self.addSubview(mTextField)
        mTextField.snp.makeConstraints { make in
            make.left.right.equalTo(mTitleLabel)
            make.top.equalTo(mTitleLabel.snp.bottom)
            make.height.equalTo(50)
        }
        
        self.addSubview(mErrorLabel)
        mErrorLabel.snp.makeConstraints { make in
            make.left.right.equalTo(mTitleLabel)
            make.top.equalTo(mTextField.snp.bottom).offset(3)
            make.bottom.equalToSuperview()
        }
        
        self.addSubview(mImageView)
        mImageView.snp.makeConstraints { make in
            make.centerY.equalTo(mTextField)
            make.right.equalTo(mTextField).offset(-20)
            make.width.equalTo(12)
            make.height.equalTo(7)
        }
    }

    //MARK: UI
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mTextField: DDTextFieldView = {
        let textField = DDTextFieldView()
        textField.mTextField.isEnabled = false
        textField.mTextField.textColor = ThemeColor.main.color()
        textField.mTextField.placeholder = " Please enter".localString
        return textField
    }()
    
    lazy var mErrorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = ThemeColor.red.color()
        return label
    }()
    
    lazy var mImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "home_audio_arrow"))
        return imageView
    }()
}

extension DDAddressCountryView {
    func _bindView() {
        
        let tap = UITapGestureRecognizer()
        _ = tap.rx.event.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let pop = DDAddressCountryListPop()
            pop.list = self.list
            _ = pop.clickPublish.subscribe(onNext: { [weak self] clickInfo in
                DDPopView.hide()
                guard let self = self else { return }
                if clickInfo.clickType == .confirm, let info = clickInfo.info as? AddressCountryInfo {
                    self.selectedCountry.accept(info)
                }
            })
            DDPopView.show(view: pop, animationType: .bottom)
        })
        self.addGestureRecognizer(tap)
        
        _ = self.selectedCountry.subscribe(onNext: { [weak self] countryInfo in
            guard let self = self else { return }
            if let info = countryInfo {
                self.mTextField.mTextField.text = info.name
            }
        })
    }
}
