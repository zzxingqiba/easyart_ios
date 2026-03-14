//
//  DDSheetView.swift
//  easyart
//
//  Created by Damon on 2024/9/30.
//

import UIKit
import DDUtils
import RxSwift

class DDSheetView: DDView {
    let mClickSubject = PublishSubject<DDPopButtonType>()
    
    override func createUI() {
        super.createUI()
        self.backgroundColor = UIColor.dd.color(hexValue: 0xffffff)
        
        self.snp.makeConstraints { make in
            make.width.equalTo(UIScreenWidth)
        }
        
        self.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(16)
        }
        
        self.addSubview(mCloseButton)
        mCloseButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalTo(mTitleLabel)
            make.width.height.equalTo(20)
        }
        
        let line = UIView()
        line.backgroundColor = ThemeColor.line.color()
        self.addSubview(line)
        line.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(mTitleLabel.snp.bottom).offset(100)
            make.height.equalTo(1)
        }
        
        self.addSubview(mConfirmButton)
        mConfirmButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(line.snp.bottom)
            make.height.equalTo(50)
        }
        
        let line2 = UIView()
        line2.backgroundColor = ThemeColor.line.color()
        self.addSubview(line2)
        line2.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(mConfirmButton.snp.bottom)
            make.height.equalTo(1)
        }
        
        self.addSubview(mCancelButton)
        mCancelButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(line2.snp.bottom)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-BottomSafeAreaHeight)
        }
        
        self._bindView()
    }
    
    //MARK: UI
    lazy var mTitleLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.textColor = ThemeColor.black.color()
        tLabel.font = .systemFont(ofSize: 18, weight: .medium)
        tLabel.textAlignment = .center
        return tLabel
    }()
    
    lazy var mConfirmButton: UIButton = {
        let tButton = UIButton(type: .custom)
        tButton.titleLabel?.font = .systemFont(ofSize: 14)
        tButton.setTitleColor(UIColor.dd.color(hexValue: 0xff0000), for: .normal)
        tButton.setTitle("Confirm".localString, for: .normal)
        return tButton
    }()
    
    lazy var mCancelButton: UIButton = {
        let tButton = UIButton(type: .custom)
        tButton.titleLabel?.font = .systemFont(ofSize: 14)
        tButton.setTitleColor(ThemeColor.black.color(), for: .normal)
        tButton.setTitle("Cancel".localString, for: .normal)
        return tButton
    }()

    
    lazy var mCloseButton: DDButton = {
        let tButton = DDButton()
        tButton.contentType = .center(gap: 0)
        tButton.normalImage = UIImage(named: "home_guanbi")
        tButton.imageSize = CGSize(width: 16, height: 16)
        return tButton
    }()
}

extension DDSheetView {
    func _bindView() {
        _ = mConfirmButton.rx.tap.subscribe(onNext: { [weak self] (_) in
            self?.mClickSubject.onNext(.confirm)
        })
        
        _ = mCancelButton.rx.tap.subscribe(onNext: { [weak self] (_) in
            self?.mClickSubject.onNext(.cancel)
        })
        
        _ = mCloseButton.rx.tap.subscribe(onNext: { [weak self] (_) in
            self?.mClickSubject.onNext(.close)
        })
    }
}
