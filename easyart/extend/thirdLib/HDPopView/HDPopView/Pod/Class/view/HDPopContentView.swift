//
//  HDPopContentView.swift
//  HDPopView
//
//  Created by Damon on 2022/11/14.
//

import UIKit
import RxSwift
import RxCocoa
import DDUtils

open class HDPopContentView: UIView {
    //contentView的位置偏移量
    public var contentOffset = CGPoint.zero

    /**点击的发送和接收**/
    //页面点击的回调
    public lazy var clickEvent: Signal<HDPopButtonClickInfo> = {
        return self.clickPublish.asSignal(onErrorJustReturn: HDPopButtonClickInfo(clickType: .cancel))
    }()
    //背景事件的点击回调
    public lazy var backgroundClickEvent: Signal<Void> = {
        return self.backgroundClickPublish.asSignal(onErrorJustReturn: ())
    }()
    //视图是否可见的回调，调用show和hide时触发
    public lazy var visibleChangeEvent: Signal<Bool> = {
        return self.visibleChangePublish.asSignal(onErrorJustReturn: false)
    }()

    //接收按钮点击
    public lazy var clickBinder: Binder<HDPopButtonClickInfo> = Binder(self) { contentView, clickInfo in
        contentView.clickPublish.onNext(clickInfo)
    }
    //接收背景点击
    public lazy var backgroundClickBinder: Binder<Void> = Binder(self) { contentView, _ in
        contentView.backgroundClickPublish.onNext(())
    }

    /**私有变量**/
    private let clickPublish = PublishSubject<HDPopButtonClickInfo>()
    private let backgroundClickPublish = PublishSubject<Void>()
    private var animationType: HDPopAnimation = .none
    let visibleChangePublish = PublishSubject<Bool>()
}

//动画
extension HDPopContentView {
    func animation(animationType: HDPopAnimation = .scale, posView: UIView, anchorPoint: CGPoint? = nil) {
        self.animationType = animationType
        switch animationType {
            case .none:
                let anchor = anchorPoint ?? CGPoint(x: 0.5, y: 0.5)
                self.snp.makeConstraints { (make) in
                    //X布局
                    if anchor.x == 0 {
                        make.left.equalTo(posView).offset(self.contentOffset.x)
                    } else if anchor.x == 0.5 {
                        make.centerX.equalTo(posView).offset(self.contentOffset.x)
                    } else if anchor.x == 1 {
                        make.right.equalTo(posView).offset(self.contentOffset.x)
                    }
                    //Y布局
                    if anchor.y == 0 {
                        make.top.equalTo(posView).offset(self.contentOffset.y)
                    } else if anchor.y == 0.5 {
                        make.centerY.equalTo(posView).offset(self.contentOffset.y)
                    } else if anchor.y == 1 {
                        make.bottom.equalTo(posView).offset(self.contentOffset.y)
                    }
                }
            case .scale:
                let anchor = anchorPoint ?? CGPoint(x: 0.5, y: 0.5)
                self.snp.makeConstraints { (make) in
                    //X布局
                    if anchor.x == 0 {
                        make.left.equalTo(posView).offset(self.contentOffset.x)
                    } else if anchor.x == 0.5 {
                        make.centerX.equalTo(posView).offset(self.contentOffset.x)
                    } else if anchor.x == 1 {
                        make.right.equalTo(posView).offset(self.contentOffset.x)
                    }
                    //Y布局
                    if anchor.y == 0 {
                        make.top.equalTo(posView).offset(self.contentOffset.y)
                    } else if anchor.y == 0.5 {
                        make.centerY.equalTo(posView).offset(self.contentOffset.y)
                    } else if anchor.y == 1 {
                        make.bottom.equalTo(posView).offset(self.contentOffset.y)
                    }
                }
                let scaleAnimation = CABasicAnimation(keyPath: "transform")
                scaleAnimation.fromValue = NSValue(caTransform3D: CATransform3DMakeScale(0, 0, 1))
                scaleAnimation.toValue = NSValue(caTransform3D: CATransform3DMakeScale(1, 1, 1))
                scaleAnimation.isCumulative = false
                scaleAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)

                let opacityAnimation = CABasicAnimation(keyPath: "opacity")
                opacityAnimation.fromValue = 0
                opacityAnimation.toValue = 1
                opacityAnimation.isCumulative = false
                opacityAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)

                let group = CAAnimationGroup()
                group.duration = 0.3
                group.isRemovedOnCompletion = false
                group.repeatCount = 1
                group.fillMode = CAMediaTimingFillMode.forwards
                group.animations = [scaleAnimation, opacityAnimation]

                self.superview?.layer.add(opacityAnimation, forKey: "scale")
                self.layer.add(group, forKey: "scale")
            case .bottom:
                let anchor = anchorPoint ?? CGPoint(x: 0.5, y: 1)
                self.snp.makeConstraints { (make) in
                    //X布局
                    if anchor.x == 0 {
                        make.left.equalTo(posView).offset(self.contentOffset.x)
                    } else if anchor.x == 0.5 {
                        make.centerX.equalTo(posView).offset(self.contentOffset.x)
                    } else if anchor.x == 1 {
                        make.right.equalTo(posView).offset(self.contentOffset.x)
                    }
                    //Y布局
                    if anchor.y == 0 {
                        make.top.equalTo(posView).offset(self.contentOffset.y)
                    } else if anchor.y == 0.5 {
                        make.centerY.equalTo(posView).offset(self.contentOffset.y)
                    } else if anchor.y == 1 {
                        make.bottom.equalTo(posView).offset(self.contentOffset.y)
                    }
                }

                let transformAnimation = CABasicAnimation(keyPath: "transform.translation.y")
                transformAnimation.fromValue = UIScreenHeight + self.frame.size.height
                transformAnimation.duration = 0.3
                transformAnimation.fillMode = CAMediaTimingFillMode.forwards
                transformAnimation.isCumulative = false
                transformAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                transformAnimation.isRemovedOnCompletion = false
                transformAnimation.repeatCount = 1
                self.layer.add(transformAnimation, forKey: "bottom")
            case .bottomToCenter:
                let anchor = anchorPoint ?? CGPoint(x: 0.5, y: 0.5)
                self.snp.makeConstraints { (make) in
                    //X布局
                    if anchor.x == 0 {
                        make.left.equalTo(posView).offset(self.contentOffset.x)
                    } else if anchor.x == 0.5 {
                        make.centerX.equalTo(posView).offset(self.contentOffset.x)
                    } else if anchor.x == 1 {
                        make.right.equalTo(posView).offset(self.contentOffset.x)
                    }
                    //Y布局
                    if anchor.y == 0 {
                        make.top.equalTo(posView).offset(self.contentOffset.y)
                    } else if anchor.y == 0.5 {
                        make.centerY.equalTo(posView).offset(self.contentOffset.y)
                    } else if anchor.y == 1 {
                        make.bottom.equalTo(posView).offset(self.contentOffset.y)
                    }
                }

                let transformAnimation = CABasicAnimation(keyPath: "transform.translation.y")
                transformAnimation.fromValue = UIScreenHeight + self.frame.size.height
                transformAnimation.duration = 0.3
                transformAnimation.fillMode = CAMediaTimingFillMode.forwards
                transformAnimation.isCumulative = false
                transformAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                transformAnimation.isRemovedOnCompletion = false
                transformAnimation.repeatCount = 1
                self.layer.add(transformAnimation, forKey: "bottomToCenter")
            case .right:
                let anchor = anchorPoint ?? CGPoint(x: 1, y: 0.5)
                self.snp.makeConstraints { (make) in
                    //X布局
                    if anchor.x == 0 {
                        make.left.equalTo(posView).offset(self.contentOffset.x)
                    } else if anchor.x == 0.5 {
                        make.centerX.equalTo(posView).offset(self.contentOffset.x)
                    } else if anchor.x == 1 {
                        make.right.equalTo(posView).offset(self.contentOffset.x)
                    }
                    //Y布局
                    if anchor.y == 0 {
                        make.top.equalTo(posView).offset(self.contentOffset.y)
                    } else if anchor.y == 0.5 {
                        make.centerY.equalTo(posView).offset(self.contentOffset.y)
                    } else if anchor.y == 1 {
                        make.bottom.equalTo(posView).offset(self.contentOffset.y)
                    }
                }

                let transformAnimation = CABasicAnimation(keyPath: "transform.translation.x")
                transformAnimation.fromValue = UIScreenWidth + self.frame.size.width
                transformAnimation.duration = 0.3
                transformAnimation.fillMode = CAMediaTimingFillMode.forwards
                transformAnimation.isCumulative = false
                transformAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                transformAnimation.isRemovedOnCompletion = false
                transformAnimation.repeatCount = 1
                self.layer.add(transformAnimation, forKey: "right")
        }
    }

    func closeAnimation(complete: @escaping ((HDPopContentView) -> Void)) {
        let animationType = self.animationType
        switch animationType {
            case .none:
                complete(self)
            case .scale:
                let scaleAnimation = CABasicAnimation(keyPath: "transform")
                scaleAnimation.fromValue = NSValue(caTransform3D: CATransform3DMakeScale(1, 1, 1))
                scaleAnimation.toValue = NSValue(caTransform3D: CATransform3DMakeScale(0, 0, 1))
                scaleAnimation.isCumulative = false
                scaleAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)

                let opacityAnimation = CABasicAnimation(keyPath: "opacity")
                opacityAnimation.fromValue = 1
                opacityAnimation.toValue = 0
                opacityAnimation.isCumulative = false
                opacityAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)

                let group = CAAnimationGroup()
                group.duration = 0.3
                group.isRemovedOnCompletion = false
                group.repeatCount = 1
                group.fillMode = CAMediaTimingFillMode.forwards
                group.animations = [scaleAnimation, opacityAnimation]

                self.layer.add(group, forKey: "scale")
                //回调
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    complete(self)
                }
            case .bottom:
                let transformAnimation = CABasicAnimation(keyPath: "transform.translation.y")
                transformAnimation.toValue = UIScreenHeight + self.frame.size.height
                transformAnimation.duration = 0.3
                transformAnimation.fillMode = CAMediaTimingFillMode.forwards
                transformAnimation.isCumulative = false
                transformAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                transformAnimation.isRemovedOnCompletion = false
                transformAnimation.repeatCount = 1
                self.layer.add(transformAnimation, forKey: "bottom")

                //回调
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    complete(self)
                }
            case .bottomToCenter:
                let transformAnimation = CABasicAnimation(keyPath: "transform.translation.y")
                transformAnimation.toValue = UIScreenHeight + self.frame.size.height
                transformAnimation.duration = 0.3
                transformAnimation.fillMode = CAMediaTimingFillMode.forwards
                transformAnimation.isCumulative = false
                transformAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                transformAnimation.isRemovedOnCompletion = false
                transformAnimation.repeatCount = 1
                self.layer.add(transformAnimation, forKey: "bottomToCenter")

                //回调
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    complete(self)
                }
            case .right:
                let transformAnimation = CABasicAnimation(keyPath: "transform.translation.x")
                transformAnimation.toValue = UIScreenWidth + self.frame.size.width
                transformAnimation.duration = 0.3
                transformAnimation.fillMode = CAMediaTimingFillMode.forwards
                transformAnimation.isCumulative = false
                transformAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                transformAnimation.isRemovedOnCompletion = false
                transformAnimation.repeatCount = 1
                self.layer.add(transformAnimation, forKey: "right")

                //回调
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    complete(self)
                }
        }
    }
}
