//
//  DDGoodsNumbeCollectionViewCell.swift
//  easyart
//
//  Created by Damon on 2024/9/19.
//

import UIKit

class DDGoodsNumbeCollectionViewCell: DDCollectionViewCell {
    override func createUI() {
        super.createUI()
//        self.layer.borderWidth = 1
//        self.layer.borderColor = ThemeColor.line.color().cgColor
        self.backgroundColor = UIColor.dd.color(hexValue: 0xE6E6E6, alpha: 0.3)
        self.addSubview(mLabel)
        mLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            self.mLabel.textColor = isSelected ? UIColor.dd.color(hexValue: 0xffffff) : ThemeColor.black.color()
            self.backgroundColor = isSelected ? ThemeColor.main.color() : UIColor.dd.color(hexValue: 0xE6E6E6, alpha: 0.3)
        }
    }
    
    //MARK: UI
    lazy var mLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.black.color()
        return label
    }()
}

extension DDGoodsNumbeCollectionViewCell {
    func updateUI(title: String) {
        self.mLabel.text = title
    }
}
