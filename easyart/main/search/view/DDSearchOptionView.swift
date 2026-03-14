//
//  DDSearchOptionView.swift
//  easyart
//
//  Created by Damon on 2024/11/21.
//

import UIKit
import RxRelay

class DDSearchOptionView: DDView {
    let clickPublish = PublishRelay<Void>()
    
    override func createUI() {
        super.createUI()
        self.backgroundColor = ThemeColor.main.color()
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 18
        self.snp.makeConstraints { make in
            make.height.equalTo(36)
        }
        self.addSubview(mIconView)
        mIconView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
            make.width.equalTo(20)
            make.height.equalTo(10)
        }
        self.addSubview(mCountLabel)
        mCountLabel.snp.makeConstraints { make in
            make.left.equalTo(mIconView.snp.right)
            make.right.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview()
        }
        
        self._bindView()
    }
    
    //MARK: UI
    lazy var mIconView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "icon_option_a"))
        return view
    }()
    
    lazy var mCountLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.textColor = ThemeColor.white.color()
        label.font = .systemFont(ofSize: 12)
        return label
    }()
}

extension DDSearchOptionView {
    func updateCount(number: Int) {
        if number > 0 {
            mCountLabel.text = "\(number)"
            mCountLabel.snp.updateConstraints { make in
                make.left.equalTo(mIconView.snp.right).offset(6)
            }
        } else {
            mCountLabel.text = nil
            mCountLabel.snp.updateConstraints { make in
                make.left.equalTo(mIconView.snp.right)
            }
        }
    }
}

extension DDSearchOptionView {
    func _bindView() {
        let tap = UITapGestureRecognizer()
        _ = tap.rx.event.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.clickPublish.accept(())
        })
        self.addGestureRecognizer(tap)
    }
}
