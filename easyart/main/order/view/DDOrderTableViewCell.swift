//
//  DDOrderTableViewCell.swift
//  easyart
//
//  Created by Damon on 2024/9/26.
//

import UIKit
import RxRelay
import SwiftyJSON



class DDOrderTableViewCell: DDTableViewCell {
    let clickPublish = PublishRelay<DDOrderButtonTag>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func createUI() {
        super.createUI()
        self.contentView.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(16)
        }
        
        self.contentView.addSubview(mImageView)
        mImageView.snp.makeConstraints { make in
            make.top.equalTo(mTitleLabel.snp.bottom).offset(10)
            make.left.equalTo(mTitleLabel)
            make.width.height.equalTo(100)
        }
        
        self.contentView.addSubview(mAuthorLabel)
        mAuthorLabel.snp.makeConstraints { make in
            make.left.equalTo(mImageView.snp.right).offset(16)
            make.top.equalTo(mImageView).offset(4)
            make.width.equalTo(200)
        }
        
        self.contentView.addSubview(mCategoryLabel)
        mCategoryLabel.snp.makeConstraints { make in
            make.left.right.equalTo(mAuthorLabel)
            make.top.equalTo(mAuthorLabel.snp.bottom).offset(4)
        }
        
        self.contentView.addSubview(mPriceLabel)
        mPriceLabel.snp.makeConstraints { make in
            make.left.right.equalTo(mCategoryLabel)
            make.top.equalTo(mCategoryLabel.snp.bottom).offset(4)
        }
        
        self.contentView.addSubview(mSizeLabel)
        mSizeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(mAuthorLabel)
            make.right.equalToSuperview().offset(-16)
        }
        
        self.contentView.addSubview(mNumberLabel)
        mNumberLabel.snp.makeConstraints { make in
            make.centerY.equalTo(mCategoryLabel)
            make.right.equalTo(mSizeLabel)
        }
        
        self.contentView.addSubview(mCountLabel)
        mCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(mPriceLabel)
            make.right.equalTo(mNumberLabel)
        }
        
        let line = UIView()
        line.backgroundColor = ThemeColor.line.color()
        self.contentView.addSubview(line)
        line.snp.makeConstraints { make in
            make.left.equalTo(mPriceLabel)
            make.right.equalTo(mCountLabel)
            make.top.equalTo(mPriceLabel.snp.bottom).offset(8)
            make.height.equalTo(1)
        }
        
        self.contentView.addSubview(mTotalView)
        mTotalView.snp.makeConstraints { make in
            make.left.right.equalTo(line)
            make.top.equalTo(line.snp.bottom).offset(8)
        }
        
        self.contentView.addSubview(mOrderDetailBottomButton)
        mOrderDetailBottomButton.snp.makeConstraints { make in
            make.right.equalTo(mTotalView)
            make.top.equalTo(mTotalView.snp.bottom).offset(20)
            
        }
        
        self.contentView.addSubview(mStatusLabel)
        mStatusLabel.snp.makeConstraints { make in
            make.top.equalTo(mOrderDetailBottomButton.snp.bottom).offset(14)
            make.left.equalToSuperview().offset(-16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    func updateUI(model: JSON, orderListType: OrderListType) {
        if model["order_type"].intValue == 1 {
            self.mTitleLabel.text = model["name"].stringValue
        } else if model["order_type"].intValue == 2 {
            self.mTitleLabel.text = model["name"].stringValue + "(Ordinary authorization)".localString
        } else {
            self.mTitleLabel.text = ""
        }
        if model["ant_chain"].boolValue {
            self.mTitleLabel.text = model["name"].stringValue + "(Gifted with digital storage certificate)".localString
        }
        if model["order_type"].intValue == 3 {
            if model["status"].intValue == 1 {
                self.mStatusLabel.text = "Waiting for payment of deposit".localString
            } else if model["status"].intValue == 4 {
                self.mStatusLabel.text = "Transaction completed".localString
            } else if model["status"].intValue == 5 {
                self.mStatusLabel.text = "Transaction cancellation".localString
            }
        } else {
            if model["status"].intValue == 1 {
                self.mStatusLabel.text = "Waiting for buyer payment".localString
            } else if model["status"].intValue == 4 {
                self.mStatusLabel.text = "Transaction completed".localString
            } else if model["status"].intValue == 5 {
                self.mStatusLabel.text = "Transaction cancellation".localString
            } else {
                if (orderListType == .sell) {
                    if model["status"].intValue == 2 && model["logistics_status"].intValue == 10 {
                        self.mStatusLabel.text = "The platform is in stock and about to ship".localString
                    } else if model["status"].intValue == 2 {
                        self.mStatusLabel.text = "Waiting for seller to ship".localString
                    } else if model["status"].intValue == 3 {
                        self.mStatusLabel.text = "Waiting for the buyer to receive the goods".localString
                    }
                } else {
                    if model["status"].intValue == 2 && model["logistics_status"].intValue == 9 {
                        self.mStatusLabel.text = "The buyer has made payment, please ship as soon as possible".localString
                    } else if model["status"].intValue == 2 && model["logistics_status"].intValue == 10 {
                        self.mStatusLabel.text = "Shipped, awaiting platform acceptance".localString
                    } else if model["status"].intValue == 3 && model["logistics_status"].intValue == 10 {
                        self.mStatusLabel.text = "Acceptance successful, platform shipped".localString
                    }
                }
            }
        }
        
        mImageView.kf.setImage(with: URL(string: model["photo_url"].stringValue))
        if (model["order_type"].intValue == 3) {
            mAuthorLabel.text = model["name"].stringValue
        } else {
            mAuthorLabel.text = model["artist_name"].stringValue
        }
        if (model["order_type"].intValue == 2) {
            if model["drm_info"]["imgFormat"].intValue == 1 {
                mSizeLabel.text = "JPG"
            } else if model["drm_info"]["imgFormat"].intValue == 1 {
                mSizeLabel.text = "JPG"
            }
        } else if (model["order_type"].intValue == 1) {
            if model["height"].intValue > 0 {
                mSizeLabel.text = model["length"].stringValue + " × " + model["width"].stringValue + " × " + model["height"].stringValue + "cm"
            } else {
                mSizeLabel.text = model["length"].stringValue + " × " + model["width"].stringValue + "cm"
            }
        }
        if (model["order_type"].intValue == 1) {
            mCategoryLabel.text = model["category_name"].stringValue
            if !model["number_val"].stringValue.isEmpty {
                mNumberLabel.text = model["number_val"].stringValue + "/" + model["stock_num"].stringValue
            }
        } else if (model["order_type"].intValue == 2) {
            mCategoryLabel.text = model["drm_info"]["sizePX"].stringValue + "," + model["drm_info"]["sizeCM"].stringValue + "," + model["drm_info"]["dpi"].stringValue
        } else if (model["order_type"].intValue == 3) {
            mCategoryLabel.text = "Work release deposit".localString
        }
        
        if (model["order_type"].intValue == 1 || model["order_type"].intValue == 3) {
            let attributedString = NSMutableAttributedString(string: "$", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)])
            attributedString.append(NSAttributedString(string: model["pay_price"].stringValue, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
            if (!model["price"].stringValue.isEmpty && model["price"].stringValue != "0") {
                attributedString.append(NSAttributedString(string: model["price"].stringValue, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12), .foregroundColor: ThemeColor.gray.color(), .strikethroughStyle: NSUnderlineStyle.single.rawValue, .strokeColor: ThemeColor.gray.color()]))
            }
            self.mPriceLabel.attributedText = attributedString
        } else {
            self.mPriceLabel.text = model["drm_info"]["capacity"].stringValue
        }
        self.mCountLabel.text = "× " + model["goods_num"].stringValue
        
        if model["order_type"].intValue == 1 {
            self.mTotalView.mTitleLabel.text = " Total (excluding shipping costs) ".localString
        } else {
            self.mTotalView.mTitleLabel.text = "Total".localString
        }
        self.mTotalView.mContentLabel.text = "$ " + model["pay_amount"].stringValue
        //按钮
//        self.mLeftButton.isHidden = true
//        self.mRightButton.isHidden = true
        var list = [UIView]()
        if orderListType == .sell {
            if model["status"].intValue == 1 || model["status"].intValue == 2 || model["status"].intValue == 3 {
                list.append(self._createButton(title: "Inquire about artwork".localString, isBlackButton: false, tag: DDOrderButtonTag.contact.rawValue))
            } else if model["status"].intValue == 4 || model["status"].intValue == 5 {
                list.append(self._createButton(title: "Delete order".localString, isBlackButton: false, tag: DDOrderButtonTag.delete.rawValue))
            }
            if model["status"].intValue == 2 && model["logistics_status"].intValue == 9 {
                list.append(self._createButton(title: "Deliver".localString, isBlackButton: true, tag: DDOrderButtonTag.send.rawValue))
            } else if model["status"].intValue == 4 {
                list.append(self._createButton(title: "Inquire about artwork".localString, isBlackButton: true, tag: DDOrderButtonTag.contact.rawValue))
            }
        } else {
            if model["order_type"].intValue == 3 {
                if model["status"].intValue == 1 {
                    list.append(self._createButton(title: "Pay Now".localString, isBlackButton: true, tag: DDOrderButtonTag.pay.rawValue))
                } else if model["status"].intValue == 2 || model["status"].intValue == 3 {
                    list.append(self._createButton(title: "Inquire about artwork".localString, isBlackButton: true, tag: DDOrderButtonTag.contact.rawValue))
                } else if model["status"].intValue == 4 || model["status"].intValue == 5 {
                    list.append(self._createButton(title: "Delete order".localString, isBlackButton: true, tag: DDOrderButtonTag.delete.rawValue))
                }
            } else {
                if model["status"].intValue == 1 {
                    list.append(self._createButton(title: "Cancel order".localString, isBlackButton: false, tag: DDOrderButtonTag.cancel.rawValue))
                } else if model["status"].intValue == 2 || model["status"].intValue == 3 {
                    list.append(self._createButton(title: "Inquire about artwork".localString, isBlackButton: false, tag: DDOrderButtonTag.contact.rawValue))
                } else if model["status"].intValue == 4 && model["order_type"].intValue == 1 {
                    list.append(self._createButton(title: "Inquire about artwork".localString, isBlackButton: false, tag: DDOrderButtonTag.contact.rawValue))
                } else if model["status"].intValue == 5 {
                    list.append(self._createButton(title: "Delete order".localString, isBlackButton: false, tag: DDOrderButtonTag.delete.rawValue))
                }
                //右侧按钮
                if model["status"].intValue == 1 {
                    list.append(self._createButton(title: "Pay Now".localString, isBlackButton: true, tag: DDOrderButtonTag.pay.rawValue))
                } else if model["status"].intValue == 3 {
                    list.append(self._createButton(title: "Confirm receipt".localString, isBlackButton: true, tag: DDOrderButtonTag.recieve.rawValue))
                } else if model["status"].intValue == 4 && model["order_type"].intValue == 2 {
                    list.append(self._createButton(title: "View digital copyright".localString, isBlackButton: true, tag: DDOrderButtonTag.copyright.rawValue))
                }
            }
        }
        self.mOrderDetailBottomButton.updateUI(views: list)
    }
    
    //MARK: UI
    lazy var mImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mStatusLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 12)
        label.textColor = ThemeColor.main.color()
        return label
    }()
    
    lazy var mAuthorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = ThemeColor.gray.color()
        return label
    }()
    
    lazy var mCategoryLabel: UILabel = {
        let label = UILabel()
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
    
    lazy var mSizeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = ThemeColor.gray.color()
        return label
    }()
    
    lazy var mNumberLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = ThemeColor.gray.color()
        return label
    }()
    
    lazy var mCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mTotalView: DDSpaceBetweenView = {
        let view = DDSpaceBetweenView()
        view.mTitleLabel.font = .systemFont(ofSize: 10)
        return view
    }()
    
//    lazy var mLeftButton: DDButton = {
//        let button = DDButton()
//        button.contentType = .contentFit(padding: UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16), gap: 0)
//        button.imageSize = CGSize(width: 1, height: 20)
//        button.mTitleLabel.text = "Cancel order".localString
//        button.mTitleLabel.font = .systemFont(ofSize: 14)
//        button.mTitleLabel.textColor = ThemeColor.black.color()
//        button.layer.borderWidth = 1
//        button.layer.borderColor = ThemeColor.black.color().cgColor
//        return button
//    }()
//    
//    lazy var mRightButton: DDButton = {
//        let button = DDButton()
//        button.contentType = .contentFit(padding: UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16), gap: 0)
//        button.imageSize = CGSize(width: 1, height: 20)
//        button.mTitleLabel.text = "Pay Now".localString
//        button.mTitleLabel.font = .systemFont(ofSize: 14)
//        button.mTitleLabel.textColor = UIColor.dd.color(hexValue: 0xffffff)
//        button.backgroundColor = ThemeColor.black.color()
//        button.layer.borderWidth = 1
//        button.layer.borderColor = ThemeColor.black.color().cgColor
//        return button
//    }()
    
    lazy var mOrderDetailBottomButton: OrderDetailBottomButton = {
        let view = OrderDetailBottomButton()
        view.spacing = 15
        return view
    }()
}

extension DDOrderTableViewCell {
    @objc func _buttonClick(sender: DDButton) {
        self.clickPublish.accept(DDOrderButtonTag(rawValue: sender.tag) ?? .contact)
    }
    
    func _createButton(title: String, isBlackButton: Bool, tag: Int) -> DDButton {
        let button = DDButton()
        button.imageSize = CGSize(width: 1, height: 20)
        button.contentType = .contentFit(padding: UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16), gap: 0)
        button.mTitleLabel.text = title
        button.tag = tag
//        button.setTitle(title, for: .normal)
        if isBlackButton {
            button.backgroundColor = ThemeColor.black.color()
//            button.setTitleColor(UIColor.dd.color(hexValue: 0xffffff), for: .normal)
            button.mTitleLabel.textColor = UIColor.dd.color(hexValue: 0xffffff)
        } else {
            button.backgroundColor = UIColor.dd.color(hexValue: 0xffffff)
//            button.setTitleColor(ThemeColor.black.color(), for: .normal)
            button.mTitleLabel.textColor = ThemeColor.black.color()
        }
        button.layer.borderWidth = 1
        button.layer.borderColor = ThemeColor.black.color().cgColor
//        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.mTitleLabel.font = .systemFont(ofSize: 12)
        button.addTarget(self, action: #selector(_buttonClick(sender:)), for: .touchUpInside)
        return button
    }
}
