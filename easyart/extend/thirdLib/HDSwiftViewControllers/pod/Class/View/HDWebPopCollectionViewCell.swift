//
//  HDWebPopCollectionViewCell.swift
//  HDSwiftViewControllers
//
//  Created by Damon on 2021/2/28.
//  Copyright © 2021 Damon. All rights reserved.
//

import UIKit
import DDUtils

class HDWebPopCollectionViewCellModel: NSObject {
    var title: String?
    var icon: UIImage?
    
    init(title: String?, icon: UIImage?) {
        super.init()
        self.title = title
        self.icon = icon
    }
    
}

class HDWebPopCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.p_createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUI(model: HDWebPopCollectionViewCellModel) {
        mTitleLabel.text = model.title
        mIconButton.setImage(model.icon, for: .normal)
    }
    
    //MARK: UI
    lazy var mIconButton: UIButton = {
        let tIconButton = UIButton(type: .custom)
        tIconButton.isUserInteractionEnabled = false
        tIconButton.backgroundColor = UIColor.dd.color(hexValue: 0xffffff)
        tIconButton.layer.masksToBounds = true
        tIconButton.layer.cornerRadius = 10
        return tIconButton
    }()
    
    lazy var mTitleLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.textColor = UIColor.dd.color(hexValue: 0x666666)
        tLabel.font = .systemFont(ofSize: 11)
        tLabel.numberOfLines = 2
        tLabel.textAlignment = .center
        return tLabel
    }()
}

private extension HDWebPopCollectionViewCell {
    func p_createUI() {
        self.contentView.addSubview(mIconButton)
        mIconButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(5)
            make.width.height.equalTo(44)
        }
        
        self.contentView.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(mIconButton.snp.bottom).offset(8)
        }
    }
}
