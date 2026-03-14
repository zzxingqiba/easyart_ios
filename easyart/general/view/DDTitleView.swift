//
//  DDTitleView.swift
//  Menses
//
//  Created by Damon on 2020/7/7.
//  Copyright © 2020 Damon. All rights reserved.
//

import UIKit
import DDUtils

class DDTitleView: UIView {
    var mIconColor: UIColor = UIColor.dd.color(hexValue: 0xFFD200) {
        willSet {
            self.mTitleIcon.backgroundColor = newValue
        }
    }
    var mTitleColor: UIColor = UIColor.dd.color(hexValue: 0x333333) {
        willSet {
            self.mTitleLable.textColor = newValue
        }
    }
    var mTitleFont: UIFont = .systemFont(ofSize: 15, weight: .medium) {
        willSet {
            self.mTitleLable.font = newValue
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.p_createUI()
    }
    
    convenience init(title: String?) {
        self.init(frame: CGRect.zero)
        self.mTitleLable.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func p_createUI() {
        self.addSubview(mTitleIcon)
        mTitleIcon.snp.makeConstraints { (make) in
            make.width.equalTo(5)
            make.height.equalTo(15)
            make.left.top.bottom.equalToSuperview()
        }
        
        self.addSubview(mTitleLable)
        mTitleLable.snp.makeConstraints { (make) in
            make.left.equalTo(mTitleIcon.snp.right).offset(5)
            make.centerY.equalTo(mTitleIcon)
            make.right.equalToSuperview()
        }
    }

    //MARK: Layload
    
    private(set) lazy var mTitleIcon: UIView = {
        let tView = UIView()
        tView.backgroundColor =  UIColor.dd.color(hexValue: 0xFFD200)
        return tView
    }()
    
    private(set) lazy var mTitleLable: UILabel = {
        let tLabel = UILabel()
        tLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        tLabel.textColor =  UIColor.dd.color(hexValue: 0x333333)
        return tLabel
    }()
}
