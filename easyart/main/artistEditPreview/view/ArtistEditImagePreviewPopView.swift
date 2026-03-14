//
//  ArtistEditImagePreviewPopView.swift
//  easyart
//
//  Created by Damon on 2025/6/30.
//

import UIKit
import RxRelay

class ArtistEditImagePreviewPopView: DDView {
    let clickPublish = PublishRelay<Void>()
    private var mImageList = [String]()
    
    override func createUI() {
        super.createUI()
        self.snp.makeConstraints { make in
            make.width.equalTo(350)
            make.height.equalTo(600)
        }
        self.addSubview(mScrollView)
        mScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        mScrollView.addSubview(mContentView)
        mContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        self.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(18)
            make.centerX.equalToSuperview()
        }
        
        self.addSubview(mLeftButton)
        mLeftButton.snp.makeConstraints { make in
            make.centerY.equalTo(mTitleLabel)
            make.left.equalToSuperview().offset(10)
            make.width.height.equalTo(40)
        }
        
        self.addSubview(mRightButton)
        mRightButton.snp.makeConstraints { make in
            make.centerY.equalTo(mTitleLabel)
            make.right.equalToSuperview().offset(-10)
            make.width.height.equalTo(40)
        }
        
        self.addSubview(mCloseButton)
        mCloseButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(22)
            make.width.height.equalTo(44)
        }
        
        self._bindView()
    }
    
    func updateUI(imageList: [String]) {
        self.mImageList = imageList
        for view in self.mContentView.subviews {
            view.removeFromSuperview()
        }
        var posView: UIView?
        for i in 0..<imageList.count {
            let view = self._createContent(index: i)
            self.mContentView.addSubview(view)
            view.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.width.equalTo(350)
                if let pos = posView {
                    make.left.equalTo(pos.snp.right)
                } else {
                    make.left.equalToSuperview()
                }
                if i == imageList.count - 1 {
                    make.right.equalToSuperview()
                }
            }
            posView = view
        }
        self._loadTitle(index: 0)
    }
    
    //MARK: UI
    lazy var mScrollView: UIScrollView = {
        let view = UIScrollView()
        view.delegate = self
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        return view
    }()
    
    lazy var mContentView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var mLeftButton: DDButton = {
        let button = DDButton()
        button.imageSize = CGSizeMake(20, 20)
        button.normalImage = UIImage(named: "icon-preview-left")
        button.contentType = .center(gap: 0)
        return button
    }()
    
    lazy var mRightButton: DDButton = {
        let button = DDButton()
        button.imageSize = CGSizeMake(20, 20)
        button.normalImage = UIImage(named: "icon-preview-right")
        button.contentType = .center(gap: 0)
        return button
    }()
    
    lazy var mCloseButton: DDButton = {
        let button = DDButton(imagePosition: .none)
        button.contentType = .center(gap: 0)
        button.imageSize = CGSizeMake(36, 36)
        button.normalImage = UIImage(named: "icon-preview-close")
        return button
    }()
    
    lazy var mTitleLabel: PaddingLabel = {
        let label = PaddingLabel(withInsets: 10, 10, 16, 16)
        label.textColor = UIColor.dd.color(hexValue: 0xffffff)
        label.font = .systemFont(ofSize: 13)
        label.backgroundColor = ThemeColor.black.color()
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 18
        return label
    }()
}

private extension ArtistEditImagePreviewPopView {
    func _createContent(index: Int) -> UIView {
        let view = UIView()
        view.snp.makeConstraints { make in
            make.width.equalTo(350)
            make.height.equalTo(600)
        }
        
        let bgView = UIImageView(image: index == 0 ? UIImage(named: "icon-preview-1") : UIImage(named: "icon-preview-2"))
        view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let imageUrl = self.mImageList[index]
        let imageView = UIImageView()
        imageView.kf.setImage(with: URL(string: imageUrl))
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset( index == 0 ? 115 : 83)
            make.height.equalTo(340)
        }
        
        return view
    }
    
    func _bindView() {
        _ = self.mLeftButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            if self.mScrollView.currentPage > 0 {
                self.mScrollView.scrollToPage(self.mScrollView.currentPage - 1)
                self._loadTitle(index: self.mScrollView.currentPage)
            }
        })
        
        _ = self.mRightButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            if self.mScrollView.currentPage < self.mScrollView.maxPage {
                self.mScrollView.scrollToPage(self.mScrollView.currentPage + 1)
                self._loadTitle(index: self.mScrollView.currentPage)
            }
        })
        
        _ = self.mCloseButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.clickPublish.accept(())
        })
    }
    
    func _loadTitle(index: Int) {
        if index == 0 {
            self.mTitleLabel.text = "Preview - Cover".localString + " \(index + 1)/\(self.mImageList.count)"
        } else if index == 1 {
            self.mTitleLabel.text = "Preview - Artwork image".localString + " \(index + 1)/\(self.mImageList.count)"
        } else {
            self.mTitleLabel.text = "Preview - Artwork details".localString + " \(index + 1)/\(self.mImageList.count)"
        }
        self.mLeftButton.isHidden = index == 0
        self.mRightButton.isHidden = index == self.mScrollView.maxPage - 1
    }
}

extension ArtistEditImagePreviewPopView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self._loadTitle(index: scrollView.currentPage)
    }
}
