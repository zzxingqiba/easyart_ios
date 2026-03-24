//
//  JoinPlatformArtist.swift
//  easyart
//
//  Created by 崭新的旧刀 on 2026/3/23.
//

import RxRelay
import UIKit

class JoinPlatformArtist: DDView {
    let clickPublish = PublishRelay<Void>()
    
    override func createUI() {
        snp.makeConstraints {
            make in
            make.height.equalTo(60)
        }
        addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        addSubview(mArrowImageView)
        mArrowImageView.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(8)
            make.height.equalTo(8)
        }
        addSubview(mLineView)
        mLineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
        _bindView()
    }
    
    // MARK: UI

    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.black.color()
        label.text = "艺术家入驻".localString
        return label
    }()
    
    lazy var mArrowImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "icon-arrow-solid"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var mLineView: UIView = {
        let line = UIView()
        line.backgroundColor = ThemeColor.line.color()
        return line
    }()
}

extension JoinPlatformArtist {
    func _bindView() {
        let tap = UITapGestureRecognizer()
        _ = tap.rx.event.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.clickPublish.accept(())
        })
        self.addGestureRecognizer(tap)
    }
}
