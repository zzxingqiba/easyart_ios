//
//  MineMenuTabItemView.swift
//  easyart
//
//  Created by 崭新的旧刀 on 2026/3/17.
//

import SnapKit
import UIKit

class MineMenuTabItemView: DDCollectionViewCell {
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 12, weight: .bold)
        return view
    }()

    var isChoosed = false {
        didSet {
            updateUI()
        }
    }

    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }

    override func createUI() {
        super.createUI()
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        updateUI()
    }

    private func updateUI() {
        titleLabel.textColor = isChoosed ? ThemeColor.black.color() : ThemeColor.gray.color()
    }
}
