//
//  DDCategoryTabView.swift
//  easyart
//
//  Created by Damon on 2024/9/23.
//

import UIKit
import RxRelay
import DDUtils

class DDCategoryTabView: DDView {
    let indexChange = PublishRelay<Int>()
    
    var selectedIndex: Int = 0 {
        didSet {
            mGoodsLabel.textColor = selectedIndex == 0 ? ThemeColor.black.color() : ThemeColor.gray.color()
            mGoodsLine.isHidden = selectedIndex != 0
            mAuthorLabel.textColor = selectedIndex == 1 ? ThemeColor.black.color() : ThemeColor.gray.color()
            mAuthorLine.isHidden = selectedIndex != 1
            mOrgLabel.textColor = selectedIndex == 2 ? ThemeColor.black.color() : ThemeColor.gray.color()
            mOrgLine.isHidden = selectedIndex != 2
        }
    }
    
    override func createUI() {
        super.createUI()
        self.addSubview(mBottomLine)
        mBottomLine.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        self.addSubview(mGoodsLabel)
        mGoodsLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(UIScreenWidth / 3.0)
        }
        
        self.addSubview(mGoodsLine)
        mGoodsLine.snp.makeConstraints { make in
            make.left.right.equalTo(mGoodsLabel)
            make.height.equalTo(2)
            make.bottom.equalTo(mBottomLine)
        }
        
        self.addSubview(mAuthorLabel)
        mAuthorLabel.snp.makeConstraints { make in
            make.left.equalTo(mGoodsLabel.snp.right)
            make.top.equalToSuperview()
            make.width.equalTo(mGoodsLabel)
        }
        
        self.addSubview(mAuthorLine)
        mAuthorLine.snp.makeConstraints { make in
            make.left.right.equalTo(mAuthorLabel)
            make.height.equalTo(2)
            make.bottom.equalTo(mBottomLine)
        }
        
        self.addSubview(mOrgLabel)
        mOrgLabel.snp.makeConstraints { make in
            make.left.equalTo(mAuthorLabel.snp.right)
            make.top.equalToSuperview()
            make.width.equalTo(mGoodsLabel)
        }
        
        self.addSubview(mOrgLine)
        mOrgLine.snp.makeConstraints { make in
            make.left.right.equalTo(mOrgLabel)
            make.height.equalTo(2)
            make.bottom.equalTo(mBottomLine)
        }
        
        self._bindView()
    }
    
    //MARK: UI
    lazy var mGoodsLabel: PaddingLabel = {
        let label = PaddingLabel(withInsets: 5, 5, 10, 10)
        label.text = "Works".localString
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = ThemeColor.black.color()
        label.textAlignment = .center
        return label
    }()
    
    lazy var mGoodsLine: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeColor.main.color()
        return view
    }()
    
    lazy var mAuthorLabel: PaddingLabel = {
        let label = PaddingLabel(withInsets: 5, 5, 10, 10)
        label.text = "Artist".localString
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = ThemeColor.gray.color()
        label.textAlignment = .center
        return label
    }()
    
    lazy var mAuthorLine: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = ThemeColor.main.color()
        return view
    }()
    
    lazy var mOrgLabel: PaddingLabel = {
        let label = PaddingLabel(withInsets: 5, 5, 10, 10)
        label.text = "Institution".localString
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = ThemeColor.gray.color()
        label.textAlignment = .center
        return label
    }()
    
    lazy var mOrgLine: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = ThemeColor.main.color()
        return view
    }()
    
    lazy var mBottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeColor.line.color()
        return view
    }()
}

private extension DDCategoryTabView {
    func _bindView() {
        let tap = UITapGestureRecognizer()
        _ = tap.rx.event.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.selectedIndex = 0
            self.indexChange.accept(self.selectedIndex)
        })
        self.mGoodsLabel.addGestureRecognizer(tap)
        
        let tap1 = UITapGestureRecognizer()
        _ = tap1.rx.event.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.selectedIndex = 1
            self.indexChange.accept(self.selectedIndex)
        })
        self.mAuthorLabel.addGestureRecognizer(tap1)
        
        let tap2 = UITapGestureRecognizer()
        _ = tap2.rx.event.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.selectedIndex = 2
            self.indexChange.accept(self.selectedIndex)
        })
        self.mOrgLabel.addGestureRecognizer(tap2)
    }
}
