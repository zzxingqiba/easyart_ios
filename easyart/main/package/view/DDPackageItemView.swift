//
//  DDPackageItemView.swift
//  easyart
//
//  Created by Damon on 2024/12/2.
//

import UIKit

class DDPackageItemView: DDView {

    override func createUI() {
        super.createUI()
        self.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(40)
            make.bottom.equalToSuperview()
        }
        
        self.addSubview(mStackView)
        mStackView.snp.makeConstraints { make in
            make.centerY.equalTo(mTitleLabel)
            make.height.equalTo(mTitleLabel)
            make.right.equalToSuperview()
        }
    }
    
    //MARK: UI
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.gray.color()
        return label
    }()
    
    lazy var mStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()
}

extension DDPackageItemView {
    func updateVisible(hidden: Bool) {
        self.isHidden = hidden
        mTitleLabel.snp.updateConstraints { make in
            make.height.equalTo(hidden ? 0 : 40)
        }
    }
}
