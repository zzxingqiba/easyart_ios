//
//  DDPlaceOrderBottomView.swift
//  easyart
//
//  Created by Damon on 2024/9/19.
//

import UIKit
import RxRelay

class DDPlaceOrderBottomView: DDView {
    let clickPublish = PublishRelay<Void>()
    override func createUI() {
        super.createUI()
        self.backgroundColor = UIColor.dd.color(hexValue: 0xffffff)
        self.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.bottom.equalTo(self.snp.centerY).offset(-2)
        }
        
        self.addSubview(mTipLabel)
        mTipLabel.snp.makeConstraints { make in
            make.left.equalTo(mTitleLabel)
            make.top.equalTo(self.snp.centerY).offset(2)
        }
        
        self.addSubview(mPriceLabel)
        mPriceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(mTitleLabel)
            make.left.equalTo(mTitleLabel.snp.right).offset(40)
        }
        
        self.addSubview(mConfirmButton)
        mConfirmButton.snp.makeConstraints { make in
            make.top.bottom.right.equalToSuperview()
            make.width.equalTo(160)
        }
        
        let line = UIView()
        line.backgroundColor = ThemeColor.line.color()
        self.addSubview(line)
        line.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        self._bindView()
    }

    //MARK: UI
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Total(CIF)".localString + ":"
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mTipLabel: UILabel = {
        let label = UILabel()
        label.text = "Including shipping cost".localString
        label.font = .systemFont(ofSize: 12)
        label.textColor = ThemeColor.gray.color()
        return label
    }()
    
    lazy var mPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mConfirmButton: UIButton = {
        let button = UIButton(type: .custom)
        button.isSelected = true
        button.setTitle("Submit order".localString, for: .normal)
        button.setBackgroundImage(UIImage.dd.getImage(color: ThemeColor.black.color()), for: .selected)
        button.setBackgroundImage(UIImage.dd.getImage(color: ThemeColor.gray.color()), for: .normal)
        button.setTitleColor(UIColor.dd.color(hexValue: 0xffffff), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        return button
    }()
}

extension DDPlaceOrderBottomView {
    func _bindView() {
        _ = self.mConfirmButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.clickPublish.accept(())
        })
    }
}
