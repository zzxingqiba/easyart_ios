//
//  DDGoodsInfoView.swift
//  easyart
//
//  Created by Damon on 2024/9/18.
//

import UIKit
import SwiftyJSON

class DDGoodsInfoView: DDView {
    
    override func createUI() {
        super.createUI()
        let line = UIView()
        line.backgroundColor = ThemeColor.main.color()
        self.addSubview(line)
        line.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(2)
        }
        
//        self.addSubview(mTotalCountLabel)
//        mTotalCountLabel.snp.makeConstraints { make in
//            make.left.equalToSuperview().offset(16)
//            make.top.equalToSuperview().offset(20)
//        }
//        let line2 = UIView()
//        line2.backgroundColor = ThemeColor.line.color()
//        self.addSubview(line2)
//        line2.snp.makeConstraints { make in
//            make.left.right.equalToSuperview()
//            make.top.equalTo(mTotalCountLabel.snp.bottom).offset(10)
//            make.height.equalTo(1)
//        }
        
        self.addSubview(mCoverImageView)
        mCoverImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(line.snp.bottom).offset(16)
            make.width.height.equalTo(100)
        }
        
        self.addSubview(mNameLabel)
        mNameLabel.snp.makeConstraints { make in
            make.left.equalTo(mCoverImageView.snp.right).offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(mCoverImageView).offset(4)
        }
        
        self.addSubview(mAuthorLabel)
        mAuthorLabel.snp.makeConstraints { make in
            make.left.right.equalTo(mNameLabel)
            make.top.equalTo(mNameLabel.snp.bottom).offset(3)
        }
        
        self.addSubview(mPackageLabel)
        mPackageLabel.snp.makeConstraints { make in
            make.left.right.equalTo(mNameLabel)
            make.top.equalTo(mAuthorLabel.snp.bottom).offset(3)
            make.height.greaterThanOrEqualTo(30)
        }
        
        self.addSubview(mPriceLabel)
        mPriceLabel.snp.makeConstraints { make in
            make.left.equalTo(mPackageLabel)
            make.top.equalTo(mPackageLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        self.addSubview(mCountLabel)
        mCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(mPriceLabel)
            make.right.equalToSuperview().offset(-16)
        }
        
        let bottomLine = UIView()
        bottomLine.backgroundColor = ThemeColor.line.color()
        self.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    //MARK: UI
//    lazy var mTotalCountLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Total".localString + " 1 " + "Artwork quantity".localString
//        label.font = .systemFont(ofSize: 14)
//        label.textColor = ThemeColor.gray.color()
//        return label
//    }()
    
    lazy var mCoverImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var mNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mAuthorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mPackageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12)
        label.textColor = ThemeColor.gray.color()
        return label
    }()
    
    lazy var mPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mCountLabel: UILabel = {
        let label = UILabel()
        label.text = "× 1"
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.black.color()
        return label
    }()
}

extension DDGoodsInfoView {
    func updateUI(info: JSON, orderType: Int = 1, model: DDPlaceOrderModel) {
        self.mCoverImageView.kf.setImage(with: URL(string: info["cover_url"].stringValue))
        self.mNameLabel.text = info["name"].stringValue
        self.mAuthorLabel.text = info["artist_name"].stringValue
        if orderType == 1 || orderType == 3 {
            let attributedString = NSMutableAttributedString(string: "$ ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)])
            attributedString.append(NSAttributedString(string: model.skuInfo["pay_price"].stringValue, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
            if (!model.skuInfo["price"].stringValue.isEmpty && model.skuInfo["price"].stringValue != "0") {
                attributedString.append(NSAttributedString(string: model.skuInfo["price"].stringValue, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12), .foregroundColor: ThemeColor.gray.color(), .strikethroughStyle: NSUnderlineStyle.single.rawValue, .strokeColor: ThemeColor.gray.color()]))
            }
            self.mPriceLabel.attributedText = attributedString
        } else {
            //TODO: jpg和png格式
        }
        if orderType == 3 {
            self.mPackageLabel.text = "Work release deposit".localString
        } else if orderType == 2 {
            //TODO: jpg和png格式
        } else if let numberVal = model.numberVal, numberVal > 0 {
            var material = model.skuInfo["material_titles"].stringValue
            if !material.isEmpty {
                material = ", " + material
            }
            var year = ""
            if !model.skuInfo["years"].stringValue.isEmpty {
                year = ", " + model.skuInfo["years"].stringValue
            }
            if model.skuInfo["height"].intValue > 0 {
                self.mPackageLabel.text = info["category_name"].stringValue + material + ", "
                + model.skuInfo["length"].stringValue + " × " + model.skuInfo["width"].stringValue + " × " + model.skuInfo["height"].stringValue + " cm, "
                + "Number".localString + "\(numberVal)" + "/" + model.skuInfo["stock_num"].stringValue + year
            } else {
                self.mPackageLabel.text = info["category_name"].stringValue + material + ", "
                + model.skuInfo["length"].stringValue + " × " + model.skuInfo["width"].stringValue + " cm, "
                + "Number".localString + "\(numberVal)" + "/" + model.skuInfo["stock_num"].stringValue + year
            }
        } else {
            var material = model.skuInfo["material_titles"].stringValue
            if !material.isEmpty {
                material = ", " + material
            }
            var year = ""
            if !model.skuInfo["years"].stringValue.isEmpty {
                year = ", " + model.skuInfo["years"].stringValue
            }
            if model.skuInfo["height"].intValue > 0 {
                self.mPackageLabel.text = info["category_name"].stringValue + material + ", "
                + model.skuInfo["length"].stringValue + " × " + model.skuInfo["width"].stringValue + " × " + model.skuInfo["height"].stringValue + " cm"
                + year
            } else {
                self.mPackageLabel.text = info["category_name"].stringValue + material + ", "
                + model.skuInfo["length"].stringValue + " × " + model.skuInfo["width"].stringValue + " cm"
                + year
            }
        }
    }
}
