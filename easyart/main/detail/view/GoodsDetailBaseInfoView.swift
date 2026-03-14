//
//  GoodsDetailBaseInfoView.swift
//  easyart
//
//  Created by Damon on 2024/11/15.
//

import UIKit
import SwiftyJSON
import RxRelay

class GoodsDetailBaseInfoView: DDView {
    let authorClickPublish = PublishRelay<Void>()
    let audioClickPublish = PublishRelay<Void>()
    private var goodsInfo = JSON()
    
    override func createUI() {
        super.createUI()
        self.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        self.addSubview(mAuthorLabel)
        mAuthorLabel.snp.makeConstraints { make in
            make.top.equalTo(mTitleLabel.snp.bottom).offset(5)
            make.left.equalTo(mTitleLabel)
        }
        
//        let line = UIView()
//        line.backgroundColor = ThemeColor.gray.color()
//        self.addSubview(line)
//        line.snp.makeConstraints { make in
//            make.centerY.equalTo(mAuthorLabel)
//            make.left.equalTo(mAuthorLabel.snp.right).offset(10)
//            make.width.equalTo(1)
//            make.height.equalTo(6)
//        }
//        
//        self.addSubview(mAuthorAboutLabel)
//        mAuthorAboutLabel.snp.makeConstraints { make in
//            make.centerY.equalTo(mAuthorLabel)
//            make.left.equalTo(line.snp.right).offset(10)
//        }
        
        self.addSubview(mSizeLabel)
        mSizeLabel.snp.makeConstraints { make in
            make.top.equalTo(mAuthorLabel.snp.bottom).offset(17)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        self.addSubview(mAudioButton)
        mAudioButton.snp.makeConstraints { make in
            make.centerY.equalTo(mTitleLabel.snp.top)
            make.right.equalToSuperview().offset(-20)
            make.width.height.equalTo(30)
        }
        
        self._bindView()
        
    }

    //MARK: UI
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mAuthorLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.font = .systemFont(ofSize: 15)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
//    lazy var mAuthorAboutLabel: UILabel = {
//        let label = UILabel()
//        label.isUserInteractionEnabled = true
//        label.attributedText = NSAttributedString(string: "About".localString, attributes: [NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue, .underlineColor: ThemeColor.gray.color()])
//        label.font = .systemFont(ofSize: 13)
//        label.textColor = ThemeColor.gray.color()
//        return label
//    }()
    
    lazy var mSizeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 13)
        label.textColor = ThemeColor.gray.color()
        return label
    }()
    
    lazy var mAudioButton: UIButton = {
        let button = UIButton(type: .custom)
        button.isHidden = true
        button.setImage(UIImage(named: "home_audio_icon"), for: .normal)
        return button
    }()
}

extension GoodsDetailBaseInfoView {
    func _bindView() {
        _ = self.mAudioButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.audioClickPublish.accept(())
        })
        
        let tap = UITapGestureRecognizer()
        _ = tap.rx.event.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.authorClickPublish.accept(())
        })
        self.mAuthorLabel.addGestureRecognizer(tap)
    }
}

extension GoodsDetailBaseInfoView {
    func updateUI(goodsInfo: JSON, selectedSKU: JSON, singleSKU: Bool) {
        //
        var title = goodsInfo["name"].stringValue
        if !selectedSKU["years"].stringValue.isEmpty && selectedSKU["years"].stringValue != "0" {
            title = title + ", " +  selectedSKU["years"].stringValue
        }
        self.mTitleLabel.text = title
        
        self.goodsInfo = goodsInfo
        self.mAuthorLabel.attributedText = NSAttributedString(string: goodsInfo["artist_name"].stringValue, attributes: [NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue, .underlineColor: ThemeColor.black.color()])
        if singleSKU {
            let sku = selectedSKU
            var text = goodsInfo["category_name"].stringValue
            if !sku["material_titles"].stringValue.isEmpty {
                text = text + "\n" + sku["material_titles"].stringValue
            }
            //宽高
            var format = ""
            
            if sku["height"].intValue > 0 {
                format = "\n" + "Format".localString + " " + "\(sku["length"].intValue)" + " × " + "\(sku["width"].intValue)" + " × " + "\(sku["height"].intValue)" + " cm"
            } else {
                format = "\n" + "Format".localString + " " + "\(sku["length"].intValue)" + " × " + "\(sku["width"].intValue)" + " cm"
            }
            if sku["weight"].intValue > 0 {
                format = format + "\n" + "Weight".localString + " " + "\(sku["weight"].intValue)" + " kg"
            }
            //装潢尺寸
            var packageSize = ""
            if (sku["mount_type"].intValue == 2) {
                if sku["height_mount"].intValue > 0 {
                    packageSize = ", " + "Frame".localString + " " + "\(sku["length_mount"].intValue)" + " × " + "\(sku["width_mount"].intValue)" + " × " + "\(sku["height_mount"].intValue)" + " cm"
                } else {
                    packageSize = ", " + "Frame".localString + " " + "\(sku["length_mount"].intValue)" + " × " + "\(sku["width_mount"].intValue)" + " cm"
                }
            }
            //印数
            var numberStr = ""
            if (!sku["number_title"].stringValue.isEmpty) {
                numberStr = "\n" + "Edition of".localString + " " + "\(sku["stock_num"].stringValue)"
            }
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 1.3
            let attributed = NSAttributedString(string: text + format + packageSize + numberStr, attributes: [NSAttributedString.Key.paragraphStyle : paragraphStyle])
            self.mSizeLabel.attributedText = attributed
        } else {
            var text = goodsInfo["category_name"].stringValue
            if !selectedSKU["material_titles"].stringValue.isEmpty {
                text = text + "\n" + selectedSKU["material_titles"].stringValue
            }
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 1.3
            let attributed = NSAttributedString(string: text, attributes: [NSAttributedString.Key.paragraphStyle : paragraphStyle])
            self.mSizeLabel.attributedText = attributed
        }
    }
}
