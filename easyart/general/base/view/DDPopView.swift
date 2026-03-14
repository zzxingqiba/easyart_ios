//
//  DDPopView.swift
//  Menses
//
//  Created by Damon on 2020/7/12.
//  Copyright © 2020 Damon. All rights reserved.
//

import UIKit
import DDUtils
import RxSwift

enum DDPopAnimation {
    case scale
    case bottom
    case bottomToCenter
}

//弹窗上点击的按钮类型
enum DDPopButtonType {
    case confirm
    case cancel
    case close
}

//弹窗上按钮点击的内容
struct DDPopButtonClickInfo {
    var clickType: DDPopButtonType = .confirm
    var info: Any?
}

class DDPopView: UIView, UIGestureRecognizerDelegate {
    
    //点击背景关闭弹窗
    static var mShouldCloseIfClickBG = false    //点击背景是否关闭
    static var mContentOffset = CGPoint.zero    //偏移
    
    //单例对象
    private static let shared = DDPopView()
    
    //显示
    static func show(view: UIView, animationType: DDPopAnimation = .scale, posView: UIView? = nil, superView: UIView? = nil) {
        self.hide()
        var tmpSuperView = superView
        if tmpSuperView == nil {
            tmpSuperView = DDUtils.shared.getCurrentNormalWindow()
        }
        guard let tSuperView = tmpSuperView else { return }
        tSuperView.addSubview(self.shared)
        self.shared.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        //添加背景图
        self.shared.addSubview(self.shared.mBGView)
        self.shared.mBGView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        //添加内容
        self.shared.addSubview(view)
        var superView: UIView =  self.shared
        if let posView = posView {
            superView = posView
        }
        
        //动效
        switch animationType {
        case .scale:
            view.snp.makeConstraints { (make) in
                make.centerX.equalTo(superView).offset(self.mContentOffset.x)
                make.centerY.equalTo(superView).offset(self.mContentOffset.y)
            }
            let scaleAnimation = CABasicAnimation(keyPath: "transform")
            scaleAnimation.fromValue = NSValue(caTransform3D: CATransform3DMakeScale(0, 0, 1))
            scaleAnimation.toValue = NSValue(caTransform3D: CATransform3DMakeScale(1, 1, 1))
            scaleAnimation.isCumulative = false
//            scaleAnimation.isRemovedOnCompletion = false
//            scaleAnimation.repeatCount = 1;
            scaleAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
            
            let opacityAnimation = CABasicAnimation(keyPath: "opacity")
            opacityAnimation.fromValue = 0
            opacityAnimation.toValue = 1
            opacityAnimation.isCumulative = false
//            opacityAnimation.isRemovedOnCompletion = false
//            opacityAnimation.repeatCount = 1;
//            opacityAnimation.fillMode = CAMediaTimingFillMode.forwards
            opacityAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            
            let group = CAAnimationGroup()
            group.duration = 0.3
            group.isRemovedOnCompletion = false
            group.repeatCount = 1
            group.fillMode = CAMediaTimingFillMode.forwards
            group.animations = [scaleAnimation, opacityAnimation]
            
            self.shared.layer.add(opacityAnimation, forKey: "scale")
            view.layer.add(group, forKey: "scale")

        case .bottom:
            view.snp.makeConstraints { (make) in
                make.centerX.equalTo(superView).offset(self.mContentOffset.x)
                make.bottom.equalTo(superView).offset(self.mContentOffset.y)
            }
            
            let transformAnimation = CABasicAnimation(keyPath: "transform.translation.y")
            transformAnimation.fromValue = UIScreenHeight + view.frame.size.height
            transformAnimation.duration = 0.3
            transformAnimation.fillMode = CAMediaTimingFillMode.forwards
            transformAnimation.isCumulative = false
            transformAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transformAnimation.isRemovedOnCompletion = false
            transformAnimation.repeatCount = 1
            view.layer.add(transformAnimation, forKey: "bottom")
            
        case .bottomToCenter:
            view.snp.makeConstraints { (make) in
                make.centerY.equalTo(superView).offset(self.mContentOffset.y)
                make.centerX.equalTo(superView).offset(self.mContentOffset.x)
            }
            
            let transformAnimation = CABasicAnimation(keyPath: "transform.translation.y")
            transformAnimation.fromValue = UIScreenHeight + view.frame.size.height
            transformAnimation.duration = 0.3
            transformAnimation.fillMode = CAMediaTimingFillMode.forwards
            transformAnimation.isCumulative = false
            transformAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transformAnimation.isRemovedOnCompletion = false
            transformAnimation.repeatCount = 1
            view.layer.add(transformAnimation, forKey: "bottomToCenter")
        }
    }
    
    ///隐藏弹窗
    static func hide() {
        for view in self.shared.subviews {
            view.removeFromSuperview()
        }
        self.shared.removeFromSuperview()
        self.mContentOffset = CGPoint.zero
        self.mShouldCloseIfClickBG = false
    }
    
    //MARK: 私有
    @objc func p_bgTap() {
        if Self.mShouldCloseIfClickBG {
            Self.hide()
        }
        self.endEditing(true)
    }
    
    //背景
    lazy var mBGView: UIView = {
        let tView = UIView()
        tView.backgroundColor =  UIColor.dd.color(hexValue: 0x000000, alpha: 0.6)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(p_bgTap))
        tView.addGestureRecognizer(tap)
        return tView
    }()
    
    
 
    
}
