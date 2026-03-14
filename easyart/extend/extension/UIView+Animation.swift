//
//  UIView+Animation.swift
//  Menses
//
//  Created by Damon on 2020/8/21.
//  Copyright © 2020 Damon. All rights reserved.
//

import Foundation
import UIKit

enum DDViewAnimationType {
    case scale      //放大缩小
    case transformY //上下
    case shake      //左右晃动
    case rotation   //旋转
}

extension UIView {
    func addAnimation(animationType: DDViewAnimationType, duration: Double = 0.9, repeatCount: Float = MAXFLOAT) {
        switch animationType {
            case .scale:
                let scaleAnimation = CABasicAnimation(keyPath: "transform")
                scaleAnimation.fromValue = NSValue(caTransform3D: CATransform3DMakeScale(0.9, 0.9, 1))
                scaleAnimation.toValue = NSValue(caTransform3D: CATransform3DMakeScale(1.3, 1.3, 1))
                scaleAnimation.duration = duration
                scaleAnimation.isCumulative = false
                scaleAnimation.isRemovedOnCompletion = false
                scaleAnimation.autoreverses = true  //原样返回
                scaleAnimation.repeatCount = repeatCount
                scaleAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
                self.layer.add(scaleAnimation, forKey: "scale")
            case .transformY:
                let transformYAnimation = CABasicAnimation(keyPath: "transform.translation.y")
                transformYAnimation.fromValue = 0
                transformYAnimation.toValue = -15
                transformYAnimation.duration = duration
                transformYAnimation.isCumulative = false
                transformYAnimation.isRemovedOnCompletion = false
                transformYAnimation.autoreverses = true  //原样返回
                transformYAnimation.repeatCount = repeatCount
                transformYAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
                self.layer.add(transformYAnimation, forKey: "transformYAnimation")
            case .shake:
                let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
                rotationAnimation.fromValue = -Double.pi/6.0
                rotationAnimation.toValue = Double.pi/6.0
                rotationAnimation.duration = duration
                rotationAnimation.isCumulative = false
                rotationAnimation.isRemovedOnCompletion = false
                rotationAnimation.autoreverses = true  //原样返回
                rotationAnimation.repeatCount = repeatCount
                rotationAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
                self.layer.add(rotationAnimation, forKey: "normalTurnAnimation")
            case .rotation:
                let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
                rotationAnimation.fromValue = 0
                rotationAnimation.toValue = Double.pi * 2
                rotationAnimation.duration = duration
                rotationAnimation.isCumulative = false
                rotationAnimation.isRemovedOnCompletion = false
                rotationAnimation.repeatCount = repeatCount
                rotationAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
                self.layer.add(rotationAnimation, forKey: "normalTurnAnimation")
        }
    }

    func addBottedline(width: CGFloat, lineColor: UIColor, frame: CGRect) {
        let border = CAShapeLayer()
        border.strokeColor = lineColor.cgColor
        border.fillColor = nil
        border.path = UIBezierPath(rect: frame).cgPath
        border.frame = frame
        border.lineWidth = width
        border.lineCap = .square
        //设置线宽和线间距
        border.lineDashPattern = [4,5]
        self.layer.addSublayer(border)
    }
    
    //旋转动画
    func addRotationAnimation() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = Double.pi * 2
        rotation.duration = 5.0
        rotation.repeatCount = .infinity
        rotation.isRemovedOnCompletion = false
        self.layer.speed = 1.0
        self.layer.add(rotation, forKey: "rotationAnimation")
    }

    
    func pauseAnimation() {
        let pausedTime = self.layer.convertTime(CACurrentMediaTime(), from: nil)
        self.layer.speed = 0.0
        self.layer.timeOffset = pausedTime
    }


    func resumeAnimation() {
        let pausedTime = self.layer.timeOffset
        self.layer.speed = 1.0
        self.layer.timeOffset = 0.0
        self.layer.beginTime = 0.0
        let timeSincePause = self.layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        self.layer.beginTime = timeSincePause
    }
}
