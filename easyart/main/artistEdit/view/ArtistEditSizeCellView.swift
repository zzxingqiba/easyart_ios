//
//  ArtistEditSizeCellView.swift
//  easyart
//
//  Created by Damon on 2025/1/15.
//

import UIKit
import RxRelay

class ArtistEditSizeCellView: DDView {
    let widthPublish = PublishRelay<Int>()
    let heightPublish = PublishRelay<Int>()
    let lengthPublish = PublishRelay<Int>()
    
    var showHeight = true {
        didSet {
            if showHeight {
                mHeightTextfield.snp.updateConstraints { make in
                    make.width.equalTo(60)
                }
                mHeightTitleLabel.snp.updateConstraints { make in
                    make.width.equalTo(23)
                }
            } else {
                mHeightTextfield.snp.updateConstraints { make in
                    make.width.equalTo(0)
                }
                mHeightTitleLabel.snp.updateConstraints { make in
                    make.width.equalTo(0)
                }
            }
        }
    }
    
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
            make.width.equalTo(60)
            make.height.equalTo(40)
        }
        
        self.addSubview(mHeightTitleLabel)
        mHeightTitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(mHeightTextfield)
            make.right.equalTo(mHeightTextfield.snp.left)
            make.width.equalTo(23)
        }
        
        self.addSubview(mWidthTextfield)
        mWidthTextfield.snp.makeConstraints { make in
            make.right.equalTo(mHeightTitleLabel.snp.left)
            make.centerY.equalTo(mHeightTitleLabel)
            make.width.equalTo(60)
            make.height.equalTo(40)
        }
        
        self.addSubview(mWidthTitleLabel)
        mWidthTitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(mWidthTextfield)
            make.right.equalTo(mWidthTextfield.snp.left)
            make.width.equalTo(23)
        }
        
        self.addSubview(mLengthTextfield)
        mLengthTextfield.snp.makeConstraints { make in
            make.right.equalTo(mWidthTitleLabel.snp.left)
            make.centerY.equalTo(mWidthTitleLabel)
            make.width.equalTo(60)
            make.height.equalTo(40)
        }
        
        self.addSubview(mLineView)
        mLineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(mLengthTextfield.snp.bottom).offset(15)
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
        field.placeholder = "height".localString
        field.textAlignment = .center
        field.font = .systemFont(ofSize: 13)
        field.textColor = ThemeColor.black.color()
        field.layer.borderColor = ThemeColor.line.color().cgColor
        field.layer.borderWidth = 0.5
        return field
    }()
    
    lazy var mHeightTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "×"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.gray.color()
        return label
    }()
    
    lazy var mWidthTextfield: UITextField = {
        let field = UITextField()
        field.keyboardType = .numberPad
        field.placeholder = "width".localString
        field.textAlignment = .center
        field.font = .systemFont(ofSize: 13)
        field.textColor = ThemeColor.black.color()
        field.layer.borderColor = ThemeColor.line.color().cgColor
        field.layer.borderWidth = 0.5
        return field
    }()
    
    lazy var mWidthTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "×"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.gray.color()
        return label
    }()
    
    lazy var mLengthTextfield: UITextField = {
        let field = UITextField()
        field.keyboardType = .numberPad
        field.placeholder = "length".localString
        field.textAlignment = .center
        field.font = .systemFont(ofSize: 13)
        field.textColor = ThemeColor.black.color()
        field.layer.borderColor = ThemeColor.line.color().cgColor
        field.layer.borderWidth = 0.5
        return field
    }()
    
    lazy var mLineView: UIView = {
        let line = UIView()
        line.backgroundColor = ThemeColor.line.color()
        return line
    }()
}

extension ArtistEditSizeCellView {
    func _bindView() {
        _ = self.mHeightTextfield.rx.text.orEmpty.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            self.heightPublish.accept(Int(text) ?? 0)
        })
        
        _ = self.mWidthTextfield.rx.text.orEmpty.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            self.widthPublish.accept(Int(text) ?? 0)
        })
        
        _ = self.mLengthTextfield.rx.text.orEmpty.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            self.lengthPublish.accept(Int(text) ?? 0)
        })
    }
}
