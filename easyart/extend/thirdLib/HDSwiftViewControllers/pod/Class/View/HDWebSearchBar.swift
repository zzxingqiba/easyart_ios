//
//  HDWebSearchBar.swift
//  HDSwiftViewControllers
//
//  Created by Damon on 2021/3/1.
//  Copyright © 2021 Damon. All rights reserved.
//

import UIKit
import DDUtils
import RxSwift

class HDWebSearchBar: UIView {
    let mCloseSubject = PublishSubject<Void>()  //关闭
    let mJumpSubject = PublishSubject<Bool>()   //跳转，是否跳转下一个
    let mConfirmSubject = PublishSubject<String>() //搜索

    var mCurrent: Int = 0 {
        willSet {
            mCountLabel.text = "\(newValue >= 0 ? newValue : 0)/\(mTotal)"
        }
    }

    var mTotal: Int = 0 {
        willSet {
            mCountLabel.text = "\(mCurrent)/\(newValue >= 0 ? newValue : 0)"
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.p_createUI()
        self.p_bindView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: UI
    private lazy var mCloseButton: UIButton = {
        let tButton = UIButton(type: .custom)
        tButton.setTitle("取消".ZXLocaleString, for: .normal)
        tButton.titleLabel?.font = .systemFont(ofSize: 14)
        tButton.setTitleColor(UIColor.dd.color(hexValue: 0x666666), for: .normal)
        return tButton
    }()

    private lazy var mTextField: UITextField = {
        let tTextField = UITextField()
        tTextField.font = .systemFont(ofSize: 14)
        tTextField.backgroundColor = UIColor.dd.color(hexValue: 0xffffff)
        tTextField.layer.cornerRadius = 4
        return tTextField
    }()

    private lazy var mCountLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.textColor = UIColor.dd.color(hexValue: 0x999999)
        tLabel.font = .systemFont(ofSize: 10)
        return tLabel
    }()

    private lazy var mUpButton: UIButton = {
        let tButton = UIButton(type: .custom)
        tButton.setImage(UIImageHDVCBoundle(named: "icon_black_up"), for: .normal)
        return tButton
    }()

    private lazy var mDownButton: UIButton = {
        let tButton = UIButton(type: .custom)
        tButton.setImage(UIImageHDVCBoundle(named: "icon_black_down"), for: .normal)
        return tButton
    }()

}

private extension HDWebSearchBar {
    func p_createUI() {
        self.backgroundColor = UIColor.dd.color(hexValue: 0xeeeeee)
        self.snp.makeConstraints { (make) in
            make.width.equalTo(UIScreenWidth)
            make.height.equalTo(40)
        }

        self.addSubview(mCloseButton)
        mCloseButton.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(50)
        }

        self.addSubview(mTextField)
        mTextField.snp.makeConstraints { (make) in
            make.left.equalTo(mCloseButton.snp.right)
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
            make.right.equalToSuperview().offset(-80)
        }

        self.addSubview(mCountLabel)
        mCountLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(mTextField)
            make.right.equalTo(mTextField).offset(-5)
        }

        self.addSubview(mUpButton)
        mUpButton.snp.makeConstraints { (make) in
            make.left.equalTo(mTextField.snp.right).offset(10)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(30)
        }

        self.addSubview(mDownButton)
        mDownButton.snp.makeConstraints { (make) in
            make.left.equalTo(mUpButton.snp.right)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(30)
        }
    }

    func p_bindView() {
        _ = self.mCloseButton.rx.tap.subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.mTextField.resignFirstResponder()
            self.mCloseSubject.onNext(())
        })

        _ = self.mUpButton.rx.tap.subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.mTextField.resignFirstResponder()
            self.mJumpSubject.onNext(false)
        })

        _ = self.mDownButton.rx.tap.subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.mTextField.resignFirstResponder()
            self.mJumpSubject.onNext(true)
        })

        _ = self.mTextField.rx.text.subscribe(onNext: { (_) in

        })

        _ = self.mTextField.rx.controlEvent(.editingDidEnd).subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            if let string = self.mTextField.text, !string.isEmpty {
                self.mConfirmSubject.onNext(string)
            }
        })
    }
}
