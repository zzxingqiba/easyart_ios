//
//  OrderInfoView.swift
//  easyart
//
//  Created by Damon on 2024/9/30.
//

import UIKit
import SwiftyJSON
import SnapKit
import HDHUD

class OrderInfoView: DDView {
    private var json: JSON = JSON()
    private var bottomConstraint: Constraint?
    
    override func createUI() {
        super.createUI()
        self.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(16)
        }
        
        self.addSubview(mNumberLabel)
        mNumberLabel.snp.makeConstraints { make in
            make.left.equalTo(mTitleLabel)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(mTitleLabel.snp.bottom).offset(10)
            make.height.equalTo(24)
        }
        
        self.addSubview(mTimeLabel)
        mTimeLabel.snp.makeConstraints { make in
            make.left.equalTo(mNumberLabel)
            make.right.equalTo(mNumberLabel)
            make.top.equalTo(mNumberLabel.snp.bottom)
            make.height.equalTo(24)
        }
        
        self.snp.makeConstraints { make in
            self.bottomConstraint = make.bottom.equalTo(mTimeLabel).constraint
        }
        
        self.addSubview(mPayTimeLabel)
        mPayTimeLabel.snp.makeConstraints { make in
            make.left.equalTo(mNumberLabel)
            make.right.equalTo(mNumberLabel)
            make.top.equalTo(mTimeLabel.snp.bottom)
            make.height.equalTo(24)
        }
        
        self.addSubview(mCloseTimeLabel)
        mCloseTimeLabel.snp.makeConstraints { make in
            make.left.equalTo(mNumberLabel)
            make.right.equalTo(mNumberLabel)
            make.top.equalTo(mPayTimeLabel.snp.bottom)
            make.height.equalTo(24)
        }
        
        self.addSubview(mSendTimeLabel)
        mSendTimeLabel.snp.makeConstraints { make in
            make.left.equalTo(mNumberLabel)
            make.right.equalTo(mNumberLabel)
            make.top.equalTo(mCloseTimeLabel.snp.bottom)
            make.height.equalTo(24)
        }
        
        self.addSubview(mCompleteTimeLabel)
        mCompleteTimeLabel.snp.makeConstraints { make in
            make.left.equalTo(mNumberLabel)
            make.right.equalTo(mNumberLabel)
            make.top.equalTo(mSendTimeLabel.snp.bottom)
            make.height.equalTo(24)
        }
        
        self._bindView()
    }
    
    //MARK: UI
    lazy var mTitleLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.text = "Order information:".localString
        tLabel.textColor = ThemeColor.black.color()
        tLabel.font = .systemFont(ofSize: 14)
        return tLabel
    }()

    lazy var mNumberLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.textColor = ThemeColor.gray.color()
        tLabel.font = .systemFont(ofSize: 14)
        tLabel.isUserInteractionEnabled = true
        return tLabel
    }()
    
    lazy var mTimeLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.textColor = ThemeColor.gray.color()
        tLabel.font = .systemFont(ofSize: 14)
        return tLabel
    }()
    
    lazy var mCloseTimeLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.textColor = ThemeColor.gray.color()
        tLabel.font = .systemFont(ofSize: 14)
        return tLabel
    }()
    
    lazy var mPayTimeLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.textColor = ThemeColor.gray.color()
        tLabel.font = .systemFont(ofSize: 14)
        return tLabel
    }()
    
    lazy var mSendTimeLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.textColor = ThemeColor.gray.color()
        tLabel.font = .systemFont(ofSize: 14)
        return tLabel
    }()
    
    lazy var mCompleteTimeLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.textColor = ThemeColor.gray.color()
        tLabel.font = .systemFont(ofSize: 14)
        return tLabel
    }()
}

extension OrderInfoView {
    func updateUI(json: JSON) {
        self.json = json
        let attributed = NSMutableAttributedString(string: "Order number".localString + ": " + json["order_id"].stringValue)
        attributed.append(NSMutableAttributedString(string: "   "))
        let copyAttributed = NSAttributedString(string: "Copy".localString, attributes: [NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue, .underlineColor: ThemeColor.main.color(), .foregroundColor: ThemeColor.main.color()])
        attributed.append(copyAttributed)
        self.mNumberLabel.attributedText = attributed
        self.mTimeLabel.text = "Order time".localString + ": " + json["create_time"].stringValue
        var bottomView = self.mTimeLabel
        if (!json["pay_time"].stringValue.isEmpty) {
            self.mPayTimeLabel.text = "Payment time".localString + ": " +  json["pay_time"].stringValue
            bottomView = self.mPayTimeLabel
            self.mPayTimeLabel.snp.updateConstraints { make in
                make.height.equalTo(24)
            }
        } else {
            self.mPayTimeLabel.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
        }
        if (!json["send_time"].stringValue.isEmpty) {
            self.mSendTimeLabel.text = "Delivery time".localString + ": " + json["send_time"].stringValue
            bottomView = self.mSendTimeLabel
            self.mSendTimeLabel.snp.updateConstraints { make in
                make.height.equalTo(24)
            }
        } else {
            self.mSendTimeLabel.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
        }
        if (!json["end_time"].stringValue.isEmpty) {
            self.mCompleteTimeLabel.text = "Order complete".localString + ": " + json["end_time"].stringValue
            bottomView = self.mCompleteTimeLabel
            self.mCompleteTimeLabel.snp.updateConstraints { make in
                make.height.equalTo(24)
            }
        } else {
            self.mCompleteTimeLabel.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
        }
        if (!json["close_time"].stringValue.isEmpty) {
            self.mCloseTimeLabel.text = "Closing time".localString + ": " + json["close_time"].stringValue
            bottomView = self.mCloseTimeLabel
            self.mCloseTimeLabel.snp.updateConstraints { make in
                make.height.equalTo(24)
            }
        } else {
            self.mCloseTimeLabel.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
        }
        //状态
        self.bottomConstraint?.deactivate()
        self.snp.makeConstraints { make in
            self.bottomConstraint = make.bottom.equalTo(bottomView).constraint
        }
    }
}

extension OrderInfoView {
    func _bindView() {
        let tap = UITapGestureRecognizer()
        _ = tap.rx.event.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            UIPasteboard.general.string = self.json["order_id"].stringValue
            HDHUD.show("Successful", icon: .success)
        })
        mNumberLabel.addGestureRecognizer(tap)
    }
}
