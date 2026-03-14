//
//  DDButton.swift
//  SpeakPal
//
//  Created by Damon on 2024/9/4.
//

import UIKit

enum ImagePosition {
    case none
    case left
    case right
}

enum ContentType {
    case left(gap: Int)     //需要设置宽高，内容居左
    case center(gap: Int)   //需要设置宽高，内容居中
    case between(insert: UIEdgeInsets)  //需要设置宽高，内容between
    case contentFit(padding: UIEdgeInsets, gap: Int)    //根据内容，自适应宽
}

class DDButton: UIButton {
    private var mLeftView: UIView = UIView()
    private var mRightView: UIView = UIView()
    var contentType = ContentType.center(gap: 5) {
        didSet {
            self._createUI()
        }
    }
    
    init(imagePosition: ImagePosition = .left) {
        super.init(frame: .zero)
        if imagePosition == .left {
            self.mLeftView = self.mImageView
            self.mRightView = self.mTitleLabel
        } else {
            self.mLeftView = self.mTitleLabel
            self.mRightView = self.mImageView
        }
        if imagePosition == .none {
            self.imageSize = .zero
            self.contentType = .center(gap: 0)
        }
        self.addSubview(mContentView)
        mContentView.addSubview(self.mLeftView)
        mContentView.addSubview(self.mRightView)
        self._createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var normalImage: UIImage? {
        didSet {
            self.mImageView.image = isSelected ? selectedImage : normalImage
        }
    }
    var selectedImage: UIImage? {
        didSet {
            self.mImageView.image = isSelected ? selectedImage : normalImage
        }
    }
    
    override var isSelected: Bool {
        didSet {
            self.mImageView.image = isSelected ? selectedImage : normalImage
        }
    }
    
    
    
    var imageSize = CGSize(width: 30, height: 30) {
        willSet {
            self.mImageView.snp.updateConstraints { make in
                make.width.equalTo(newValue.width)
                make.height.equalTo(newValue.height)
            }
        }
    }

    func _createUI() {
        self.mContentView.snp.removeConstraints()
        self.mLeftView.snp.removeConstraints()
        self.mRightView.snp.removeConstraints()
        
        switch self.contentType {
        case .left(gap: let gap):
            self.mLeftView.snp.makeConstraints { make in
                make.left.equalToSuperview()
                make.centerY.equalToSuperview()
            }
            self.mRightView.snp.makeConstraints { make in
                make.left.equalTo(self.mLeftView.snp.right).offset(gap)
                make.centerY.equalToSuperview()
            }
            mContentView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        case .center(gap: let gap):
            self.mLeftView.snp.makeConstraints { make in
                make.left.equalToSuperview()
                make.centerY.equalToSuperview()
            }
            self.mRightView.snp.makeConstraints { make in
                make.left.equalTo(self.mLeftView.snp.right).offset(gap)
                make.centerY.equalToSuperview()
                make.right.equalToSuperview()
            }
            mContentView.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        case .between(insert: let insert):
            self.mLeftView.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(insert.left)
            }
            self.mRightView.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(-insert.right)
            }
            mContentView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        case .contentFit(padding: let padding, gap: let gap):
            self.mLeftView.snp.makeConstraints { make in
                make.left.equalToSuperview()
                make.top.equalToSuperview()
                make.bottom.equalToSuperview()
            }
            self.mRightView.snp.makeConstraints { make in
                make.left.equalTo(self.mLeftView.snp.right).offset(gap)
                make.top.equalToSuperview()
                make.bottom.equalToSuperview()
                make.right.equalToSuperview()
            }
            
            mContentView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(padding.left)
                make.right.equalToSuperview().offset(-padding.right)
                make.top.equalToSuperview().offset(padding.top)
                make.bottom.equalToSuperview().offset(-padding.bottom)
            }
        }
        
        mImageView.snp.makeConstraints { make in
            make.width.equalTo(imageSize.width)
            make.height.equalTo(imageSize.height)
        }
    }
    
    //MARK: UI
    lazy var mContentView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        return view
    }()
    lazy var mImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: ""))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 14)
        label.textColor = .dd.color(hexValue: 0x000000)
        return label
    }()

}
