//
//  DDGoodsEditionPopView.swift
//  easyart
//
//  Created by Damon on 2024/11/15.
//

import UIKit
import DDUtils
import SwiftyJSON
import RxSwift
import DDLoggerSwift

class DDGoodsEditionPopView: DDView {
    let mClickSubject = PublishSubject<DDPopButtonClickInfo>()
    
    init() {
        super.init(frame: .zero)
        self._bindView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createUI() {
        super.createUI()
        self.backgroundColor = UIColor.dd.color(hexValue: 0xffffff)
        self.snp.makeConstraints { make in
            make.width.equalTo(UIScreenWidth)
        }
        
        self.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
        
        self.addSubview(mCloseButton)
        mCloseButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalTo(mTitleLabel)
            make.width.height.equalTo(30)
        }
        
        self.addSubview(mDesLabel)
        mDesLabel.snp.makeConstraints { make in
            make.top.equalTo(mTitleLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        self.addSubview(mTipLabel)
        mTipLabel.snp.makeConstraints { make in
            make.top.equalTo(mDesLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        self.addSubview(mConfirmButton)
        mConfirmButton.snp.makeConstraints { make in
            make.top.equalTo(mTipLabel.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-30 - BottomSafeAreaHeight)
        }
    }
    
    
    
    //MARK: UI
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Artwork classifications".localString
        label.font = .systemFont(ofSize: 18)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mDesLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = """
        Unique
        One-of-a-kind piece.
        
        Limited edition
        The edition run has ended: the number of works
        producedis known and included in the listing.

        Open edition
        The edition run is ongoing.New works are still being
        produced, which may be numbered.This includes 
        made to order works.
        """
        label.font = .systemFont(ofSize: 13)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mTipLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = """
        Our partners are responsible for providing accurate
        classificationinformation for all works.
        """
        label.font = .systemFont(ofSize: 13)
        label.textColor = ThemeColor.gray.color()
        return label
    }()
    
    lazy var mCloseButton: DDButton = {
        let button = DDButton()
        button.normalImage = UIImage(named: "home_guanbi")
        button.imageSize = CGSizeMake(16, 16)
        return button
    }()
    
    lazy var mConfirmButton: DDButton = {
        let button = DDButton(imagePosition: .none)
        button.contentType = .center(gap: 0)
        button.mTitleLabel.text = "Confirm".localString
        button.mTitleLabel.font = .systemFont(ofSize: 14)
        button.mTitleLabel.textColor = UIColor.dd.color(hexValue: 0xffffff)
        button.backgroundColor = ThemeColor.black.color()
        return button
    }()

}

extension DDGoodsEditionPopView {
    func _bindView() {
        _ = self.mCloseButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.mClickSubject.onNext(.init(clickType: .close, info: nil))
        })
        
        _ = self.mConfirmButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.mClickSubject.onNext(.init(clickType: .confirm, info: nil))
        })
    }
}
