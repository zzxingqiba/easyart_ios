//
//  DDPackageBottomView.swift
//  easyart
//
//  Created by Damon on 2024/11/14.
//

import UIKit
import RxSwift
import RxRelay

class DDPackageBottomView: DDView {
    private var viewModel: DDPackageViewModel
    let clickPublish = PublishRelay<DDPopButtonClickInfo>()
    
    init(viewModel: DDPackageViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createUI() {
        super.createUI()
        self.backgroundColor = ThemeColor.white.color()
        let line = UIView()
        line.backgroundColor = ThemeColor.line.color()
        self.addSubview(line)
        line.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        self.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(130)
        }
        
        self.addSubview(mResetButton)
        mResetButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(mTitleLabel.snp.right)
            make.width.equalTo(75)
        }
        
        self.addSubview(mConfirmButton)
        mConfirmButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(mResetButton.snp.right)
            make.right.equalToSuperview()
        }
        
        self._bindView()
    }
    
    //MARK: UI
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .left
        label.isUserInteractionEnabled = true
        label.font = .systemFont(ofSize: 16)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mResetButton: DDButton = {
        let button = DDButton(imagePosition: .none)
        button.mTitleLabel.text = "Reset".localString
        button.mTitleLabel.textColor = ThemeColor.gray.color()
        button.layer.borderColor = ThemeColor.line.color().cgColor
        button.layer.borderWidth = 1.0
        return button
    }()

    lazy var mConfirmButton: DDButton = {
        let button = DDButton(imagePosition: .none)
        button.backgroundColor = ThemeColor.black.color()
        button.mTitleLabel.text = "Confirm".localString
        button.mTitleLabel.textColor = ThemeColor.white.color()
        return button
    }()
}

extension DDPackageBottomView {
    func _bindView() {
        _ = Observable.combineLatest(self.viewModel.packageIndex.asObservable(), self.viewModel.colorIndex.asObservable(), self.viewModel.paperWIndex.asObservable(), self.viewModel.borderWIndex.asObservable(), self.viewModel.styleIndex.asObservable(), self.viewModel.paddingIndex.asObservable(), self.viewModel.acrylicIndex.asObservable()).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 1.3
            let attr = NSMutableAttributedString(string: "Framing fee".localString + "\n", attributes: [.font: UIFont.systemFont(ofSize: 10), NSAttributedString.Key.paragraphStyle : paragraphStyle])
            let price = NSAttributedString(string: "$ " + self.viewModel.getTotalPrice())
            attr.append(price)
            self.mTitleLabel.attributedText = attr
        })
        
        _ = self.mResetButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.clickPublish.accept(DDPopButtonClickInfo(clickType: .cancel, info: nil))
        })
        
        _ = self.mConfirmButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.clickPublish.accept(DDPopButtonClickInfo(clickType: .confirm, info: nil))
        })
    }
}
