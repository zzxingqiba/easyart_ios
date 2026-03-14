//
//  ArtistEditTextFieldCellView.swift
//  easyart
//
//  Created by Damon on 2025/2/19.
//

import UIKit
import RxRelay

class ArtistEditTextFieldCellView: DDView {
    let textPublish = PublishRelay<String>()
    
    override func createUI() {
        super.createUI()
        
        self.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        self.addSubview(mHeightTextfield)
        mHeightTextfield.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(15)
            make.left.equalTo(self.snp.centerX)
            make.height.equalTo(40)
        }
        
        self.addSubview(mLineView)
        mLineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(mHeightTextfield.snp.bottom).offset(15)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
        
        self._bindView()
    }

    //MARK: UI
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Size (cm)".localString
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.black.color()
        return label
    }()

    lazy var mHeightTextfield: UITextField = {
        let field = UITextField()
        field.keyboardType = .numberPad
        field.placeholder = "weight".localString
        field.textAlignment = .right
        field.font = .systemFont(ofSize: 13)
        field.textColor = ThemeColor.black.color()
        field.layer.borderColor = ThemeColor.line.color().cgColor
        field.layer.borderWidth = 0.5
        field.rightViewMode = .always
        field.rightView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSizeMake(10, 1)))
        return field
    }()
    
    lazy var mLineView: UIView = {
        let line = UIView()
        line.backgroundColor = ThemeColor.line.color()
        return line
    }()
}

extension ArtistEditTextFieldCellView {
    func _bindView() {
        _ = self.mHeightTextfield.rx.text.orEmpty.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            self.textPublish.accept(text)
        })
    }
}
