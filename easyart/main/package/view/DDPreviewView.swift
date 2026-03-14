//
//  DDPreviewView.swift
//  easyart
//
//  Created by Damon on 2024/11/5.
//

import UIKit


class DDPreviewView: DDView {
    var viewModel: DDPackageViewModel
    
    init(viewModel: DDPackageViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var imgSize: CGSize = CGSize(width: 190, height: 190) {
        didSet {
            mPreviewImageView.snp.updateConstraints { make in
                make.width.equalTo(imgSize.width)
                make.height.equalTo(imgSize.height)
            }
        }
    }
    
    func updateImageSize(size: CGSize) {
        let defaultSize = CGSize(width: 190, height: 190)
        let defaultRatio = defaultSize.width / defaultSize.height
        let imageRatio = size.width / size.height
        if defaultRatio > imageRatio {
            //更高
            self.imgSize = CGSize(width: imageRatio * defaultSize.height, height: defaultSize.height)
        } else {
            self.imgSize = CGSize(width: defaultSize.width, height: size.height / size.width * defaultSize.width )
        }
    }
    
    
    override func createUI() {
        super.createUI()
        self.backgroundColor = UIColor.dd.color(hexValue: 0xEDEDED)
        self.layer.sublayerTransform = CATransform3DIdentity
        self.addSubview(mContentView)
        
        self.addSubview(mPreviewImageView)
        mPreviewImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(imgSize.width)
            make.height.equalTo(imgSize.height)
        }
        
        mContentView.snp.makeConstraints { make in
            make.center.equalTo(mPreviewImageView)
            make.width.equalTo(self.mPreviewImageView)
            make.height.equalTo(self.mPreviewImageView)
        }
        
        self.addSubview(mBottomLineView)
        self.addSubview(mLeftLineView)
        self.addSubview(mRightLineView)
        self.addSubview(mTopLineView)
        mTopLineView.snp.makeConstraints { make in
            make.left.right.equalTo(mContentView)
            make.bottom.equalTo(mContentView.snp.top)
            make.height.equalTo(0)
        }
        
        mBottomLineView.snp.makeConstraints { make in
            make.left.right.equalTo(mContentView)
            make.top.equalTo(mContentView.snp.bottom)
            make.height.equalTo(0)
        }
        
        mLeftLineView.snp.makeConstraints { make in
            make.top.equalTo(mTopLineView)
            make.bottom.equalTo(mBottomLineView)
            make.right.equalTo(mContentView.snp.left)
            make.width.equalTo(0)
        }
        
        mRightLineView.snp.makeConstraints { make in
            make.top.equalTo(mTopLineView)
            make.bottom.equalTo(mBottomLineView)
            make.left.equalTo(mContentView.snp.right)
            make.width.equalTo(0)
        }
        
        self.addSubview(mMaskView)
        mMaskView.snp.makeConstraints { make in
            make.left.equalTo(mLeftLineView)
            make.right.equalTo(mRightLineView)
            make.top.equalTo(mTopLineView)
            make.bottom.equalTo(mBottomLineView)
        }
        
        self.insertSubview(mBgShadowView, belowSubview: mBottomLineView)
        mBgShadowView.snp.makeConstraints { make in
            make.edges.equalTo(mMaskView)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self._bindView()
    }
    
    //MARK: UI
    lazy var mContentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.dd.color(hexValue: 0xffffff)
        return view
    }()
    
    lazy var mPreviewImageView: UIImageView = {
        let view = UIImageView()
        view.kf.indicatorType = .activity
        view.backgroundColor = UIColor.dd.color(hexValue: 0xffffff)
        view.layer.shadowColor = UIColor.black.cgColor      // 阴影颜色
        view.layer.shadowOpacity = 0.5                     // 阴影透明度
        view.layer.shadowOffset = CGSize(width: 2, height: 2) // 阴影偏移
        view.layer.shadowRadius = 3
        return view
    }()
    
    lazy var mMaskView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    lazy var mBgShadowView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.shadowColor = UIColor.black.cgColor      // 阴影颜色
        view.layer.shadowOpacity = 0.5                     // 阴影透明度
        view.layer.shadowOffset = CGSize(width: 2, height: 2) // 阴影偏移
        view.layer.shadowRadius = 3
        return view
    }()
    
    lazy var mTopLineView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var mRightLineView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var mBottomLineView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var mLeftLineView: UIView = {
        let view = UIView()
        return view
    }()
    
}

private extension DDPreviewView {
    func _reset() {
        mContentView.snp.updateConstraints { make in
            make.width.equalTo(self.mPreviewImageView)
            make.height.equalTo(self.mPreviewImageView)
        }
        self._resetLine()
        self.mContentView.removeInnerShadow()
        mTopLineView.backgroundColor = .clear
        mRightLineView.backgroundColor = .clear
        mBottomLineView.backgroundColor = .clear
        mLeftLineView.backgroundColor = .clear
        mMaskView.layer.borderColor = UIColor.clear.cgColor
    }
    
    func _bindView() {
        _ = self.viewModel.packageIndex.subscribe(onNext: { [weak self] packageIndex in
            guard let self = self else { return }
            if let index = packageIndex {
                let packageID = self.viewModel.packageConfigList.value[index]["id"].intValue
                if packageID == 1 || packageID == 2  {
                    self.mPreviewImageView.layer.shadowOpacity = 0
                    //内阴影
                    self.mPreviewImageView.addInnerShadow()
                }else if packageID == 3 || packageID == 4 || packageID == 5 {
                    self.mPreviewImageView.removeInnerShadow()
                    //外阴影
                    self.mPreviewImageView.layer.shadowOpacity = 0.5      // 阴影颜色
                }
            } else {
                self._reset()
            }
            self._resetLine()
        })
        
        _ = self.viewModel.styleIndex.subscribe(onNext: { [weak self] index in
            guard let self = self else { return }
            self._lineStyle()
        })
        
        _ = self.viewModel.colorIndex.subscribe(onNext: { [weak self] index in
            guard let self = self else { return }
            self.mTopLineView.backgroundColor = self.viewModel.getColor()
            self.mRightLineView.backgroundColor = self.viewModel.getColor()
            self.mBottomLineView.backgroundColor = self.viewModel.getColor()
            self.mLeftLineView.backgroundColor = self.viewModel.getColor()
            self.mMaskView.layer.borderColor = UIColor.clear.cgColor
            self._lineStyle()
        })
        
        _ = self.viewModel.borderWIndex.subscribe(onNext: { [weak self] index in
            guard let self = self, let border = self.viewModel.getBorderW() else { return }
            self.mTopLineView.snp.updateConstraints { make in
                make.height.equalTo(border * 5)
            }
            self.mBottomLineView.snp.updateConstraints { make in
                make.height.equalTo(border * 5)
            }
            self.mLeftLineView.snp.updateConstraints { make in
                make.width.equalTo(border * 5)
            }
            self.mRightLineView.snp.updateConstraints { make in
                make.width.equalTo(border * 5)
            }
        })
        
        _ = self.viewModel.paperWIndex.subscribe(onNext: { [weak self] index in
            guard let self = self, let padding = self.viewModel.getPaperW() else { return }
            self.mContentView.snp.updateConstraints { make in
                make.width.equalTo(self.mPreviewImageView).offset(padding * 10)
                make.height.equalTo(self.mPreviewImageView).offset(padding * 10)
            }
            self.mContentView.addInnerShadow()
            //判断是否是直角或者圆角
            self._lineStyle()
        })
        
        _ = self.viewModel.paddingIndex.subscribe(onNext: { [weak self] index in
            guard let self = self, let padding = self.viewModel.getPadding() else { return }
            self.mContentView.snp.updateConstraints { make in
                make.width.equalTo(self.mPreviewImageView).offset(padding * 10)
                make.height.equalTo(self.mPreviewImageView).offset(padding * 10)
            }
            //contentView增加内阴影
            self.mContentView.addInnerShadow()
            //判断是否是直角或者圆角
            self._lineStyle()
        })
    }
    
    func _resetLine() {
        mTopLineView.removeDiagonalCornerMask()
        mRightLineView.removeDiagonalCornerMask()
        mLeftLineView.removeDiagonalCornerMask()
        mBottomLineView.removeDiagonalCornerMask()
    }
    //
    func _lineStyle() {
        if let style = self.viewModel.getStyle() {
            //border宽度
            let border = (self.viewModel.getBorderW() ?? 1.5) * 5
            self.mTopLineView.snp.updateConstraints { make in
                make.height.equalTo(border)
                make.left.equalTo(mContentView).offset(-border)
                make.right.equalTo(mContentView).offset(border)
            }
            self.mBottomLineView.snp.updateConstraints { make in
                make.height.equalTo(border)
                make.left.equalTo(mContentView).offset(-border)
            }
            self.mLeftLineView.snp.updateConstraints { make in
                make.width.equalTo(border)
            }
            self.mRightLineView.snp.updateConstraints { make in
                make.width.equalTo(border)
            }
            //
            self.mContentView.addInnerShadow()
            self._resetLine()
            
            if style == 1 {
                //直角
                mTopLineView.backgroundColor = self.viewModel.getColor()
                mRightLineView.backgroundColor = self.viewModel.getColor()
                mLeftLineView.backgroundColor = mTopLineView.backgroundColor
                mBottomLineView.backgroundColor = mRightLineView.backgroundColor
                //
                mMaskView.layer.borderWidth = 2
                self.mMaskView.layer.borderColor = self.viewModel.getColor()?.cgColor
            } else if style == 2 {
                //斜角
                mTopLineView.backgroundColor = self.viewModel.getNormalRadiusColor()
                mRightLineView.backgroundColor = self.viewModel.getRadiusColor()
                mLeftLineView.backgroundColor = mTopLineView.backgroundColor
                mBottomLineView.backgroundColor = mRightLineView.backgroundColor
                //切斜角
                mTopLineView.cutDiagonalCorner(corner: .BottomRight, length: CGFloat(border))
                mRightLineView.cutDiagonalCorner(corner: .TopLeft, length: CGFloat(border))
                mLeftLineView.cutDiagonalCorner(corner: .BottomRight, length: CGFloat(border))
                mBottomLineView.cutDiagonalCorner(corner: .TopLeft, length: CGFloat(border))
                //
                mMaskView.layer.borderWidth = 2
                self.mMaskView.layer.borderColor = self.viewModel.getColor()?.cgColor
            }
            
            
        }
    }
}

