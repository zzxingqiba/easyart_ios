//
//  DDOrderTypeTabView.swift
//  easyart
//
//  Created by Damon on 2024/9/26.
//

import UIKit
import RxRelay

class DDOrderTypeTabView: DDView {
    let indexChange = PublishRelay<Int>()
    var selectedIndex: Int = 0 {
        didSet {
            for i in 0..<mContentView.subviews.count {
                let view = mContentView.subviews[i]
                let item = view as! DDOrderTypeTabItemView
                item.isSelected = i == selectedIndex
            }
            indexChange.accept(selectedIndex)
        }
    }
    override func createUI() {
        super.createUI()
        self.addSubview(mScrollView)
        mScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        mScrollView.addSubview(mContentView)
        mContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
    
    //MARK: UI
    lazy var mScrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    lazy var mContentView: UIView = {
        let view = UIView()
        return view
    }()
}

extension DDOrderTypeTabView {
    func updateUI(titleList: [String]) {
        for view in mContentView.subviews {
            view.removeFromSuperview()
        }
        var posView: DDOrderTypeTabItemView?
        for i in 0..<titleList.count {
            let title = titleList[i]
            let view = DDOrderTypeTabItemView(title: title)
            view.isSelected = i == self.selectedIndex
            _ = view.clickPublish.subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.selectedIndex = i
            })
            mContentView.addSubview(view)
            view.snp.makeConstraints { make in
                make.bottom.equalToSuperview()
                if let posView = posView {
                    make.left.equalTo(posView.snp.right).offset(5)
                } else {
                    make.left.equalToSuperview()
                }
                if i == titleList.count - 1 {
                    make.right.equalToSuperview()
                }
            }
            posView = view
        }
    }
}
