//
//  DDSearchFilterBottomView.swift
//  easyart
//
//  Created by Damon on 2024/11/25.
//

import UIKit
import RxRelay

class DDSearchFilterBottomView: DDView {
    let clearPublish = PublishRelay<Void>()
    let confirmPublish = PublishRelay<Void>()
    
    override func createUI() {
        super.createUI()
        self.backgroundColor = ThemeColor.black.color()
        self.snp.makeConstraints { make in
            make.height.equalTo(45)
        }
        
        self.addSubview(mClearButton)
        mClearButton.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalTo(115)
        }
        
        let line = UIView()
        line.backgroundColor = ThemeColor.white.color()
        self.addSubview(line)
        line.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(0.5)
            make.height.equalTo(13)
            make.left.equalTo(mClearButton.snp.right)
        }
        
        self.addSubview(mConfirmButton)
        mConfirmButton.snp.makeConstraints { make in
            make.left.equalTo(line.snp.right)
            make.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        self._bindView()
    }
    
    //MARK: UI
    lazy var mClearButton: DDButton = {
        let button = DDButton(imagePosition: .none)
        button.contentType = .center(gap: 0)
        button.mTitleLabel.textColor = ThemeColor.white.color()
        button.mTitleLabel.font = .systemFont(ofSize: 14)
        button.mTitleLabel.text = "Clear".localString
        return button
    }()

    lazy var mConfirmButton: DDButton = {
        let button = DDButton(imagePosition: .none)
        button.contentType = .center(gap: 0)
        button.mTitleLabel.textColor = ThemeColor.white.color()
        button.mTitleLabel.font = .systemFont(ofSize: 14)
        button.mTitleLabel.text = "Show Results".localString
        return button
    }()
    
}

extension DDSearchFilterBottomView {
    func _bindView() {
        _ = self.mClearButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.clearPublish.accept(())
        })
        
        _ = self.mConfirmButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.confirmPublish.accept(())
        })
    }
}
