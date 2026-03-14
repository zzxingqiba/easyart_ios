//
//  DDSearchEmptyView.swift
//  easyart
//
//  Created by Damon on 2024/12/3.
//

import UIKit
import RxRelay

class DDSearchEmptyView: DDView {
    let clickPublish = PublishRelay<Void>()
    
    override func createUI() {
        super.createUI()
        self.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        self.addSubview(mButtonLabel)
        mButtonLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mTitleLabel.snp.bottom).offset(30)
            make.bottom.equalToSuperview()
        }
        
        self._bindView()
    }
    
    //MARK: UI
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "No results found\nPlease try another search.".localString
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mButtonLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "Clear filters".localString, attributes: [NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue, .underlineColor: ThemeColor.black.color()])
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.black.color()
        label.isUserInteractionEnabled = true
        return label
    }()

}

extension DDSearchEmptyView {
    func _bindView() {
        let tap = UITapGestureRecognizer()
        _ = tap.rx.event.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.clickPublish.accept(())
        })
        self.addGestureRecognizer(tap)
    }
}
