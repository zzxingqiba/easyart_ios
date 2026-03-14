//
//  DDAddressView.swift
//  easyart
//
//  Created by Damon on 2024/9/18.
//

import UIKit
import SwiftyJSON
import RxRelay

class DDAddressView: DDView {
    let clickPublish = PublishRelay<Void>()
    var mAddressModel: DDAddressModel?
    override func createUI() {
        super.createUI()
        
        self.snp.makeConstraints { make in
            make.height.equalTo(110)
        }
        
        self.addSubview(mAddLabel)
        mAddLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        self.addSubview(mNameLabel)
        mNameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-30)
        }
        
        self.addSubview(mPhoneLabel)
        mPhoneLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(mNameLabel.snp.bottom).offset(8)
            make.right.equalToSuperview().offset(-30)
        }
        
        self.addSubview(mAddressLabel)
        mAddressLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(mPhoneLabel.snp.bottom).offset(8)
            make.right.equalToSuperview().offset(-30)
        }
        
        self.addSubview(mArrowImageView)
        mArrowImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
            make.width.equalTo(7)
            make.height.equalTo(12)
        }
        
        self._bindView()
    }
    
    //MARK: UI
    lazy var mAddLabel: UILabel = {
        let label = UILabel()
        label.text = "+ " + "Please add shipping address".localString
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mNameLabel: DDAddressLabelView = {
        let label = DDAddressLabelView()
        label.isHidden = true
        return label
    }()

    lazy var mPhoneLabel: DDAddressLabelView = {
        let label = DDAddressLabelView()
        label.isHidden = true
        return label
    }()
    
    lazy var mAddressLabel: DDAddressLabelView = {
        let label = DDAddressLabelView()
        label.isHidden = true
        return label
    }()
    
    lazy var mArrowImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "me_jiantou"))
        return imageView
    }()
}

extension DDAddressView {
    func updateUI(address: DDAddressModel) {
        if address.consignee.isEmpty {
            self.mAddressModel = nil
            self.mAddLabel.isHidden = false
            self.mNameLabel.isHidden = true
            self.mPhoneLabel.isHidden = true
            self.mAddressLabel.isHidden = true
        } else {
            self.mAddressModel = address
            self.mAddLabel.isHidden = true
            self.mNameLabel.isHidden = false
            self.mPhoneLabel.isHidden = false
            self.mAddressLabel.isHidden = false
        }
        self.mNameLabel.updateUI(title: "Ship to".localString + ":", des: address.getName())
        self.mPhoneLabel.updateUI(title: "Phone".localString + ":", des: address.phone_number)
        self.mAddressLabel.updateUI(title: "Address".localString + ":", des: address.getFullAddress())
    }
    
    func _bindView() {
        let tap = UITapGestureRecognizer()
        _ = tap.rx.event.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.clickPublish.accept(())
        })
        self.addGestureRecognizer(tap)
    }
}
