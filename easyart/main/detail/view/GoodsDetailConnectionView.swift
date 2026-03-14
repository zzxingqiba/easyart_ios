//
//  GoodsDetailConnectionView.swift
//  easyart
//
//  Created by Damon on 2024/11/15.
//

import UIKit
import RxRelay

class GoodsDetailConnectionView: DDView {
    let clickPublish = PublishRelay<Void>()
    
    override func createUI() {
        super.createUI()
        let topLine = UIView()
        topLine.backgroundColor = ThemeColor.line.color()
        self.addSubview(topLine)
        topLine.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        self.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(topLine.snp.bottom).offset(20)
        }
        
        self.addSubview(mDesLabel)
        mDesLabel.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalTo(mTitleLabel)
        }
        
        let bottomLine = UIView()
        bottomLine.backgroundColor = ThemeColor.line.color()
        self.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { make in
            make.top.equalTo(mDesLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview().offset(0)
        }
        
        self._bindView()
    }
    
   //MARK: UI
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Want to sell an art work? ".localString
        label.font = .systemFont(ofSize: 12)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mDesLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "Connection".localString, attributes: [NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue, .underlineColor: ThemeColor.black.color()])
        label.font = .systemFont(ofSize: 11)
        label.textColor = ThemeColor.black.color()
        return label
    }()

}

extension GoodsDetailConnectionView {
    func _bindView() {
        let tap = UITapGestureRecognizer()
        _ = tap.rx.event.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.clickPublish.accept(())
        })
        self.addGestureRecognizer(tap)
    }
}
