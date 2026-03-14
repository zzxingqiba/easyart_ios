//
//  DDSpaceBetweenView.swift
//  easyart
//
//  Created by Damon on 2024/9/19.
//

import UIKit
import SnapKit

class DDSpaceBetweenView: DDView {
    
    override func createUI() {
        super.createUI()
        self.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(14)
        }
        
        self.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalTo(self.snp.centerX).offset(40)
            make.centerY.equalToSuperview()
        }
        
        self.addSubview(mContentLabel)
        mContentLabel.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.left.equalTo(self.snp.centerX).offset(50)
            make.top.bottom.equalToSuperview()
        }
    }
    
    //
    var heightPosView: Int = 0 {
        didSet {
            if heightPosView == 0 {
                mTitleLabel.snp.remakeConstraints { make in
                    make.left.equalToSuperview()
                    make.right.equalTo(self.snp.centerX)
                    make.centerY.equalToSuperview()
                }
                
                mContentLabel.snp.remakeConstraints { make in
                    make.right.equalToSuperview()
                    make.left.equalTo(self.snp.centerX)
                    make.top.bottom.equalToSuperview()
                }
            } else {
                mTitleLabel.snp.remakeConstraints { make in
                    make.left.equalToSuperview()
                    make.right.equalTo(self.snp.centerX)
                    make.top.bottom.equalToSuperview()
                }
                
                mContentLabel.snp.remakeConstraints { make in
                    make.right.equalToSuperview()
                    make.left.equalTo(self.snp.centerX)
                    make.centerY.equalToSuperview()
                }
            }
        }
    }
    
    
    //MARK: UI
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mContentLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.black.color()
        return label
    }()
}
