//
//  ArtistEditCellView.swift
//  easyart
//
//  Created by Damon on 2025/1/15.
//

import UIKit
import RxRelay

class ArtistEditCellView: DDView {
    let clickPublish = PublishRelay<Void>()
    
    override func createUI() {
        super.createUI()
        self.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(25)
            make.right.equalTo(self.snp.centerX).offset(20)
        }
        
        self.addSubview(mArrowIcon)
        mArrowIcon.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalTo(mTitleLabel)
            make.width.equalTo(5)
            make.height.equalTo(8)
        }
        
        self.addSubview(mDesLabel)
        mDesLabel.snp.makeConstraints { make in
            make.right.equalTo(mArrowIcon.snp.left).offset(-10)
            make.left.equalTo(self.snp.centerX).offset(30)
            make.centerY.equalTo(mArrowIcon)
        }
        
        self.addSubview(mLineView)
        mLineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(mTitleLabel.snp.bottom).offset(25)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        self._bindView()
    }
    
    //MARK: UI
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    private lazy var mDesLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.text = "Please select".localString
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.gray.color()
        return label
    }()
    
    lazy var mArrowIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "icon-arrow-solid"))
        return imageView
    }()
    
    lazy var mLineView: UIView = {
        let line = UIView()
        line.backgroundColor = ThemeColor.line.color()
        return line
    }()

}

extension ArtistEditCellView {
    func setDes(text: String?) {
        if String.isAvailable(text) {
            self.mDesLabel.text = text
            mDesLabel.textColor = ThemeColor.black.color()
        } else {
            self.mDesLabel.text = "Please select".localString
            mDesLabel.textColor = ThemeColor.gray.color()
        }
    }
}

extension ArtistEditCellView{
    func _bindView() {
        let tap = UITapGestureRecognizer()
        _ = tap.rx.event.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.clickPublish.accept(())
        })
        self.addGestureRecognizer(tap)
    }
}
