//
//  DDAddressLabelView.swift
//  easyart
//
//  Created by Damon on 2024/10/28.
//

import UIKit

class DDAddressLabelView: DDView {

    override func createUI() {
        super.createUI()
        self.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(114)
        }
        
        self.addSubview(mDesLabel)
        mDesLabel.snp.makeConstraints { make in
            make.left.equalTo(mTitleLabel.snp.right)
            make.top.equalTo(mTitleLabel)
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
    func updateUI(title: String, des: String) {
        self.mTitleLabel.text = title
        self.mDesLabel.text = des
    }
    
    //MARK: UI
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mDesLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.black.color()
        return label
    }()

}
