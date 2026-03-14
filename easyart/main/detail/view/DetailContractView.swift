//
//  DetailContractView.swift
//  easyart
//
//  Created by Damon on 2024/9/14.
//

import UIKit
import SnapKit

class DetailContractView: DDView {
    private var bottomConstraint: Constraint?
    var isExpand = false {
        didSet {
            self.mContractButton.isSelected = isExpand
            self.mIntroLabel.isHidden = isExpand
            self.mContentView.isHidden = !isExpand
            
            self.bottomConstraint?.deactivate()
            self.snp.makeConstraints { make in
                if isExpand {
                    self.bottomConstraint = make.bottom.equalTo(mContentView).constraint
                } else {
                    self.bottomConstraint = make.bottom.equalTo(mIntroLabel).constraint
                }
            }
        }
    }    //是否展开
    
    override func createUI() {
        super.createUI()
        self.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        self.addSubview(mIntroLabel)
        mIntroLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(mTitleLabel.snp.bottom).offset(8)
            self.bottomConstraint = make.bottom.equalToSuperview().constraint
        }
        
        self.addSubview(mContentView)
        mContentView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(mTitleLabel.snp.bottom).offset(8)
            make.height.greaterThanOrEqualTo(10)
        }
        
        self.addSubview(mContractButton)
        mContractButton.snp.makeConstraints { make in
            make.centerY.equalTo(mTitleLabel)
            make.right.equalToSuperview()
            make.width.height.equalTo(10)
        }
        
        self._bindView()
    }
    
    func updateUI(title: String, intro: String, contentView: [UIView]) {
        self.mTitleLabel.text = title
        //简介
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.3
        let attributedString = NSAttributedString(string: intro, attributes: [.foregroundColor: ThemeColor.gray.color(), NSAttributedString.Key.paragraphStyle : paragraphStyle])
        self.mIntroLabel.attributedText = attributedString
        
        for view in self.mContentView.subviews {
            view.removeFromSuperview()
        }
        //布局
        var posView: UIView?
        for i in 0..<contentView.count {
            let view = contentView[i]
            self.mContentView.addSubview(view)
            view.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                if let posView = posView {
                    make.top.equalTo(posView.snp.bottom)
                } else {
                    make.top.equalToSuperview()
                }
                if i == contentView.count - 1 {
                    make.bottom.equalToSuperview()
                }
            }
            posView = view
        }
    }

    //MARK: UI
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.black.color()
        return label
    }()

    lazy var mIntroLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = ThemeColor.gray.color()
        return label
    }()
    
    lazy var mContentView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    lazy var mContractButton: UIButton = {
        let button = UIButton(type: .custom)
        button.imageView?.contentMode = .scaleAspectFit
        button.isUserInteractionEnabled = false
        button.isSelected = false
        button.setImage(UIImage(named: "home_folded"), for: .normal)
        button.setImage(UIImage(named: "home_unFolded"), for: .selected)
        return button
    }()
}

extension DetailContractView {
    func _bindView() {
        let tap = UITapGestureRecognizer()
        _ = tap.rx.event.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.isExpand = !self.isExpand
        })
        self.addGestureRecognizer(tap)
    }
}
