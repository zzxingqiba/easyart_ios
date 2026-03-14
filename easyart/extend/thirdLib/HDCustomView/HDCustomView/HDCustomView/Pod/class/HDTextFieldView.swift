//
//  DDTextFieldView.swift
//  InvoiceClient
//
//  Created by Damon on 2020/7/25.
//  Copyright © 2020 Damon. All rights reserved.
//

import UIKit
import DDUtils
import RxCocoa
import RxSwift
import SnapKit

open class HDTextFieldView: UIView {

    public var isEnabled: Bool {
        get {
            self.mTextField.isEnabled
        }
        set {
            self.mTextField.isEnabled = newValue
            self.mTextField.isUserInteractionEnabled = newValue
            self.mTextField.textAlignment = newValue ? .left : .center
            self.mTextField.backgroundColor = newValue ? .clear : UIColor.dd.color(hexValue: 0xeeeeee)
        }
    }
    
    public init(title: String? = nil, icon: UIImage? = nil, imageSize: CGSize = CGSize(width: 24, height: 24)) {
        super.init(frame: .zero)
        self.p_createUI(title: title, icon: icon, imageSize: imageSize)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Lazy
    public private(set) lazy var mIconImageView: UIImageView = {
        let tImageView = UIImageView()
        return tImageView
    }()
    
    public private(set) lazy var mTitleLable: UILabel = {
        let tLabel = UILabel()
        tLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        tLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        tLabel.font = .systemFont(ofSize: 14)
        tLabel.textColor = UIColor.dd.color(hexValue: 0x333333)
        return tLabel
    }()
    
    public private(set) lazy var mTextField: HDTextField = {
        let tTextField = HDTextField()
        return tTextField
    }()

}

private extension HDTextFieldView {
    func p_createUI(title: String?, icon: UIImage?, imageSize: CGSize) {
        self.addSubview(mIconImageView)
        mIconImageView.snp.makeConstraints { (make) in
            make.left.centerY.equalToSuperview()
        }

        self.addSubview(mTitleLable)
        mTitleLable.snp.makeConstraints { (make) in
            make.left.equalTo(mIconImageView.snp.right).offset(6)
            make.centerY.equalToSuperview()
        }

        self.addSubview(mTextField)
        mTextField.snp.makeConstraints { (make) in
            make.left.equalTo(mTitleLable.snp.right).offset(13)
            make.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }

        if let icon = icon {
            mIconImageView.image = icon
            mIconImageView.snp.makeConstraints { (make) in
                make.width.equalTo(imageSize.width)
                make.height.equalTo(imageSize.height)
            }
        } else {
            mIconImageView.snp.makeConstraints { (make) in
                make.width.height.equalTo(0)
            }
        }

        mTitleLable.text = title
        if title == nil {
            mTextField.snp.updateConstraints { (make) in
                make.left.equalTo(mTitleLable.snp.right)
            }
        }
    }
}
