//
//  ArtistEditRarityCountTableViewCell.swift
//  easyart
//
//  Created by Damon on 2025/1/20.
//

import UIKit
import RxRelay

class ArtistEditRarityCountTableViewCell: DDTableViewCell {
    let textChange = PublishRelay<String>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func createUI() {
        super.createUI()
        self.contentView.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        self.contentView.addSubview(mTextField)
        mTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
//            make.left.equalTo(self.contentView.snp.centerX)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        
        self.contentView.addSubview(mLineView)
        mLineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        self._bindView()
    }
    
    func updateUI(model: DDSearchMulFilterModel, count: Int?) {
        if let attributed = model.attributed {
            mTitleLabel.attributedText = attributed
        } else {
            mTitleLabel.text = model.title
        }
        if let count = count {
            mTextField.text = "\(count)"
        } else {
            mTextField.text = nil
        }
    }

    //MARK: UI
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.font = .systemFont(ofSize: 12)
        textField.textColor = ThemeColor.black.color()
        textField.placeholder = " Please enter".localString
        textField.keyboardType = .numberPad
        textField.layer.borderColor = ThemeColor.line.color().cgColor
        textField.layer.borderWidth = 0.5
        return textField
    }()
    
    lazy var mLineView: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeColor.line.color()
        return view
    }()

}

extension ArtistEditRarityCountTableViewCell {
    func _bindView() {
        _ = self.mTextField.rx.controlEvent(.editingDidEnd).subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            self.textChange.accept(self.mTextField.text ?? "")
        })
    }
}
