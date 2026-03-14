//
//  DDPreviewItemView.swift
//  easyart
//
//  Created by Damon on 2024/11/6.
//

import UIKit
import RxRelay

class DDPreviewItemView: DDView {
    let clickPublish = PublishRelay<DDView>()
    
    override func createUI() {
        super.createUI()
        self.layer.borderColor = ThemeColor.line.color().cgColor
        self.layer.borderWidth = 1
        self.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.bottom.equalToSuperview()
        }
        
        self.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(24)
            make.height.equalTo(24)
        }
        
        self._bindView()
    }
    
    var isSelected = false {
        didSet {
            self.layer.borderColor = isSelected ? ThemeColor.main.color().cgColor : ThemeColor.line.color().cgColor
        }
    }
    
    var isEnabled = true {
        didSet {
            self.layer.borderColor = isEnabled ? ThemeColor.line.color().cgColor : UIColor.clear.cgColor
            self.backgroundColor = isEnabled ? UIColor.dd.color(hexValue: 0xffffff) : UIColor.dd.color(hexValue: 0xF2F2F2)
            self.mTitleLabel.textColor = isEnabled ? ThemeColor.gray.color() : UIColor.dd.color(hexValue: 0xffffff)
        }
    }
    
    //MARK: UI
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = ThemeColor.gray.color()
        return label
    }()
}

private extension DDPreviewItemView {
    func _bindView() {
        let tap = UITapGestureRecognizer()
        _ = tap.rx.event.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.isSelected = true
            self.clickPublish.accept(self)
        })
        self.addGestureRecognizer(tap)
    }
}
