//
//  DDNewButton.swift
//  easyart
//
//  Created by 崭新的旧刀 on 2026/3/19.
//

import UIKit
import SnapKit

enum ImagePositionFixed {
    case none
    case left
    case right
}

enum ContentTypeFixed {
    case left(gap: Int)
    case center(gap: Int)
    case between(insert: UIEdgeInsets)
    case contentFit(padding: UIEdgeInsets, gap: Int)
}

class DDButtonFixed: UIButton {
    private var mLeftView: UIView = UIView()
    private var mRightView: UIView = UIView()
    private var imagePosition: ImagePositionFixed = .left
    
    var contentType = ContentTypeFixed.center(gap: 5) {
        didSet {
            self._createUI()
        }
    }
    
    init(imagePosition: ImagePositionFixed = .left) {
        self.imagePosition = imagePosition
        super.init(frame: .zero)
        
        switch imagePosition {
        case .none:
            // 纯文字：只显示文字，不添加图片视图
            mLeftView = mTitleLabel
            mImageView.isHidden = true
            contentType = .center(gap: 0)
            
        case .left:
            mLeftView = mImageView
            mRightView = mTitleLabel
            
        case .right:
            mLeftView = mTitleLabel
            mRightView = mImageView
        }
        
        addSubview(mContentView)
        mContentView.addSubview(mLeftView)
        
        // 只有非 .none 模式才添加右侧视图
        if imagePosition != .none {
            mContentView.addSubview(mRightView)
        }
        
        _createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var normalImage: UIImage? {
        didSet {
            mImageView.image = isSelected ? selectedImage : normalImage
        }
    }
    
    var selectedImage: UIImage? {
        didSet {
            mImageView.image = isSelected ? selectedImage : normalImage
        }
    }
    
    override var isSelected: Bool {
        didSet {
            mImageView.image = isSelected ? selectedImage : normalImage
        }
    }
    
    var imageSize = CGSize(width: 30, height: 30) {
        didSet {
            mImageView.snp.remakeConstraints { make in
                make.width.equalTo(imageSize.width)
                make.height.equalTo(imageSize.height)
            }
        }
    }
    
    func _createUI() {
        mContentView.snp.removeConstraints()
        mLeftView.snp.removeConstraints()
        mRightView.snp.removeConstraints()
        
        // ✅ 核心修复：只有非 .none 才给图片加约束
        if imagePosition != .none {
            mImageView.snp.remakeConstraints { make in
                make.width.equalTo(imageSize.width)
                make.height.equalTo(imageSize.height)
            }
        }
        
        switch contentType {
        case .left(let gap):
            mLeftView.snp.makeConstraints { make in
                make.left.centerY.equalToSuperview()
            }
            if imagePosition != .none {
                mRightView.snp.makeConstraints { make in
                    make.left.equalTo(mLeftView.snp.right).offset(gap)
                    make.centerY.equalToSuperview()
                }
            }
            mContentView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
        case .center(let gap):
            mLeftView.snp.makeConstraints { make in
                make.left.centerY.equalToSuperview()
            }
            if imagePosition != .none {
                mRightView.snp.makeConstraints { make in
                    make.left.equalTo(mLeftView.snp.right).offset(gap)
                    make.centerY.right.equalToSuperview()
                }
            } else {
                mLeftView.snp.makeConstraints { make in
                    make.right.equalToSuperview()
                }
            }
            mContentView.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
            
        case .between(let insert):
            mLeftView.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(insert.left)
            }
            if imagePosition != .none {
                mRightView.snp.makeConstraints { make in
                    make.centerY.equalToSuperview()
                    make.right.equalToSuperview().offset(-insert.right)
                }
            }
            mContentView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
        case .contentFit(let padding, let gap):
            mLeftView.snp.makeConstraints { make in
                make.left.top.bottom.equalToSuperview()
            }
            if imagePosition != .none {
                mRightView.snp.makeConstraints { make in
                    make.left.equalTo(mLeftView.snp.right).offset(gap)
                    make.top.bottom.right.equalToSuperview()
                }
            } else {
                mLeftView.snp.makeConstraints { make in
                    make.right.equalToSuperview()
                }
            }
            mContentView.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(padding)
            }
        }
    }
    
    // MARK: - UI
    lazy var mContentView: UIView = {
        let v = UIView()
        v.isUserInteractionEnabled = false
        return v
    }()
    
    lazy var mImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var mTitleLabel: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.font = .systemFont(ofSize: 14)
        lb.textColor = .black
        return lb
    }()
}
