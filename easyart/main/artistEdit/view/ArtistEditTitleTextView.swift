//
//  ArtistEditTitleTextView.swift
//  easyart
//
//  Created by Damon on 2025/1/9.
//

import UIKit

class ArtistEditTitleTextView: DDView {
    
    override func createUI() {
        super.createUI()
        self.addSubview(mTextField)
        mTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview()
        }
        
        self.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
    
    //MARK: UI
    lazy var mTitleLabel: PaddingLabel = {
        let label = PaddingLabel(withInsets: 0, 0, 3, 10)
        label.backgroundColor = ThemeColor.white.color()
        label.text = "Title of work".localString
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mTextField: UITextField = {
        let field = UITextField()
        field.attributedPlaceholder = NSAttributedString(string: "Please enter ...".localString, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 11), .foregroundColor: UIColor.dd.color(hexValue: 0xA39FAC)])
        field.font = .systemFont(ofSize: 13)
        field.textAlignment = .right
        field.rightViewMode = .always
        field.rightView = UIView(frame: CGRect(origin: .zero, size: CGSizeMake(10, 0)))
        field.layer.borderColor = UIColor.dd.color(hexValue: 0xE6E6E6).cgColor
        field.layer.borderWidth = 0.5
        return field
    }()

}
