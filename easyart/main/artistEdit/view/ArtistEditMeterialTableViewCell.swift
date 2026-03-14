//
//  ArtistEditMeterialTableViewCell.swift
//  easyart
//
//  Created by Damon on 2025/1/16.
//

import UIKit
import RxRelay

class ArtistEditMeterialTableViewCell: DDTableViewCell {
    let textChange = PublishRelay<String>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.mArrowImageView.image = selected ? UIImage(named: "artist_edit_selected") :  UIImage(named: "artist_edit_normal")
    }
    
    override func createUI() {
        super.createUI()
        self.contentView.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(23)
            make.left.equalToSuperview()
        }
        
        self.contentView.addSubview(mArrowImageView)
        mArrowImageView.snp.makeConstraints { make in
            make.centerY.equalTo(mTitleLabel)
            make.right.equalToSuperview()
            make.width.equalTo(15)
            make.height.equalTo(15)
        }
        
        self.contentView.addSubview(mTextfield)
        mTextfield.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(mTitleLabel.snp.bottom).offset(23)
            make.height.equalTo(40)
        }
        
        self.contentView.addSubview(mTextLabel)
        mTextLabel.snp.makeConstraints { make in
            make.right.equalTo(mTextfield).offset(-10)
            make.centerY.equalTo(mTextfield)
        }
        
        self.contentView.addSubview(mLineView)
        mLineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(mTextfield.snp.bottom).offset(15)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        self._bindView()
    }
    
    func updateUI(model: DDSearchMulFilterModel, text: String?) {
        if let attributed = model.attributed {
            mTitleLabel.attributedText = attributed
        } else {
            mTitleLabel.text = model.title
        }
        mTextfield.text = text
    }

    //MARK: UI
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mArrowImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "artist_edit_normal"))
        return imageView
    }()
    
    lazy var mTextfield: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor.dd.color(hexValue: 0xF5F5F5)
        textField.font = .systemFont(ofSize: 12)
        textField.textColor = ThemeColor.black.color()
        textField.placeholder = " Please enter".localString
        return textField
    }()
    
    lazy var mTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = ThemeColor.gray.color()
        label.text = "0/99"
        return label
    }()
    
    lazy var mLineView: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeColor.line.color()
        return view
    }()

}

extension ArtistEditMeterialTableViewCell {
    func _bindView() {
        _ = self.mTextfield.rx.text.orEmpty.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            if text.length > 99 {
                self.mTextfield.text = text.dd.subString(rang: NSRange(location: 0, length: 99))
            }
            self.mTextLabel.text = "\(self.mTextfield.text!.length)/99"
            //
            self.textChange.accept(self.mTextfield.text ?? "")
        })
    }
}
