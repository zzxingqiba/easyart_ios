//
//  OrgUpdateIDCoverView.swift
//  easyart
//
//  Created by 崭新的旧刀 on 2026/3/24.
//

import UIKit

class OrgUpdateIDCoverView: DDView {
    var imageUrl: String? {
        didSet {
            mTitleLabel.isHidden = String.isAvailable(imageUrl)
            if String.isAvailable(imageUrl) {
                mAddImageView.image = UIImage(named: "cover-mask-add")
                mAddImageView.snp.updateConstraints { make in
                    make.width.height.equalTo(35)
                }
                mImageView.kf.setImage(with: URL(string: imageUrl!))
            } else {
                mAddImageView.image = UIImage(named: "icon-add-bold")
                mAddImageView.snp.updateConstraints { make in
                    make.width.height.equalTo(20)
                }
                mImageView.image = nil
            }
        }
    }
    
    override func createUI() {
        super.createUI()
        layer.borderColor = ThemeColor.black.color().cgColor
        layer.borderWidth = 0.5
        
        addSubview(mImageView)
        mImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addSubview(mAddImageView)
        mAddImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mAddImageView.snp.bottom).offset(13)
        }
    }
    
    // MARK: UI

    lazy var mImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.kf.indicatorType = .activity
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var mAddImageView: UIImageView = .init(image: UIImage(named: "icon-add-bold"))

    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Upload artist image".localString
        label.font = .systemFont(ofSize: 13)
        label.textColor = ThemeColor.lightGray.color()
        return label
    }()
}
