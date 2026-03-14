//
//  AddressTableViewCell.swift
//  easyart
//
//  Created by Damon on 2024/9/19.
//

import UIKit
import RxRelay

class AddressTableViewCell: DDTableViewCell {
    let clickPublish = PublishRelay<Void>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if (selected) {
            mContentView.layer.borderColor = ThemeColor.main.color().cgColor
        } else {
            mContentView.layer.borderColor = ThemeColor.gray.color().cgColor
        }
    }
    
    override func createUI() {
        super.createUI()
        self.contentView.addSubview(mContentView)
        mContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mContentView.addSubview(mDefaultLabel)
        mDefaultLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(20)
        }
        
        mContentView.addSubview(mNameLabel)
        mNameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(mDefaultLabel.snp.bottom).offset(16)
        }
        mContentView.addSubview(mPhoneLabel)
        mPhoneLabel.snp.makeConstraints { make in
            make.left.equalTo(mNameLabel)
            make.top.equalTo(mNameLabel.snp.bottom).offset(8)
        }
        
        mContentView.addSubview(mProviceLabel)
        mProviceLabel.snp.makeConstraints { make in
            make.left.equalTo(mNameLabel)
            make.right.equalToSuperview().offset(-100)
            make.top.equalTo(mPhoneLabel.snp.bottom).offset(8)
        }
        
        mContentView.addSubview(mAddressLabel)
        mAddressLabel.snp.makeConstraints { make in
            make.left.right.equalTo(mProviceLabel)
            make.top.equalTo(mProviceLabel.snp.bottom).offset(8)
        }
        
        mContentView.addSubview(mAddressLabel2)
        mAddressLabel2.snp.makeConstraints { make in
            make.left.right.equalTo(mProviceLabel)
            make.top.equalTo(mAddressLabel.snp.bottom).offset(8)
        }
        
        mContentView.addSubview(mCodeLabel)
        mCodeLabel.snp.makeConstraints { make in
            make.left.right.equalTo(mProviceLabel)
            make.top.equalTo(mAddressLabel2.snp.bottom).offset(8)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        mContentView.addSubview(mEditButton)
        mEditButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(100)
        }
        
        let line = UIView()
        line.backgroundColor = UIColor.dd.color(hexValue: 0xE6E6E6)
        mContentView.addSubview(line)
        line.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(1)
            make.height.equalTo(40)
            make.right.equalTo(mEditButton.snp.left).offset(-10)
        }
        
        self._bindView()
    }

    //MARK: UI
    lazy var mContentView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1.5
        view.layer.borderColor = ThemeColor.gray.color().cgColor
        
        return view
    }()
    
    lazy var mDefaultLabel: PaddingLabel = {
        let label = PaddingLabel(withInsets: 2, 2, 5, 5)
        label.isHidden = true
        label.text = "Default".localString
        label.font = .systemFont(ofSize: 13)
        label.backgroundColor = ThemeColor.main.color()
        label.textColor = UIColor.dd.color(hexValue: 0xffffff)
        return label
    }()
    
    lazy var mNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mPhoneLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mProviceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mAddressLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 13)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mAddressLabel2: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 13)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mCodeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mEditButton: DDButton = {
        let button = DDButton(imagePosition: .none)
        button.contentType = .contentFit(padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20), gap: 0)
        button.mTitleLabel.text = "Edit".localString
        button.mTitleLabel.textColor = UIColor.dd.color(hexValue: 0xA39FAC)
        button.mTitleLabel.font = .systemFont(ofSize: 12)
        return button
    }()
}

extension AddressTableViewCell {
    func updateUI(model: DDAddressModel) {
        if model.is_default {
            mNameLabel.snp.updateConstraints { make in
                make.top.equalTo(mDefaultLabel.snp.bottom).offset(16)
            }
        } else {
            mNameLabel.snp.updateConstraints { make in
                make.top.equalTo(mDefaultLabel.snp.bottom).offset(-20)
            }
        }
        self.mDefaultLabel.isHidden = !model.is_default
        mNameLabel.text = model.getName()
        mPhoneLabel.text = model.phone_number
        mProviceLabel.text = model.country_name + " " + model.province + " " + model.city
        mAddressLabel.text = model.area
        mAddressLabel2.text = model.full_address
        mCodeLabel.text = "ZIP code".localString + " " + model.zip_code
    }
    
    func _bindView() {
        _ = self.mEditButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.clickPublish.accept(())
        })
    }
}
