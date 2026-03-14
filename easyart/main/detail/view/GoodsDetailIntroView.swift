//
//  GoodsDetailIntroView.swift
//  easyart
//
//  Created by Damon on 2024/11/15.
//

import UIKit
import SwiftyJSON
import RxRelay
import DDUtils

class GoodsDetailIntroView: DDView {
    let clickPublish = PublishRelay<Int>()

    override func createUI() {
        super.createUI()
        
        self.addSubview(mContentView)
        mContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self._bindView()
    }
    
    func updateUI(goodsInfo: JSON, SKUInfo: JSON, isOnleStatus: Bool, useDecorate: [String], hasChooseFrame:Bool) {
        for view in self.mContentView.subviews {
            view.removeFromSuperview()
        }
        let introList = self._transformFoldInfoList(goodsInfo: goodsInfo, SKUInfo: SKUInfo, isOnleStatus: isOnleStatus, useDecorate: useDecorate, hasChooseFrame: hasChooseFrame)
        var contentPosView: UIView?
        for index in 0..<introList.count {
            let intro = introList[index]
            //标题
            let label = UILabel()
            label.font = .systemFont(ofSize: 12)
            label.textColor = ThemeColor.black.color()
            label.attributedText = intro["title"] as? NSAttributedString
            mContentView.addSubview(label)
            label.snp.makeConstraints { make in
                make.left.equalToSuperview()
                if let contentPosView = contentPosView {
                    make.top.equalTo(contentPosView.snp.bottom).offset(10)
                } else {
                    make.top.equalToSuperview()
                }
                make.width.equalTo(UIScreenWidth / 3.0)
            }
            //描述
            let contentLabel = UILabel()
            contentLabel.isUserInteractionEnabled = true
            contentLabel.font = .systemFont(ofSize: 12)
            contentLabel.textColor = ThemeColor.black.color()
            contentLabel.textAlignment = .right
            contentLabel.attributedText = intro["content"] as? NSAttributedString
            mContentView.addSubview(contentLabel)
            contentLabel.snp.makeConstraints { make in
                make.left.equalTo(label.snp.right)
                make.right.equalToSuperview()
                make.top.height.equalTo(label)
            }
            contentPosView = contentLabel
            if index == introList.count - 1 {
                mContentView.snp.makeConstraints { make in
                    make.bottom.equalTo(contentPosView!)
                }
            }
            //点击
            let tap = UITapGestureRecognizer()
            _ = tap.rx.event.subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.clickPublish.accept(intro["tag"] as! Int)
            })
            contentLabel.addGestureRecognizer(tap)
        }
    }
    
    //MARK: UI
    lazy var mContentView: UIView = {
        let view = UIView()
        return view
    }()
}

extension GoodsDetailIntroView {
    func _transformFoldInfoList(goodsInfo: JSON, SKUInfo: JSON, isOnleStatus: Bool, useDecorate: [String], hasChooseFrame: Bool) -> [[String: Any]] {
        var introList: [[String: Any]] = []
        var edition = ""
        if SKUInfo["number_type"].intValue == 0 {
            edition = "Unique".localString
        } else if SKUInfo["number_type"].intValue == 1 {
            edition = "Limit edition".localString
        } else if SKUInfo["number_type"].intValue == 2 {
            edition = "PP"
        } else if SKUInfo["number_type"].intValue == 3 {
            edition = "AP"
        } else if SKUInfo["number_type"].intValue == 11 {
            edition = "Open edition".localString
        }
        let intro = ["title": NSAttributedString(string:"Edition".localString), "content": NSAttributedString(string: edition, attributes: [NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue, .underlineColor: ThemeColor.gray.color()]), "tag": 0] as [String : Any]
        introList.append(intro)
        
        if String.isAvailable( SKUInfo["certificate_str"].stringValue) {
            let intro2 = ["title": NSAttributedString(string:"Certificate of Authenticity".localString), "content": NSAttributedString(string:SKUInfo["certificate_str"].stringValue), "tag": 1] as [String : Any]
            introList.append(intro2)
        }
        if String.isAvailable(SKUInfo["condition_str"].stringValue) {
            let intro3 = ["title": NSAttributedString(string:"Condition".localString), "content": NSAttributedString(string:SKUInfo["condition_str"].stringValue), "tag": 2] as [String : Any]
            introList.append(intro3)
        }
        if String.isAvailable(SKUInfo["signature_str"].stringValue) {
            let intro4 = ["title": NSAttributedString(string:"Signature".localString), "content": NSAttributedString(string:SKUInfo["signature_str"].stringValue), "tag": 3] as [String : Any]
            introList.append(intro4)
        }
        if SKUInfo["mount_type"].intValue == 2 {
            let intro = ["title": NSAttributedString(string:"Frame".localString), "content": NSAttributedString(string:"Frame included".localString), "tag": 4] as [String : Any]
            introList.append(intro)
        } else if (goodsInfo["show_status"].intValue == 0 || goodsInfo["show_status"].intValue == 1 || goodsInfo["show_status"].intValue == 8) && useDecorate.count > 0 {
            let attributed = NSMutableAttributedString(string: "Not included / ".localString)
            if hasChooseFrame {
                let chooseAttributed = NSAttributedString(string: "Change Frame", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue, .underlineColor: ThemeColor.black.color()])
                attributed.append(chooseAttributed)
            } else {
                let chooseAttributed = NSAttributedString(string: "Choose Frame", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue, .underlineColor: ThemeColor.black.color()])
                attributed.append(chooseAttributed)
            }
            let intro = ["title": NSAttributedString(string:"Frame".localString), "content": attributed, "tag": 6] as [String : Any]
            introList.append(intro)
        } else {
            let intro = ["title": NSAttributedString(string:"Frame".localString), "content": NSAttributedString(string:"Not applicable".localString), "tag": 5] as [String : Any]
            introList.append(intro)
        }
        
        return introList
    }
    
    func _bindView() {
        
    }
}
