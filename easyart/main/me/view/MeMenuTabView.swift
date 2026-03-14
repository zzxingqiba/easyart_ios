//
//  MeMenuTabView.swift
//  easyart
//
//  Created by Damon on 2025/1/7.
//

import UIKit
import RxRelay

class MeMenuTabView: DDView {
    let indexChange = PublishRelay<Int>()
    
    override func createUI() {
        super.createUI()
        self.addSubview(mLeftTabItemView)
        mLeftTabItemView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.right.equalTo(self.snp.centerX)
        }
        
        self.addSubview(mRightTabItemView)
        mRightTabItemView.snp.makeConstraints { make in
            make.left.equalTo(self.snp.centerX)
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        self._bindView()
    }

    //MARK: UI
    lazy var mLeftTabItemView: MeMenuTabItemView = {
        let view = MeMenuTabItemView(title: "My Collection".localString)
        view.isSelected = true
        return view
    }()
    
    lazy var mRightTabItemView: MeMenuTabItemView = {
        let view = MeMenuTabItemView(title: "My Artworks".localString)
        view.isSelected = false
        return view
    }()
}

extension MeMenuTabView {
    func _bindView() {
        _ = self.mLeftTabItemView.clickPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.mLeftTabItemView.isSelected = true
            self.mRightTabItemView.isSelected = false
            self.indexChange.accept(0)
        })
        
        _ = self.mRightTabItemView.clickPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.mLeftTabItemView.isSelected = false
            self.mRightTabItemView.isSelected = true
            self.indexChange.accept(1)
        })
    }
}
