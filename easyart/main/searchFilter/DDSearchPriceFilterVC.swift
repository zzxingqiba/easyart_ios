//
//  DDSearchPriceFilterVC.swift
//  easyart
//
//  Created by Damon on 2024/11/26.
//

import UIKit

class DDSearchPriceFilterVC: BaseVC {
    private var searchModel: DDSearchModel
    
    init(searchModel: DDSearchModel) {
        self.searchModel = searchModel
        super.init(bottomPadding: 100)
    }
    
    @MainActor required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._loadData()
    }
    
    override func createUI() {
        super.createUI()
        
        self.mSafeView.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(16)
        }
        
        self.mSafeView.addSubview(mSlider)
        mSlider.snp.makeConstraints { make in
            make.top.equalTo(mTitleLabel.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(50)
        }
        
        self.mSafeView.addSubview(mMinLabel)
        mMinLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(mSlider.snp.bottom)
        }
        
        self.mSafeView.addSubview(mMaxLabel)
        mMaxLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(mSlider.snp.bottom)
        }
        
        self.mSafeView.addSubview(mMinTitleLabel)
        mMinTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(32)
            make.top.equalTo(mMinLabel.snp.bottom).offset(40)
        }
        
        self.mSafeView.addSubview(mMinTextField)
        mMinTextField.snp.makeConstraints { make in
            make.left.equalTo(mMinTitleLabel)
            make.top.equalTo(mMinTitleLabel.snp.bottom).offset(10)
            make.right.equalTo(self.mSafeView.snp.centerX).offset(-10)
            make.height.equalTo(40)
        }
        
        self.mSafeView.addSubview(mMaxTitleLabel)
        mMaxTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(self.mSafeView.snp.centerX).offset(10)
            make.top.equalTo(mMinLabel.snp.bottom).offset(40)
        }
        
        self.mSafeView.addSubview(mMaxTextField)
        mMaxTextField.snp.makeConstraints { make in
            make.left.equalTo(mMaxTitleLabel)
            make.right.equalToSuperview().offset(-32)
            make.top.equalTo(mMinTitleLabel.snp.bottom).offset(10)
            make.height.equalTo(40)
        }
        
        self.mSafeView.addSubview(mSearchFilterBottomView)
        mSearchFilterBottomView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        self._bindView()
    }
    
    @objc private func sliderValueChanged(_ slider: DDRangeSlider) {
        let minValue = Int(slider.lowerValue * 100000)
        let maxValue = Int(slider.upperValue * 100000)
        self._updateMinValue(minValue: minValue)
        self._updateMaxValue(maxValue: maxValue)
    }

    //MARK: UI
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose Your Price Range".localString
        label.font = .systemFont(ofSize: 15)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mSlider: DDRangeSlider = {
        let slider = DDRangeSlider()
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        return slider
    }()
    
    lazy var mMinLabel: UILabel = {
        let label = UILabel()
        label.text = "$0"
        label.font = .systemFont(ofSize: 13)
        label.textColor = ThemeColor.gray.color()
        return label
    }()
    
    lazy var mMaxLabel: UILabel = {
        let label = UILabel()
        label.text = "$100000+"
        label.font = .systemFont(ofSize: 13)
        label.textColor = ThemeColor.gray.color()
        return label
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
        let view = UIView(frame: CGRect(origin: .zero, size: CGSizeMake(46, 40)))
        let label = UILabel(frame: CGRect(origin: .zero, size: CGSizeMake(46, 40)))
        label.text = "$RMB"
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
        label.text = "$RMB"
        label.font = .systemFont(ofSize: 11)
        label.textColor = ThemeColor.gray.color()
        view.addSubview(label)
        textField.rightView = view
        return textField
    }()
    
    lazy var mSearchFilterBottomView: DDSearchFilterBottomView = {
        let view = DDSearchFilterBottomView()
        return view
    }()
}

extension DDSearchPriceFilterVC {
    func _loadData() {
        self._updateMinValue(minValue: self.searchModel.min_price)
        self._updateMaxValue(maxValue: self.searchModel.max_price)
    }
    
    func _updateMinValue(minValue: Int?) {
        if let value = minValue {
            self.mMinTextField.text = "\(value)"
            self.mSlider.lowerValue = CGFloat(min(Float(value)/100000, 1))
        } else {
            self.mMinTextField.text = nil
            self.mSlider.lowerValue = 0
        }
        self.searchModel.min_price = minValue
    }
    
    func _updateMaxValue(maxValue: Int?) {
        if let value = maxValue {
            self.mMaxTextField.text = "\(value)"
            self.mSlider.upperValue = CGFloat(min(Float(value)/100000, 1))
        } else {
            self.mMaxTextField.text = nil
            self.mSlider.upperValue = 1.0
        }
        self.searchModel.max_price = maxValue
    }
    
    func _bindView() {
        _ = self.mSearchFilterBottomView.confirmPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popToRootViewController(animated: true)
        })
        
        _ = self.mSearchFilterBottomView.clearPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.searchModel.min_price = nil
            self.searchModel.max_price = nil
            self._loadData()
        })
        
        _ = self.mMinTextField.rx.controlEvent(.editingDidEnd).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            if let text = self.mMinTextField.text, let min = Int(text) {
                self._updateMinValue(minValue: min)
            } else {
                self._updateMinValue(minValue: nil)
            }
        })
        
        _ = self.mMaxTextField.rx.controlEvent(.editingDidEnd).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            if let text = self.mMaxTextField.text, let min = Int(text) {
                self._updateMaxValue(maxValue: min)
            } else {
                self._updateMaxValue(maxValue: nil)
            }
        })
    }
}

extension DDSearchPriceFilterVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
