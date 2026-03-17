//
//  MineNumberItemView.swift
//  easyart
//
//  Created by 喵小呆 on 2026/3/14.
//

import UIKit
import RxRelay

class MineNumberItemView: DDView {
    let clickPublish = PublishRelay<Void>()
    
    override func createUI() {
        super.createUI()
        self.addSubview(mNumberLabel)
        mNumberLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        self.addSubview(mIconButton)
        mIconButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mNumberLabel.snp.bottom).offset(5)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        self.addSubview(mRedIcon)
        mRedIcon.snp.makeConstraints { make in
            make.right.equalTo(mNumberLabel).offset(7)
            make.top.equalTo(mNumberLabel).offset(-3)
            make.width.height.equalTo(6)
        }
        
        self._bindView()
    }
    
    
    //MARK: UI
    lazy var mNumberLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mIconButton: DDButton = {
        let button = DDButton(imagePosition: .left)
        button.isUserInteractionEnabled = false
        button.contentType = .contentFit(padding: .zero, gap: 3)
        button.imageSize = CGSize(width: 10, height: 9)
        button.mTitleLabel.font = .systemFont(ofSize: 11)
        button.mTitleLabel.textColor = ThemeColor.black.color()
        return button
    }()

    lazy var mRedIcon: UIView = {
        let view = UIView()
//        view.isHidden = true
        view.backgroundColor = .red
        view.layer.cornerRadius = 3
        return view
    }()
}

extension MineNumberItemView {
    func _bindView() {
        let tap = UITapGestureRecognizer()
        _ = tap.rx.event.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.clickPublish.accept(())
        })
        self.addGestureRecognizer(tap)
    }
}
