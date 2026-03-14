//
//  UIScrollView+Refresh.swift
//  easyart
//
//  Created by Damon on 2024/11/25.
//

import UIKit
import MJRefresh

extension UIScrollView {
    func addRefreshHeader(complete:  @escaping ()->Void) {
        let header = MJRefreshNormalHeader(refreshingBlock: {
            complete()
        })
        header.lastUpdatedTimeLabel?.isHidden = true
        self.mj_header = header
        
    }
    
    func addRefreshFooter(complete: @escaping ()->Void) {
        let footer = MJRefreshAutoNormalFooter(refreshingBlock: { 
            complete()
        })
        footer.stateLabel?.isHidden = true
        footer.isRefreshingTitleHidden = true
        self.mj_footer = footer
    }
    
    func endReresh() {
        self.mj_header?.endRefreshing()
        self.mj_footer?.endRefreshing()
    }
}
