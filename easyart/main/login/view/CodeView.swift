//
//  CodeView.swift
//  HiTalk
//
//  Created by Damon on 2024/6/3.
//

import UIKit
import RxRelay

class CodeView: DDView {
    let mClickRelay = PublishRelay<Void>()
    private var mTimer: Timer?
    private var leftTime: Int = 0
    
    override func createUI() {
        super.createUI()
        
        self.addSubview(mCodeButton)
        mCodeButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self._bindView()
    }
    
    //MARK: UI
    private lazy var mCodeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = ThemeColor.black.color()
        button.setTitle("Send verification code".localString, for: .normal)
        button.setTitleColor(UIColor.dd.color(hexValue: 0xffffff), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        return button
    }()
    
}

extension CodeView {
    func startCountDown() {
        self.mTimer?.invalidate()
        self.leftTime = 60
        self.mTimer = Timer(timeInterval: 1, repeats: true, block: { [weak self] timer in
            guard let self = self else { return }
            self.leftTime = self.leftTime - 1
            if self.leftTime > 0 {
                self.mCodeButton.setTitle("Resend".localString + " \(self.leftTime) s", for: .normal)
                self.mCodeButton.backgroundColor = UIColor.dd.color(hexValue: 0x171619, alpha: 0.8)
            } else {
                self.reset()
            }
        })
        RunLoop.main.add(self.mTimer!, forMode: .common)
        self.mTimer?.fire()
    }
    
    func reset() {
        self.mCodeButton.setTitle("Send verification code".localString, for: .normal)
        self.mCodeButton.backgroundColor = ThemeColor.black.color()
        self.mTimer?.invalidate()
    }
}

private extension CodeView {
    func _bindView() {
        _ = mCodeButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            if self.leftTime <= 0 {
                self.mClickRelay.accept(())
            }
        })
    }
}
