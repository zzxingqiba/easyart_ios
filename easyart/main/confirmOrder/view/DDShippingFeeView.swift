//
//  DDShippingFeeView.swift
//  easyart
//
//  Created by Damon on 2025/2/24.
//

import UIKit
import RxRelay

class DDShippingFeeView: DDView {
    let clickPublish = PublishRelay<Void>()

    override func createUI() {
        super.createUI()
        self.addSubview(mImageView)
        mImageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.height.equalTo(15)
            make.centerY.equalToSuperview()
        }
        
        self.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(mImageView.snp.right).offset(7)
            make.centerY.equalToSuperview()
        }
        
        self.addSubview(mIconImageView)
        mIconImageView.snp.makeConstraints { make in
            make.left.equalTo(mTitleLabel.snp.right).offset(10)
            make.centerY.equalTo(mTitleLabel)
            make.width.equalTo(30)
            make.height.equalTo(20)
        }
        
        self.addSubview(mContentLabel)
        mContentLabel.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        self._bindView()
    }
    
    var isSelected = false {
        didSet {
            mImageView.image = isSelected ? UIImage(named: "artist_edit_selected") : UIImage(named: "artist_edit_normal")
        }
    }

    //MARK: UI
    lazy var mImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "artist_edit_normal")
        return imageView
    }()
    
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mIconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
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

extension DDShippingFeeView {
    func _bindView() {
        let tap = UITapGestureRecognizer()
        _ = tap.rx.event.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.isSelected = true
            self.clickPublish.accept(())
        })
        self.addGestureRecognizer(tap)
    }
}
