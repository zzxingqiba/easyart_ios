//
//  UIView+Extension.swift
//  Menses
//
//  Created by Damon on 2020/9/28.
//  Copyright © 2020 Damon. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addFinger(tag: Int, offset: CGPoint = CGPoint(x: 5, y: 5)) {
        self.removeFinger()
        self.tag = tag
        let tImageView = UIImageView(image: UIImage(named: "finger"))
        tImageView.isHidden = self.isHidden
        tImageView.addAnimation(animationType: .scale)
        tImageView.tag = self.tag + 1000
        if let superview = self.superview {
            superview.addSubview(tImageView)
            tImageView.snp.makeConstraints { (make) in
                make.left.equalTo(self.snp.centerX).offset(offset.x)
                make.top.equalTo(self.snp.centerY).offset(offset.y)
                make.width.equalTo(20)
                make.height.equalTo(22)
            }
        }
    }
    
    func removeFinger() {
        self.superview?.subviews.forEach { view in
            if view.tag == self.tag + 1000 {
                view.removeFromSuperview()
            }
        }
    }

    func className() -> String {
        return String("\(Self.self)")
    }

    class func className() -> String {
        return String("\(self.self)")
    }
    
    
    

}
