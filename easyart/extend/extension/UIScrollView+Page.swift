//
//  UIScrollView+Page.swift
//  easyart
//
//  Created by Damon on 2025/6/30.
//

import UIKit

extension UIScrollView {
    func scrollToPage(_ page: Int, animated: Bool = true, isHorizontal: Bool = true) {
        let offset = isHorizontal ? CGPoint(x: CGFloat(page) * self.bounds.width, y: 0) : CGPoint(x: 0, y: CGFloat(page) * self.bounds.height)
        self.setContentOffset(offset, animated: animated)
    }

    var currentPage: Int {
        let page = isPagingEnabled ? Int(round(contentOffset.x / bounds.width)) : 0
        return page
    }
    
    var maxPage: Int {
        guard bounds.width > 0 else { return 0 }
        return Int(self.contentSize.width / bounds.width)
    }
}

