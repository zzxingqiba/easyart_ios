//
//  OrderGoodsInfoView.swift
//  easyart
//
//  Created by Damon on 2024/9/30.
//

import UIKit
import SwiftyJSON

class OrderGoodsInfoView: DDView {

    override func createUI() {
        super.createUI()
        self.addSubview(mCoverImageView)
        mCoverImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(16)
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
            make.top.equalTo(mAuthorLabel.snp.bottom).offset(5)
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
    }
    
    //MARK: UI
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
        label.text = "x 1"
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.black.color()
        return label
    }()

}

extension OrderGoodsInfoView {
    func updateUI(orderInfo: JSON) {
        self.mCoverImageView.kf.setImage(with: URL(string: orderInfo["photo_url"].stringValue))
        self.mNameLabel.text = orderInfo["name"].stringValue
        self.mAuthorLabel.text = orderInfo["artist_name"].stringValue
        let orderType = orderInfo["order_type"].intValue
        if orderType == 1 || orderType == 3 {
            let attributedString = NSMutableAttributedString(string: "$ ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)])
            attributedString.append(NSAttributedString(string: orderInfo["pay_price"].stringValue, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
            if (!orderInfo["price"].stringValue.isEmpty && orderInfo["price"].stringValue != "0") {
                attributedString.append(NSAttributedString(string: orderInfo["price"].stringValue, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12), .foregroundColor: ThemeColor.gray.color(), .strikethroughStyle: NSUnderlineStyle.single.rawValue, .strokeColor: ThemeColor.gray.color()]))
            }
            self.mPriceLabel.attributedText = attributedString
        } else {
            //TODO: jpg和png格式
        }
        if orderType == 3 {
            self.mPackageLabel.text = "Work release deposit".localString
        } else if orderType == 2 {
            //TODO: jpg和png格式
        } else if orderInfo["number_val"].intValue > 0 {
            var material = orderInfo["material_titles"].stringValue
            if !material.isEmpty {
                material = ", " + material
            }
            var year = ""
            if !orderInfo["years"].stringValue.isEmpty {
                year = ", " + orderInfo["years"].stringValue
            }
            if orderInfo["height"].intValue > 0 {
                self.mPackageLabel.text = orderInfo["category_name"].stringValue + material + ", "
                + orderInfo["length"].stringValue + " × " + orderInfo["width"].stringValue + " × " + orderInfo["height"].stringValue + " cm, "
                + "Number".localString + orderInfo["number_val"].stringValue + "/" + orderInfo["stock_num"].stringValue + year
            } else {
                self.mPackageLabel.text = orderInfo["category_name"].stringValue + material + ", "
                + orderInfo["length"].stringValue + " × " + orderInfo["width"].stringValue + " cm, "
                + "Number".localString + orderInfo["number_val"].stringValue + "/" + orderInfo["stock_num"].stringValue + year
            }
        } else {
            var material = orderInfo["material_titles"].stringValue
            if !material.isEmpty {
                material = ", " + material
            }
            var year = ""
            if !orderInfo["years"].stringValue.isEmpty {
                year = ", " + orderInfo["years"].stringValue
            }
            if orderInfo["height"].intValue > 0 {
                self.mPackageLabel.text = orderInfo["category_name"].stringValue + material + ", "
                + orderInfo["length"].stringValue + " × " + orderInfo["width"].stringValue + " × " + orderInfo["height"].stringValue + " cm"
                + year
            } else {
                self.mPackageLabel.text = orderInfo["category_name"].stringValue + material + ", "
                + orderInfo["length"].stringValue + " × " + orderInfo["width"].stringValue + " cm"
                + year
            }
        }
    }
}
