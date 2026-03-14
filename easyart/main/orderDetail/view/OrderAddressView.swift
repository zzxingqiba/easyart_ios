//
//  OrderAddressView.swift
//  easyart
//
//  Created by Damon on 2024/9/30.
//

import UIKit

class OrderAddressView: DDView {
    
    override func createUI() {
        super.createUI()
        self.backgroundColor = UIColor.dd.color(hexValue: 0xffffff)
        self.addSubview(mConsigneeLabel)
        mConsigneeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(16)
        }
        
        self.addSubview(mPhoneLabel)
        mPhoneLabel.snp.makeConstraints { make in
            make.left.right.equalTo(mConsigneeLabel)
            make.top.equalTo(mConsigneeLabel.snp.bottom).offset(10)
        }
        
        self.addSubview(mAddressLabel)
        mAddressLabel.snp.makeConstraints { make in
            make.left.right.equalTo(mPhoneLabel)
            make.top.equalTo(mPhoneLabel.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-16)
        }
    }

    //MARK: UI
    lazy var mConsigneeLabel: DDAddressLabelView = {
        let tLabel = DDAddressLabelView()
        return tLabel
    }()
    
    lazy var mPhoneLabel: DDAddressLabelView = {
        let tLabel = DDAddressLabelView()
        return tLabel
    }()
    
    lazy var mAddressLabel: DDAddressLabelView = {
        let tLabel = DDAddressLabelView()
        return tLabel
    }()

}

extension OrderAddressView {
    func updateUI(model: DDAddressModel) {
        self.mConsigneeLabel.updateUI(title: "Ship to".localString + ":", des: model.getName())
        self.mPhoneLabel.updateUI(title: "Phone".localString + ":", des: model.phone_number)
        self.mAddressLabel.updateUI(title: "Address".localString + ":", des: model.getFullAddress())
    }
}
