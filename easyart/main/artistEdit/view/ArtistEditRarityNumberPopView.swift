//
//  ArtistEditRarityNumberPopView.swift
//  easyart
//
//  Created by Damon on 2025/1/20.
//

import UIKit
import RxRelay
import DDUtils

class ArtistEditRarityNumberPopView: DDView {
    private var numberList: [Int] = []
    private var selectedNumber: Int = 0
    let clickPublish = PublishRelay<DDPopButtonClickInfo>()
    private var count: Int
    
    init(count: Int) {
        self.count = count
        super.init(frame: .zero)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createUI() {
        super.createUI()
        self.backgroundColor = UIColor.dd.color(hexValue: 0xffffff)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 7
        self.snp.makeConstraints { make in
            make.width.equalTo(UIScreenWidth)
            make.height.equalTo(380)
        }

        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(20)
        }

        let lineView = UIView()
        lineView.backgroundColor = UIColor.dd.color(hexValue: 0xEEEEEE)
        self.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(14)
            make.height.equalTo(0.5)
        }

        self.addSubview(mPicker)
        mPicker.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(13)
            make.right.equalToSuperview().offset(-13)
            make.top.equalTo(lineView.snp.bottom).offset(20)
            make.bottom.equalToSuperview().offset(-62)
        }

        self.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.left.bottom.equalToSuperview()
            make.right.equalTo(self.snp.centerX)
            make.top.equalTo(mPicker.snp.bottom).offset(17)
        }

        self.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview()
            make.left.equalTo(self.snp.centerX)
            make.top.equalTo(mPicker.snp.bottom).offset(17)
        }
        
        self._bindView()
        self._loadData()
    }
    
    //MARK: UI
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = UIColor.dd.color(hexValue: 0x000000)
        label.text = "Edition".localString
        return label
    }()

    lazy var mPicker: UIPickerView = {
        let picker = UIPickerView()
//        picker.layer.borderColor = UIColor.dd.color(hexValue: 0xFCDCE0, alpha: 0.8).cgColor
//        picker.layer.cornerRadius = 4
//        picker.layer.borderWidth = 0.5
        picker.tag = 3
        picker.dataSource = self
        picker.delegate = self
        return picker
    }()

    lazy var cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = ThemeColor.black.color()
        button.layer.borderWidth = 1.0
        button.layer.borderColor = ThemeColor.line.color().cgColor
        button.setTitleColor(ThemeColor.white.color(), for: .normal)
        button.setTitle("Cancel".localString, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        return button
    }()

    lazy var confirmButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = ThemeColor.main.color()
        button.setTitleColor(ThemeColor.white.color(), for: .normal)
        button.setTitle("Confirm".localString, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        return button
    }()

}

extension ArtistEditRarityNumberPopView {
    func _loadData() {
        for i in 0..<self.count {
            numberList.append(i + 1)
        }
        self.mPicker.reloadAllComponents()
    }
    
    func _bindView() {
        _ = self.cancelButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.clickPublish.accept(.init(clickType: .cancel, info: nil))
        })
        
        _ = self.confirmButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.clickPublish.accept(.init(clickType: .confirm, info: self.selectedNumber))
        })
    }
}

extension ArtistEditRarityNumberPopView: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numberList.count
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 33
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let value = numberList[row]
        
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = UIColor.dd.color(hexValue: 0x333333)
        label.text = String(format: "%03d", value)
        return label
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedNumber = numberList[row]
    }
}
