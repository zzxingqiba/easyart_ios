//
//  DDAlertView.swift
//  Menses
//
//  Created by Damon on 2020/8/27.
//  Copyright © 2020 Damon. All rights reserved.
//

import UIKit
import DDUtils
import RxSwift

class DDAlertView: UIView {
    let mClickSubject = PublishSubject<DDPopButtonType>()

    init(title: String, content: String) {
        super.init(frame: .zero)
        self.p_createUI()
        self.mTitleLabel.text = title
        self.mContentLabel.text = content
    }

    init(title: String, content: NSMutableAttributedString) {
        super.init(frame: .zero)
        self.p_createUI()
        self.mTitleLabel.text = title
        self.mContentLabel.attributedText = content
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func p_createUI() {
        let view = UIView()
        view.backgroundColor = UIColor.dd.color(hexValue: 0xffffff)
        view.layer.cornerRadius = 12
        self.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.width.equalTo(300)
        }

        view.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(20)
        }

        view.addSubview(mContentLabel)
        mContentLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(mTitleLabel.snp.bottom).offset(20)
        }

        view.addSubview(mConfirmButton)
        mConfirmButton.snp.makeConstraints { (make) in
            make.top.equalTo(mContentLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.greaterThanOrEqualTo(150)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().offset(-20)
        }

        self.addSubview(mCloseButton)
        mCloseButton.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }

        _ = mConfirmButton.rx.tap.subscribe(onNext: { [weak self] (_) in
            self?.mClickSubject.onNext(.confirm)
        })

        _ = mCloseButton.rx.tap.subscribe(onNext: { [weak self] (_) in
            self?.mClickSubject.onNext(.close)
        })
    }

    //MARK: Lazy
    lazy var mTitleLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.textColor = UIColor.dd.color(hexValue: 0x000000)
        tLabel.font = .systemFont(ofSize: 20, weight: .medium)
        tLabel.textAlignment = .center
        return tLabel
    }()

    lazy var mContentLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.numberOfLines = 0
        tLabel.textColor = UIColor.dd.color(hexValue: 0x666666)
        tLabel.font = .systemFont(ofSize: 14)
        tLabel.textAlignment = .center
        return tLabel
    }()

    lazy var mConfirmButton: UIButton = {
        let tButton = UIButton(type: .custom)
        tButton.backgroundColor = UIColor.dd.color(hexValue: 0xFB4374)
        tButton.titleLabel?.font = .systemFont(ofSize: 16)
        tButton.setTitleColor(UIColor.dd.color(hexValue: 0xFFFFFF), for: .normal)
        tButton.setTitle("Confirm", for: .normal)
        tButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tButton.layer.cornerRadius = 20
        return tButton
    }()

    lazy var mCloseButton: UIButton = {
        let tButton = UIButton(type: .custom)
        let attributedString = NSMutableAttributedString(string: "点击关闭")
        attributedString.bs_font = .systemFont(ofSize: 16)
        attributedString.bs_color = UIColor.dd.color(hexValue: 0xffffff)
        attributedString.bs_underlineStyle = .single
        attributedString.bs_underlineColor = UIColor.dd.color(hexValue: 0xffffff)
        tButton.setAttributedTitle(attributedString, for: .normal)
        return tButton
    }()
}
