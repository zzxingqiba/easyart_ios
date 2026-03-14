//
//  HDPopView.swift
//  SleepClient
//
//  Created by Damon on 2020/7/12.
//  Copyright © 2020 Damon. All rights reserved.
//

import UIKit
import DDUtils
import RxSwift
import RxCocoa
import SnapKit

//图片
func UIImageHDPopBoundle(named: String?) -> UIImage? {
    guard let name = named else { return nil }
    guard let bundlePath = Bundle(for: HDPopView.self).path(forResource: "HDPopView", ofType: "bundle") else { return UIImage(named: name) }
    let bundle = Bundle(path: bundlePath)
    return UIImage(named: name, in: bundle, compatibleWith: nil)
}

//弹窗动效
public enum HDPopAnimation {
    case none
    case scale
    case bottom
    case bottomToCenter
    case right
}

//弹窗的点击事件类型
public enum HDPopButtonType {
    case confirm
    case cancel
    case custom
}

//弹窗上按钮点击的内容
public struct HDPopButtonClickInfo {
    public var clickType: HDPopButtonType = .custom
    public var info: Any?

    public init(clickType: HDPopButtonType, info: Any? = nil) {
        self.clickType = clickType
        self.info = info
    }
}

open class HDPopView: UIView {
    /// 显示指定的view
    /// - Parameters:
    ///   - view: 要显示的view
    ///   - animationType: 动画类型
    ///   - posView: 内容的参考view，如果为nil就是当前的superView
    ///   - anchorPoint 和posView对齐的锚点 左上角(0,0) (0,1) (0.5, 0.5) (1, 0) (1,1)
    ///   - superView: 弹窗添加的view，如果为nil就添加到当前window
    public static func show(view: HDPopContentView, animationType: HDPopAnimation = .scale, posView: UIView? = nil, anchorPoint: CGPoint? = nil, superView: UIView? = nil) {
        self.hide()
        self.shared.currentContentView = view
        //
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
        let popPosView: UIView = posView ?? self.shared
        //动效
        view.animation(animationType: animationType, posView: popPosView, anchorPoint: anchorPoint)
        //添加手势
        self.shared.mBGView.removeGestureRecognizer(self.shared.backgroundTap)
        self.shared.backgroundTap = UITapGestureRecognizer()
        _ = self.shared.backgroundTap.rx.event.map({ _ in
            return
        }).bind(to: view.backgroundClickBinder)
        self.shared.mBGView.addGestureRecognizer(self.shared.backgroundTap)
        //显示回调
        view.visibleChangePublish.onNext(true)
    }

    //隐藏
    public static func hide() {
        self.shared.currentContentView?.closeAnimation(complete: { contentView in
            if contentView != self.shared.currentContentView {
                //已经有新contentView要显示
                contentView.removeFromSuperview()
                contentView.visibleChangePublish.onNext(false)
            } else {
                //还是老的contentView
                for view in self.shared.subviews {
                    if view is HDPopContentView {
                        let contentView = view as! HDPopContentView
                        contentView.visibleChangePublish.onNext(false)
                    }
                    view.removeFromSuperview()
                }
                self.shared.removeFromSuperview()
            }
        })
    }
    
    public static var bgView: UIView {
        return shared.mBGView
    }

    //MARK: Private
    //单例对象
    private static let shared = HDPopView()
    //背景的点击事件
    private var backgroundTap = UITapGestureRecognizer()
    //当前显示的contentView
    private var currentContentView: HDPopContentView?
    //MARK: UI
    private(set) lazy var mBGView: UIView = {
        let tView = UIView()
        tView.backgroundColor =  UIColor.dd.color(hexValue: 0x000000, alpha: 0.6)
        return tView
    }()
}
