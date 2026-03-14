//
//  HDMenuCollectionViewCell.swift
//  HDPopView
//
//  Created by Damon on 2022/11/14.
//

import UIKit


public class HDMenuPopItem: NSObject {
    public var title: String?
    public var icon: UIImage?
    public var isEnabled: Bool = true

    public init(title: String?, icon: UIImage?, isEnabled: Bool = true) {
        self.title = title
        self.icon = icon
        self.isEnabled = isEnabled
        super.init()
    }
}

class HDMenuCollectionViewCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self._createUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateUI(model: HDMenuPopItem) {
        mTitleLabel.text = model.title
        mIconButton.setImage(model.icon, for: .normal)
        mIconButton.isEnabled = model.isEnabled
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
        tLabel.textColor = UIColor.dd.color(hexValue: 0x333333)
        tLabel.font = .systemFont(ofSize: 12)
        tLabel.numberOfLines = 2
        tLabel.textAlignment = .center
        return tLabel
    }()
}

private extension HDMenuCollectionViewCell {
    func _createUI() {
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
