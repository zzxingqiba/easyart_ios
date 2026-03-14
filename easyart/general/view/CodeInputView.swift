//
//  CodeInputView.swift
//  HiTalk
//
//  Created by Damon on 2024/6/20.
//

import UIKit

class CodeInputView: DDView, UIKeyInput {
    open var delegate: CodeInputViewDelegate?
    private var nextTag = 1
    private let maxCount = 4
    
    // MARK: - UIResponder
    
    open override var canBecomeFirstResponder: Bool { true }
    
    override func createUI() {
        super.createUI()
        
        self.snp.makeConstraints { make in
            make.width.equalTo(45 * maxCount)
            make.height.equalTo(40)
        }
        
        var posView: UIView?
        for index in 1...maxCount {
            let digitLabel = UILabel()
            digitLabel.font = .systemFont(ofSize: 42)
            digitLabel.tag = index
            digitLabel.text = "–"
            digitLabel.textAlignment = .center
            addSubview(digitLabel)
            if let posView = posView {
                digitLabel.snp.makeConstraints { make in
                    make.left.equalTo(posView.snp.right).offset(5)
                    make.centerY.equalToSuperview()
                    make.width.equalTo(40)
                    make.height.equalTo(40)
                }
            } else {
                digitLabel.snp.makeConstraints { make in
                    make.left.equalToSuperview()
                    make.centerY.equalToSuperview()
                    make.width.equalTo(40)
                    make.height.equalTo(40)
                }
            }
            posView = digitLabel
        }
    }
    
    // MARK: - UIKeyInput
    
    public var hasText: Bool { nextTag > 1 ? true : false }
    
    open func insertText(_ text: String) {
        if nextTag <= maxCount {
            (viewWithTag(nextTag)! as! UILabel).text = text
            nextTag += 1
            if nextTag == maxCount + 1 {
                var code = ""
                for index in 1..<nextTag {
                    code += (viewWithTag(index)! as! UILabel).text!
                }
                delegate?.codeInputView(self, didFinishWithCode: code)
            }
            delegate?.codeInputViewDidChange(self)
        }
    }
    
    open func deleteBackward() {
        if nextTag > 1 {
            nextTag -= 1
            (viewWithTag(nextTag)! as! UILabel).text = "–"
            delegate?.codeInputViewDidChange(self)
        }
    }
    
    open func clear() { while nextTag > 1 { deleteBackward() } }
    
    // MARK: - UITextInputTraits
    
    open var keyboardType: UIKeyboardType { get { .numberPad } set { } }
}

protocol CodeInputViewDelegate {
    func codeInputViewDidChange(_ codeInputView: CodeInputView)
    func codeInputView(_ codeInputView: CodeInputView, didFinishWithCode code: String)
}
