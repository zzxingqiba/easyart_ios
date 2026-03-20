//
//  MineArtistTipView.swift
//  easyart
//
//  Created by 崭新的旧刀 on 2026/3/20.
//

import UIKit

class MineArtistTipView: DDView {

    override func createUI() {
        super.createUI()
        self.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        self.addSubview(mTipLabel)
        mTipLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.top.equalTo(mTitleLabel.snp.bottom).offset(6)
            make.bottom.equalToSuperview()
        }
    }
    
    //MARK: UI
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "You haven't published any artwork yet.".localString
        label.font = .systemFont(ofSize: 13)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mTipLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Your personal homepage will not be displayed until there is at least one artwork published. ".localString
        label.font = .systemFont(ofSize: 12)
        label.textColor = ThemeColor.gray.color()
        return label
    }()

}
