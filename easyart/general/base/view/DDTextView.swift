//
//  DDTextView.swift
//  Menses
//
//  Created by Damon on 2020/8/27.
//  Copyright © 2020 Damon. All rights reserved.
//

import UIKit
import DDUtils
import RxSwift

class DDTextView: DDView {
    let startInputSubject = PublishSubject<Void>()
    let confirmSubject = PublishSubject<Void>()
    var maxCount: Int = 40
    
    var text: String {
        set {
            if newValue.isEmpty && !self.isFirstResponder {
                self.mPlaceHolderLabel.isHidden = false
            } else {
                self.mPlaceHolderLabel.isHidden = true
            }
            if newValue.count > self.maxCount {
                self.mTextView.text = newValue.dd.subString(rang: NSRange(location: 0, length: self.maxCount))
            } else {
                self.mTextView.text = newValue
            }
            if self.mNumberLabel.isHidden {
                self.mNumberLabel.text = nil
            } else {
                self.mNumberLabel.text = "\(text.count)/\(maxCount)"
            }
        }
        get {
            return self.mTextView.text ?? ""
        }
    }
    
    var showNumberLabel = true {
        didSet {
            self.mNumberLabel.isHidden = !showNumberLabel
            if showNumberLabel {
                mTextView.snp.updateConstraints { make in
                    make.right.equalToSuperview().offset(-100)
                }
            } else {
                mTextView.snp.updateConstraints { make in
                    make.right.equalToSuperview()
                }
            }
        }
    }
    
    override func createUI() {
        super.createUI()
        self._bindView()
        
        self.addSubview(mTextView)
        mTextView.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-100)
        }
        
        self.addSubview(mPlaceHolderLabel)
        mPlaceHolderLabel.snp.makeConstraints { (make) in
            make.left.equalTo(mTextView)
            make.right.equalTo(mTextView)
            make.centerY.equalToSuperview()
        }
        
        self.addSubview(mNumberLabel)
        mNumberLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
        }
    }

    //MARK: Lazy
    lazy var mTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 14)
        textView.textColor = ThemeColor.black.color()
        textView.delegate = self
        textView.contentInset = .zero
        textView.contentOffset = .zero
        textView.textContainerInset = .zero
        return textView
    }()
    
    lazy var mPlaceHolderLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.numberOfLines = 0
        tLabel.lineBreakMode = .byWordWrapping
        tLabel.textColor = ThemeColor.gray.color().withAlphaComponent(0.5)
        tLabel.font = .systemFont(ofSize: 14)
        return tLabel
    }()

    lazy var mNumberLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.textAlignment = .right
        tLabel.text = "0/\(maxCount)"
        tLabel.textColor = ThemeColor.gray.color()
        tLabel.font = .systemFont(ofSize: 12)
        return tLabel
    }()
}

private extension DDTextView {
    
    func _bindView() {
        
    }
}

extension DDTextView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.mPlaceHolderLabel.isHidden = true
        self.startInputSubject.onNext(())
    }
    
    func textViewDidChange(_ textView: UITextView) {
//        self.text = textView.text
        if textView.text.count > self.maxCount {
            self.mTextView.text = textView.text.dd.subString(rang: NSRange(location: 0, length: self.maxCount))
        } else {
            self.text = textView.text
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.mPlaceHolderLabel.isHidden = String.isAvailable(self.text)
    }
    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if text == "\n" {
//            self.confirmSubject.onNext(())
//            return false
//        }
//        return true
//    }
}
