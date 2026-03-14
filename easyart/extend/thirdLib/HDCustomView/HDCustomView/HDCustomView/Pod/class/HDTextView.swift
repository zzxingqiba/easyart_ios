//
//  HDTextView.swift
//  SleepClient
//
//  Created by Damon on 2020/8/27.
//  Copyright © 2020 Damon. All rights reserved.
//

import UIKit
import DDUtils
import RxSwift
import SnapKit

open class HDTextView: UITextView {

    //设置字体大小和placeholder一样
    open override var font: UIFont? {
        willSet {
            self.mPlaceHolderLabel.font = newValue
        }
    }

    open var placeholder: String? {
        willSet {
            self.mPlaceHolderLabel.text = newValue
        }
    }

    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self._createUI()
        self._bindView()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: Lazy
    public  lazy var mPlaceHolderLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.numberOfLines = 0
        tLabel.textColor = UIColor.dd.color(hexValue: 0x000000, alpha: 0.2)
        tLabel.font = .systemFont(ofSize: 15)
        return tLabel
    }()
}

private extension HDTextView {
    func _createUI() {
        self.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        self.addSubview(mPlaceHolderLabel)
        mPlaceHolderLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(10)
        }

    }

    func _bindView() {
        _ = self.rx.text.orEmpty.subscribe(onNext: { [weak self] (text) in
            guard let self = self else { return }
            if self.isFirstResponder {
                self.mPlaceHolderLabel.isHidden = true
            } else {
                self.mPlaceHolderLabel.isHidden = !text.isEmpty
            }
        })

        _ = self.rx.didBeginEditing.subscribe(onNext: { [weak self] (_) in
            self?.mPlaceHolderLabel.isHidden = true
        })

        _ = self.rx.didEndEditing.subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            if let text = self.text, !text.isEmpty {
                self.mPlaceHolderLabel.isHidden = true
            } else {
                self.mPlaceHolderLabel.isHidden = false
            }
            self.setContentOffset(.zero, animated: true)
        })
    }
}
