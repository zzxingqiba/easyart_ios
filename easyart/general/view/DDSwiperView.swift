//
//  DDSwiperView.swift
//  easyart
//
//  Created by Damon on 2024/9/13.
//

import UIKit
import Kingfisher
import DDUtils
import SwiftyJSON
import RxRelay
import MJRefresh

class DDSwiperView: DDView {
    let clickPublish = PublishRelay<Int>()
    let scrollPublish = PublishRelay<Int>()
    
    private var mCurrentPage = 0
    private var mScollTimer: Timer?
    private var mList: [String] = []
    /// 是否正在做滑入动作
    private var isSliping: Bool = false
    override func createUI() {
        super.createUI()
        self.addSubview(mGuideScrollView)
        mGuideScrollView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        self.addSubview(mPageControl)
        mPageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-40)
            make.width.equalToSuperview()
            make.height.equalTo(20)
        }
        
        self._bindView()
    }
    var imageContentMode = ContentMode.scaleToFill
    //MARK: UI
    private lazy var mGuideScrollView: UIScrollView = {
        let view = UIScrollView.init()
        view.backgroundColor = UIColor.clear
        view.bounces = false
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.delegate = self
        return view
    }()

    /// 指示器
    public lazy var mPageControl: DDPageControl = {
        var pageControl = DDPageControl()
        return pageControl
    }()
}

extension DDSwiperView {
    func updateUI(list: [String]) {
        mGuideScrollView.setContentOffset(.zero, animated: false)
        self.mList = list
        self.mPageControl.numberOfPages = list.count
        for view in mGuideScrollView.subviews {
            view.removeFromSuperview()
        }
        var posView: UIView?
        for i in 0..<list.count {
            let json = list[i]
            let imageView = UIImageView()
            imageView.isUserInteractionEnabled = true
            imageView.contentMode = self.imageContentMode
            imageView.kf.setImage(with: URL(string: json))
            let tap = UITapGestureRecognizer()
            _ = tap.rx.event.subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.clickPublish.accept(i)
            })
            imageView.addGestureRecognizer(tap)
            mGuideScrollView.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.width.height.equalToSuperview()
                if let posView = posView {
                    make.left.equalTo(posView.snp.right)
                } else {
                    make.left.equalToSuperview()
                }
                if i == list.count - 1 {
                    make.right.equalToSuperview()
                }
            }
            posView = imageView
        }
        //自动滚动
        self.mCurrentPage = 0
        self._resumeTimer()
    }
    
    func _bindView() {

    }
    
    func _resumeTimer() {
        self.mScollTimer?.invalidate()
        mScollTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(autoScrollPage), userInfo: nil, repeats: true)
    }
    
    @objc func autoScrollPage() {
        let maxIndex = self.mList.count - 1
        if mCurrentPage < maxIndex {
            mCurrentPage += 1
        } else {
            mCurrentPage = 0  // 返回到第一页
        }
        let offsetX = CGFloat(mCurrentPage) * UIScreenWidth
        mGuideScrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        self.mPageControl.currentPage = mCurrentPage
        self.scrollPublish.accept(self.mCurrentPage)
    }
}

extension DDSwiperView: UIScrollViewDelegate {
    // 当开始拖拽时暂停定时器
        func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            mScollTimer?.invalidate()  // 暂停定时器
        }

        // 当结束拖拽时恢复定时器
        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            if !decelerate {
                self._resumeTimer()
            }
        }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.mCurrentPage = Int(scrollView.contentOffset.x / scrollView.bounds.size.width)
        // 设置指示器
        self.mPageControl.currentPage = self.mCurrentPage
        self.scrollPublish.accept(self.mCurrentPage)
        self._resumeTimer()
    }
}
