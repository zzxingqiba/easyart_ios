//
//  HDTextField.swift
//  lazypigLibrary
//
//  Created by Damon on 2021/2/5.
//  Copyright © 2021 Damon. All rights reserved.
//

import UIKit
import DDUtils
import RxCocoa
import RxSwift
import SnapKit

func UIImageHDCustomBoundle(named: String?) -> UIImage? {
    guard let name = named else { return nil }
    guard let bundlePath = Bundle(for: HDTextField.self).path(forResource: "HDCustomView", ofType: "bundle") else { return nil }
    let bundle = Bundle(path: bundlePath)
    return UIImage(named: name, in: bundle, compatibleWith: nil)
}


open class HDTextField: UITextField {
    public let clearSubject = PublishSubject<()>()
    public var errorText = "输入错误"       //错误提示信息
    public var bottomDefaultColor = UIColor.dd.color(hexValue: 0x666666, alpha: 0.4) {
        didSet {
            self.mBottomLine.backgroundColor = bottomDefaultColor
        }
    }      //底部颜色
    public var bottomHighlightColor = UIColor.dd.color(hexValue: 0x23AAFF)      //底部颜色

    public var errorStatus = false {
        willSet {
            if newValue {
                self.text = errorText
                self.mClearButton.isHidden = true
                self.defaultTextColor = self.textColor //记录原来的文字颜色
                self.textColor = UIColor.dd.color(hexValue: 0xFF5858)
                self.shake()
                self.resignFirstResponder()
            } else {
                if let color = self.defaultTextColor {
                    self.textColor = color
                }
            }
        }
    }

    //private
    private var defaultTextColor: UIColor?

    public override init(frame: CGRect) {
        super.init(frame: frame)

        self._createUI()
        self._bindView()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: Lazy
    public private(set) lazy var mClearButton: UIButton = {
        let tButton = UIButton(type: .custom)
        tButton.setImage(UIImageHDCustomBoundle(named: "ic_black_delete"), for: .normal)
        return tButton
    }()

    private lazy var mBottomLine: UIView = {
        let tView = UIView()
        tView.backgroundColor = self.bottomDefaultColor
        return tView
    }()
}

private extension HDTextField {
    func _createUI() {
        //自己的样式
        self.rightViewMode = .always
        self.rightView = self.mClearButton
        self.font = .systemFont(ofSize: 14)
        self.textColor = UIColor.dd.color(hexValue: 0x000000)

        self.addSubview(mClearButton)
        mClearButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
            make.width.height.equalTo(25)
        }

        self.addSubview(mBottomLine)
        mBottomLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }

    func _bindView() {
        _ = mClearButton.rx.tap.subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.text = nil
            self.errorStatus = false
            self.mClearButton.isHidden = true
            self.mBottomLine.backgroundColor = self.bottomDefaultColor
            self.clearSubject.onNext(())
        })

        _ = self.rx.text.subscribe(onNext: { [weak self] (text) in
            guard let self = self else { return }
            if self.errorStatus == true {
                self.text = nil
                self.errorStatus = false
            }
            if let text = text, !text.isEmpty {
                self.mBottomLine.backgroundColor = self.bottomHighlightColor
                self.mClearButton.isHidden = false
            } else {
                self.mBottomLine.backgroundColor = self.bottomDefaultColor
                self.mClearButton.isHidden = true
            }
        })

        _ = self.rx.controlEvent(.editingDidEnd).subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.mClearButton.isHidden = true
        })
    }
}
