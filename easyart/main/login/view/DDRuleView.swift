//
//  DDRuleView.swift
//  easyart
//
//  Created by Damon on 2024/9/27.
//

import UIKit
import DDUtils
import RxRelay

class DDRuleView: DDView {
    let selectChange = PublishRelay<Bool>()
    
    override func createUI() {
        self.addSubview(mRuleButton)
        mRuleButton.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(15)
        }
        self.addSubview(mRuleLabel)
        mRuleLabel.snp.makeConstraints { make in
            make.left.equalTo(mRuleButton.snp.right).offset(5)
            make.right.equalToSuperview()
            make.width.lessThanOrEqualTo(UIScreenWidth - 100)
            make.height.greaterThanOrEqualTo(15)
            make.top.bottom.equalToSuperview()
        }
        
        self.addSubview(mRuleTextView)
        mRuleTextView.snp.makeConstraints { make in
            make.edges.equalTo(mRuleLabel)
        }
        
        self._bindView()
    }
    
    func updateRule(text: NSAttributedString) {
        self.mRuleLabel.attributedText = text
        self.mRuleTextView.attributedText = text
    }
    
    //MARK: UI
    lazy var mRuleButton: DDButton = {
        let button = DDButton()
        button.isSelected = true
        button.imageSize = CGSize(width: 15, height: 15)
        button.contentType = .center(gap: 0)
        button.normalImage = UIImage(named: "icon_normal")
        button.selectedImage = UIImage(named: "icon_selected")
        return button
    }()
    
    lazy var mRuleLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.numberOfLines = 0
        return label
    }()

    lazy var mRuleTextView: UITextView = {
        let tTextView = UITextView()
        tTextView.backgroundColor = .clear
        tTextView.contentOffset = .zero
        tTextView.contentInset = .zero
        tTextView.textContainerInset = .zero
        tTextView.isEditable = false
        tTextView.isSelectable = true
        tTextView.isScrollEnabled = false
        tTextView.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.dd.color(hexValue: 0x1053FF), .underlineStyle: NSUnderlineStyle.single.rawValue, .underlineColor: UIColor.dd.color(hexValue: 0x1053FF)]
        return tTextView
    }()
}

extension DDRuleView {
    func _bindView() {
        _ = self.mRuleButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.mRuleButton.isSelected = !self.mRuleButton.isSelected
            self.selectChange.accept(self.mRuleButton.isSelected)
        })
    }
}

