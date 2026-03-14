//
//  DDCategoryItemView.swift
//  easyart
//
//  Created by Damon on 2024/9/23.
//

import UIKit
import RxRelay

class DDCategoryItemView: DDView {
    let mClickSubject = PublishRelay<Bool>()
    
    var id: String?
    var isSelected = false {
        didSet {
            self.mLabel.backgroundColor = isSelected ? UIColor.dd.color(hexValue: 0xffffff) : UIColor.dd.color(hexValue: 0xF5F5F5)
            self.mLabel.textColor = isSelected ? ThemeColor.main.color() : ThemeColor.gray.color()
            self.mLabel.layer.borderColor = isSelected ? ThemeColor.main.color().cgColor : UIColor.dd.color(hexValue: 0xF5F5F5).cgColor
        }
    }
    
    override func createUI() {
        super.createUI()
        self.addSubview(mLabel)
        mLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        //绑定
        self._bindView()
    }
    
    //MARK: UI
    lazy var mLabel: PaddingLabel = {
        let label = PaddingLabel(withInsets: 0, 0, 15, 15)
        label.isUserInteractionEnabled = false
        label.backgroundColor = UIColor.dd.color(hexValue: 0xF5F5F5)
        label.textColor = ThemeColor.gray.color()
        label.font = .systemFont(ofSize: 12)
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.dd.color(hexValue: 0xF5F5F5).cgColor
        return label
    }()

}

extension DDCategoryItemView {
    func _bindView() {
        let tap = UITapGestureRecognizer()
        _ = tap.rx.event.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.isSelected = !self.isSelected
            self.mClickSubject.accept(self.isSelected)
        })
        self.addGestureRecognizer(tap)
    }
}
