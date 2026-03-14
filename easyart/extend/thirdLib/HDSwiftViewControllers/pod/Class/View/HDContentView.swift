//
//  HDContentView.swift
//  HDSwiftViewControllers
//
//  Created by Damon on 2021/8/25.
//  Copyright © 2021 Damon. All rights reserved.
//

import UIKit

///内容模式，决定是自适应高度还是固定高度
public enum HDContentType {
    case inherit    //使用父view的固定高度
    case flex       //内容填充，自适应高度，根据contentView中最后一个view拉伸
    case flexLastView(UIView)  //自适应高度，指定最后一个view
}

///忽略安全距离的方向
public struct HDIgnoreSafeAreaType: OptionSet {
    public static let top = HDIgnoreSafeAreaType(rawValue: 1)
    public static let right = HDIgnoreSafeAreaType(rawValue: 2)
    public static let bottom = HDIgnoreSafeAreaType(rawValue: 4)
    public static let left = HDIgnoreSafeAreaType(rawValue: 8)

    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

open class HDContentView: UIView {

    /**忽略安全距离
     如果忽略安全距离，是从顶部开始，从安全距离开始，默认左右忽略安全距离，铺满屏幕
     */
    public var ignoreSafeAreaType: HDIgnoreSafeAreaType = [.left, .right] {
        willSet {
            self.superview?.setNeedsUpdateConstraints()
        }
    }

    //内容模式
    public var contentType = HDContentType.inherit {
        willSet {
            self.superview?.setNeedsUpdateConstraints()
        }
    }
    //是否点击收回键盘
    public var endEditWhenTouch: Bool = true
    //safeArea的顶部参照view，可用于ignoreSafeAreaType为true时的参照
    public let safeAreaTopView = UIView()
    public let safeAreaRightView = UIView()
    public let safeAreaBottomView = UIView()
    public let safeAreaLeftView = UIView()
}

public extension HDContentView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if endEditWhenTouch {
            self.endEditing(true)
        }
    }
}
