//
//  HomeNavView.swift
//  easyart
//
//  Created by Damon on 2024/9/11.
//

import UIKit
import DDUtils
import RxRelay

class HomeNavView: DDView {
    let clickPublish = PublishRelay<Int>()
    var selectedIndex: Int = 0 {
        didSet {
            self.mLeftButton.isSelected = selectedIndex == 0
            self.mCenterButton.isSelected = selectedIndex == 1
        }
    }
    override func createUI() {
        super.createUI()
        self.backgroundColor = UIColor.dd.color(hexValue: 0xffffff)
        
        self.addSubview(mLeftButton)
        mLeftButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalTo(UIScreenWidth / 3.0)
            make.height.equalTo(32)
        }
        
        self.addSubview(mCenterButton)
        mCenterButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(mLeftButton.snp.right)
            make.width.equalTo(UIScreenWidth / 3.0)
            make.height.equalTo(32)
        }
        
        self.addSubview(mRightButton)
        mRightButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(mCenterButton.snp.right)
            make.right.equalToSuperview()
            make.height.equalTo(32)
        }
        
        self._bindView()
    }

    //MARK: UI
    lazy var mLeftButton: DDButton = {
        let button = DDButton(imagePosition: .left)
        button.imageSize = CGSize(width: 16, height: 16)
        button.contentType = .center(gap: 0)
        button.normalImage = UIImage(named: "home_single_disable")
        button.selectedImage = UIImage(named: "home_single")
        button.isSelected = true
        return button
    }()
    
    lazy var mCenterButton: DDButton = {
        let button = DDButton(imagePosition: .left)
        button.imageSize = CGSize(width: 16, height: 16)
        button.contentType = .center(gap: 0)
        button.normalImage = UIImage(named: "home_double_disable")
        button.selectedImage = UIImage(named: "home_double")
        return button
    }()

    lazy var mRightButton: DDButton = {
        let button = DDButton(imagePosition: .left)
        button.imageSize = CGSize(width: 16, height: 16)
        button.contentType = .center(gap: 0)
        button.normalImage = UIImage(named: "home_icon_sort")
        button.selectedImage = UIImage(named: "home_icon_sort")
        return button
    }()
}

extension HomeNavView {
    func _bindView() {
        _ = self.mLeftButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.selectedIndex = 0
            self.clickPublish.accept(self.selectedIndex)
        })
        
        _ = self.mCenterButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.selectedIndex = 1
            self.clickPublish.accept(self.selectedIndex)
        })
        
        _ = self.mRightButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.clickPublish.accept(2)
        })
    }
}
