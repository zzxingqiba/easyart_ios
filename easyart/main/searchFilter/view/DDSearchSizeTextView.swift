//
//  DDSearchSizeTextView.swift
//  easyart
//
//  Created by Damon on 2024/11/28.
//

import UIKit
import RxRelay

class DDSearchSizeTextView: DDView {
    let textChangePublish = PublishRelay<(Int, Int)?>()
    var isSelected = false {
        didSet {
            mIconImageView.image = isSelected ? UIImage(named: "cell_selected_blue") : UIImage(named: "icon_normal_solid")
        }
    }
    
    override func createUI() {
        super.createUI()
        
        self.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(30)
        }
        
        self.addSubview(mIconImageView)
        mIconImageView.snp.makeConstraints { make in
            make.centerY.equalTo(mTitleLabel)
            make.right.equalToSuperview()
            make.width.height.equalTo(15)
        }
        
        self.addSubview(mMinTitleLabel)
        mMinTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(14)
            make.top.equalTo(mTitleLabel.snp.bottom).offset(35)
        }
        
        self.addSubview(mMinTextField)
        mMinTextField.snp.makeConstraints { make in
            make.left.equalTo(mMinTitleLabel)
            make.top.equalTo(mMinTitleLabel.snp.bottom).offset(10)
            make.right.equalTo(self.snp.centerX).offset(-10)
            make.height.equalTo(40)
        }
        
        self.addSubview(mMaxTitleLabel)
        mMaxTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(self.snp.centerX).offset(10)
            make.top.equalTo(mTitleLabel.snp.bottom).offset(35)
        }
        
        self.addSubview(mMaxTextField)
        mMaxTextField.snp.makeConstraints { make in
            make.left.equalTo(mMaxTitleLabel)
            make.right.equalToSuperview().offset(-14)
            make.top.equalTo(mMinTitleLabel.snp.bottom).offset(10)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        self._bindView()
    }
    
    //MARK: UI
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Custom Size".localString
        label.font = .systemFont(ofSize: 15)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mIconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: ""))
        return imageView
    }()
    
    lazy var mMinTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Min".localString
        label.font = .systemFont(ofSize: 13)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mMaxTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Max".localString
        label.font = .systemFont(ofSize: 13)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mMinTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.font = .systemFont(ofSize: 15)
        textField.textColor = ThemeColor.black.color()
        textField.keyboardType = .numberPad
        textField.layer.borderColor = UIColor.dd.color(hexValue: 0xE6E6E6).cgColor
        textField.layer.borderWidth = 0.5
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(origin: .zero, size: CGSizeMake(10, 40)))
        textField.rightViewMode = .always
        let view = UIView(frame: CGRect(origin: .zero, size: CGSizeMake(23, 40)))
        let label = UILabel(frame: CGRect(origin: .zero, size: CGSizeMake(23, 40)))
        label.text = "CM"
        label.font = .systemFont(ofSize: 11)
        label.textColor = ThemeColor.gray.color()
        view.addSubview(label)
        textField.rightView = view
        return textField
    }()
    
    lazy var mMaxTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.font = .systemFont(ofSize: 15)
        textField.textColor = ThemeColor.black.color()
        textField.keyboardType = .numberPad
        textField.layer.borderColor = UIColor.dd.color(hexValue: 0xE6E6E6).cgColor
        textField.layer.borderWidth = 0.5
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(origin: .zero, size: CGSizeMake(10, 40)))
        textField.rightViewMode = .always
        let view = UIView(frame: CGRect(origin: .zero, size: CGSizeMake(46, 40)))
        let label = UILabel(frame: CGRect(origin: .zero, size: CGSizeMake(46, 40)))
        label.text = "CM"
        label.font = .systemFont(ofSize: 11)
        label.textColor = ThemeColor.gray.color()
        view.addSubview(label)
        textField.rightView = view
        return textField
    }()

}

extension DDSearchSizeTextView {
    func _bindView() {
        _ = self.mMinTextField.rx.controlEvent(.editingDidEnd).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self._initText()
            let min = Int(self.mMinTextField.text ?? "0") ?? 0
            let max = Int(self.mMaxTextField.text ?? "0") ?? 100
            self.textChangePublish.accept((min, max))
        })
        
        _ = self.mMaxTextField.rx.controlEvent(.editingDidEnd).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self._initText()
            let min = Int(self.mMinTextField.text ?? "0") ?? 0
            let max = Int(self.mMaxTextField.text ?? "0") ?? 100
            self.textChangePublish.accept((min, max))
        })
        
        let tap = UITapGestureRecognizer()
        _ = tap.rx.event.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.isSelected = !self.isSelected
            if self.isSelected == true {
                self._initText()
                let min = Int(self.mMinTextField.text ?? "0") ?? 0
                let max = Int(self.mMaxTextField.text ?? "0") ?? 100
                self.textChangePublish.accept((min, max))
            } else {
                self.mMinTextField.text = nil
                self.mMaxTextField.text = nil
                self.textChangePublish.accept(nil)
            }
        })
        self.addGestureRecognizer(tap)
    }
    
    func _initText() {
        if !String.isAvailable(self.mMinTextField.text) {
            self.mMinTextField.text = "0"
        }
        if !String.isAvailable(self.mMaxTextField.text) {
            self.mMaxTextField.text = "100"
        }
    }
}

extension DDSearchSizeTextView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
