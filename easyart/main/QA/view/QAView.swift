//
//  QAView.swift
//  easyart
//
//  Created by Damon on 2024/9/24.
//

import UIKit

class QAView: DDView {
    
    override func createUI() {
        super.createUI()
        self.addSubview(mImageBackgrounView)
        mImageBackgrounView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        mImageBackgrounView.addSubview(mIconImageView)
        mIconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(12)
        }
        
        self.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(mImageBackgrounView.snp.right).offset(10)
            make.right.equalToSuperview()
            make.top.equalTo(mImageBackgrounView).offset(3)
            make.bottom.equalToSuperview()
        }
    }

    //MARK: UI
    lazy var mImageBackgrounView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    lazy var mIconImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.black.color()
        return label
    }()

}

extension QAView {
    func updateQuestion(question: String) {
        mImageBackgrounView.backgroundColor = ThemeColor.main.color()
        mIconImageView.image = UIImage(named: "me_Q")
        mTitleLabel.text = question
    }
    
    func updateAnswer(icon: UIImage?, answer: String) {
        mImageBackgrounView.backgroundColor = ThemeColor.gray.color()
        mIconImageView.image = icon
        mTitleLabel.text = answer
    }
}
