//
//  DDPageControl.swift
//  easyart
//
//  Created by Damon on 2024/10/28.
//

import UIKit

class DDPageControl: UIPageControl {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.pageIndicatorTintColor = UIColor.dd.color(hexValue: 0xE6E6E6, alpha: 0.6)
        self.currentPageIndicatorTintColor = UIColor.dd.color(hexValue: 0x1053FF)
        if #available(iOS 14.0, *) {
            self.preferredIndicatorImage = UIImage.dd.getImage(color: UIColor.dd.color(hexValue: 0xE6E6E6, alpha: 0.6), size: CGSize(width: 5, height: 4))
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 16.0, *) {
            self.preferredCurrentPageIndicatorImage = UIImage.dd.getImage(color: UIColor.dd.color(hexValue: 0x1053FF), size: CGSize(width: 5, height: 4))
        } else {
            // Fallback on earlier versions
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
