//
//  DDCategoryView.swift
//  easyart
//
//  Created by Damon on 2024/9/23.
//

import UIKit
import SwiftyJSON
import RxRelay

class DDCategoryView: DDView {
    let mClickSubject = PublishRelay<String?>()
    
    private var selectedID: String? {
        didSet {
            for view in mContentView.subviews {
                if let itemView = view as? DDCategoryItemView {
                    if let selectedID = selectedID {
                        itemView.isSelected = selectedID == itemView.id
                    } else {
                        itemView.isSelected = false
                    }
                }
            }
        }
    }
    
    override func createUI() {
        super.createUI()
        self.addSubview(mScrollView)
        mScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.mScrollView.addSubview(mContentView)
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


extension DDCategoryView {
    func updateUI(items: [JSON]) {
        for view in mContentView.subviews {
            view.removeFromSuperview()
        }
        var posView: UIView?
        for index in  0..<items.count {
            let item = items[index]
            let itemView = DDCategoryItemView()
            itemView.id = item["id"].stringValue
            itemView.mLabel.text = item["title"].stringValue
            mContentView.addSubview(itemView)
            _ = itemView.mClickSubject.subscribe(onNext: { [weak self] isSelected in
                guard let self = self else { return }
                self.selectedID = isSelected ? itemView.id : nil
                self.mClickSubject.accept(self.selectedID)
            })
            itemView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                if let posView = posView {
                    make.left.equalTo(posView.snp.right).offset(5)
                } else {
                    make.left.equalToSuperview()
                }
                if index == items.count - 1 {
                    make.right.equalToSuperview().offset(-5)
                }
            }
            posView = itemView
        }
    }
}
