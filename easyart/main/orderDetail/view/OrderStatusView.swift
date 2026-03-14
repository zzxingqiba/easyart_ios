//
//  OrderStatusView.swift
//  easyart
//
//  Created by Damon on 2024/9/30.
//

import UIKit

class OrderStatusView: DDView {
    
    override func createUI() {
        super.createUI()
        self.backgroundColor = ThemeColor.main.color()
        self.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(20)
        }
        
        self.addSubview(mTipLabel)
        mTipLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(mTitleLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    //MARK: UI
    lazy var mTitleLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.numberOfLines = 0
        tLabel.textColor = UIColor.dd.color(hexValue: 0xffffff)
        tLabel.font = .systemFont(ofSize: 16, weight: .bold)
        return tLabel
    }()

    lazy var mTipLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.numberOfLines = 0
        tLabel.textColor = UIColor.dd.color(hexValue: 0xffffff)
        tLabel.font = .systemFont(ofSize: 13)
        return tLabel
    }()
}

extension OrderStatusView {
    func update(title: String, nextStep: String, titleBolder: Bool, tip: String) {
        self.mTipLabel.text = tip
        
        let attributed = NSMutableAttributedString(string: title)
        if titleBolder {
            attributed.addAttributes([.font: UIFont.systemFont(ofSize: 22, weight: .bold)], range: NSRange(location: 0, length: title.count))
        } else {
            attributed.addAttributes([.font: UIFont.systemFont(ofSize: 16, weight: .bold)], range: NSRange(location: 0, length: title.count))
        }
        if String.isAvailable(nextStep) {
            attributed.append(NSAttributedString(string: "\n"))
            
            let nextAttach = NSTextAttachment(image: UIImage(named: "icon-right-next")!)
            nextAttach.bounds = CGRect(x: 0, y: 0, width: 8, height: 9)
            attributed.append(NSAttributedString(attachment: nextAttach))
            
            let nextStep = NSAttributedString(string: "  " + nextStep, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13, weight: .bold)])
            attributed.append(nextStep)
        }
        self.mTitleLabel.attributedText = attributed
        
    }
}
