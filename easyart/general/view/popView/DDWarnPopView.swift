//
//  DDWarnPopView.swift
//  HiTalk
//
//  Created by Damon on 2024/8/5.
//

import UIKit
import DDUtils
import RxSwift

class DDWarnPopView: DDView {
    let mClickSubject = PublishSubject<DDPopButtonClickInfo>()
    var showSecondButton = false {
        didSet {
            self.mSecondButton.isHidden = !showSecondButton
            self.mSecondButton.snp.updateConstraints { make in
                make.top.equalTo(mFirstButton.snp.bottom).offset(showSecondButton ? 20 : 0)
                make.height.equalTo(showSecondButton ? 50 : 0)
            }
        }
    }
    
    public convenience init(title: String?, content: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.2
        paragraphStyle.alignment = .left
        let attributed = NSAttributedString(string: content, attributes: [NSAttributedString.Key.paragraphStyle : paragraphStyle])
        self.init(title: title, content: attributed)
    }

    public init(title: String?, content: NSAttributedString) {
        super.init(frame: .zero)
        self._bindView()
        self.mTitleLabel.text = title
        self.mDesLabel.attributedText = content
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createUI() {
        super.createUI()
        self.backgroundColor = ThemeColor.white.color()
        self.snp.makeConstraints { make in
            make.width.equalTo(340)
        }
        
        self.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(50)
            make.centerX.equalToSuperview()
        }
        
        self.addSubview(mDesLabel)
        mDesLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(26)
            make.right.equalToSuperview().offset(-26)
            make.top.equalTo(mTitleLabel.snp.bottom).offset(30)
        }
        
        self.addSubview(mFirstButton)
        mFirstButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(26)
            make.right.equalToSuperview().offset(-26)
            make.top.equalTo(mDesLabel.snp.bottom).offset(30)
            make.height.equalTo(50)
        }
        
        self.addSubview(mSecondButton)
        mSecondButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(26)
            make.right.equalToSuperview().offset(-26)
            make.top.equalTo(mFirstButton.snp.bottom).offset(0)
            make.height.equalTo(0)
            make.bottom.equalToSuperview().offset(-50)
        }
        
        self.addSubview(mCloseButton)
        mCloseButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(14)
            make.top.equalToSuperview().offset(14)
            make.width.height.equalTo(24)
        }
    }

    //MARK: UI
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Notice".localString
        label.font = .systemFont(ofSize: 18)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mDesLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mCloseButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "home_guanbi"), for: .normal)
        return button
    }()
    
    lazy var mFirstButton: UIButton = {
        let tButton = UIButton(type: .custom)
        tButton.setBackgroundImage(UIImage.dd.getImage(color: ThemeColor.black.color()), for: .normal)
        tButton.setBackgroundImage(UIImage.dd.getImage(color: ThemeColor.gray.color()), for: .disabled)
        tButton.titleLabel?.font = .systemFont(ofSize: 14)
        tButton.setTitleColor(UIColor.dd.color(hexValue: 0xffffff), for: .normal)
        tButton.setTitle("OK".localString, for: .normal)
        return tButton
    }()
    
    lazy var mSecondButton: UIButton = {
        let tButton = UIButton(type: .custom)
        tButton.isHidden = true
        tButton.backgroundColor = UIColor.white
        tButton.titleLabel?.font = .systemFont(ofSize: 14)
        tButton.setTitleColor(ThemeColor.black.color(), for: .normal)
        tButton.layer.borderColor = ThemeColor.black.color().cgColor
        tButton.layer.borderWidth = 0.5
        tButton.setTitle("取消".localString, for: .normal)
        return tButton
    }()
}

extension DDWarnPopView {
    func _bindView() {
        _ = self.mCloseButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.mClickSubject.onNext(DDPopButtonClickInfo(clickType: .close, info: nil))
        })
        
        _ = self.mFirstButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.mClickSubject.onNext(DDPopButtonClickInfo(clickType: .confirm, info: nil))
        })
        
        _ = self.mSecondButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.mClickSubject.onNext(DDPopButtonClickInfo(clickType: .cancel, info: nil))
        })
    }
}
