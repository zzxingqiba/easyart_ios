//
//  UIViewController+extension.swift
//  HDSwiftViewControllers
//
//  Created by Damon on 2021/7/7.
//  Copyright © 2021 Damon. All rights reserved.
//

import UIKit
import DDUtils

open class UIBarButtonQuickItem {
    public private(set) var image: UIImage?
    public private(set) var attributedString: NSAttributedString?
    public var badge: String?
    
    @available(*, deprecated, message: "use init(image: attributedString:) instand of it")
    public init() {
        
    }
    
    public init(image: UIImage?, attributedString: NSAttributedString?) {
        self.image = image
        self.attributedString = attributedString
    }
    
    public convenience init(image: UIImage?) {
        self.init(image: image, attributedString: nil)
    }
    
    public convenience init(text: String? = nil, font: UIFont = UIFont.systemFont(ofSize: 14, weight: .medium), textColor: UIColor = UIColor.dd.color(hexValue: 0x000000)) {
        self.init(image: nil, attributedString: NSAttributedString(string: text ?? "", attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: textColor]))
    }
}

public extension UIViewController {
    //导航栏是否需要阴影
    func setNavShadowHidden(hidden: Bool) {
        if hidden {
            self.navigationController?.navigationBar.layer.shadowColor = UIColor.clear.cgColor
            self.navigationController?.navigationBar.layer.shadowOffset = CGSize.zero
            self.navigationController?.navigationBar.layer.shadowRadius = 0
            self.navigationController?.navigationBar.layer.shadowOpacity = 0
        } else {
            self.navigationController?.navigationBar.layer.shadowColor =  UIColor.dd.color(hexValue:0x000000, alpha: 0.14).cgColor
            self.navigationController?.navigationBar.layer.shadowOffset = CGSize.init(width: 0, height: -3)
            self.navigationController?.navigationBar.layer.shadowRadius = 7
            self.navigationController?.navigationBar.layer.shadowOpacity = 1
        }
    }
    
    //导航栏背景颜色
    func setNavBackgroundColor(color: UIColor) {
        if #available(iOS 15, *) {
            let appearance = self.navigationController?.navigationBar.standardAppearance ?? UINavigationBarAppearance.init()
            appearance.configureWithTransparentBackground()  // 重置背景和阴影颜色
            appearance.backgroundColor = color  // 设置导航栏背景色
            appearance.backgroundImage = nil
            appearance.shadowImage = UIImage()  // 设置导航栏下边界分割线透明
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance  // 带scroll滑动的页面
            self.navigationController?.navigationBar.standardAppearance = appearance // 常规页面
        } else {
            //导航栏底部分割线去掉
            self.navigationController?.navigationBar.shadowImage = UIImage()
            //该VC单独设置了导航栏背景色
            self.navigationController?.navigationBar.barTintColor = color
            //获取透明度
            var white: CGFloat = 0
            var alpha: CGFloat = 0
            color.getWhite(&white, alpha: &alpha)
            if alpha == 0 {
                self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            } else {
                self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
            }
        }
        
    }
    
    //导航栏背景图片
    func setNavBackgroundImage(image: UIImage) {
        if #available(iOS 15, *) {
            let appearance = self.navigationController?.navigationBar.standardAppearance ?? UINavigationBarAppearance.init()
            appearance.configureWithTransparentBackground()  // 重置背景和阴影颜色
            appearance.backgroundImage = image  // 设置导航栏背景色
            appearance.backgroundColor = UIColor.clear
            appearance.shadowImage = UIImage()  // 设置导航栏下边界分割线透明
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance  // 带scroll滑动的页面
            self.navigationController?.navigationBar.standardAppearance = appearance // 常规页面
        } else {
            //导航栏底部分割线去掉
            self.navigationController?.navigationBar.shadowImage = UIImage()
            //该VC单独设置了导航栏背景色
            self.navigationController?.navigationBar.barTintColor = UIColor.clear
            self.navigationController?.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
        }
    }
    
    //设置按钮
    func loadBarItem(image: UIImage?, itemPosition: HDBarItemPostion, selector: @escaping (((HDNavBarButtonItem, Int)) -> Void)) -> Void {
        let barItems = [UIBarButtonQuickItem(image: image)]
        self.loadBarItems(items: barItems, itemPosition: itemPosition, selector: selector)
    }
    
    ///多张图片设置barItems
    func loadBarItems(images: [UIImage?], itemPosition: HDBarItemPostion, selector: @escaping (((HDNavBarButtonItem, Int)) -> Void)) -> Void {
        let barItems = images.compactMap { image in
            return UIBarButtonQuickItem(image: image)
        }
        self.loadBarItems(items: barItems, itemPosition: itemPosition, selector: selector)
    }
    
    //设置barItem
    func loadBarItems(items: [UIBarButtonQuickItem], itemPosition: HDBarItemPostion, selector: @escaping (((HDNavBarButtonItem, Int)) -> Void)) -> Void {
        var barItems = [HDNavBarButtonItem]()
        
        for index in 0..<items.count {
            let item = items[index]
            let barItem = HDNavBarButtonItem(item: item)
            barItem.setBadge(text: item.badge)
            _ = barItem.customButton?.rx.tap.asDriver().drive(onNext: { (_) in
                selector((barItem, index))
            })
            barItems.append(barItem)
        }
        if itemPosition == .left {
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.leftBarButtonItems = barItems
        } else {
            self.navigationItem.rightBarButtonItem = nil
            self.navigationItem.rightBarButtonItems = barItems
        }
    }
    
    ///设置标题
    @objc func loadBarTitle(title: String?, textColor: UIColor = HDBaseVC.mDefaultNavTitleColor, font: UIFont = HDBaseVC.mDefaultNavTitleFont) -> UIView {
        let view = UIView()
        let label = UILabel()
        label.attributedText = NSAttributedString(string: title ?? "", attributes: [NSAttributedString.Key.font:font, NSAttributedString.Key.foregroundColor:textColor])
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        self.navigationItem.titleView = view
        return view
    }
}

extension UIViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.navigationController?.viewControllers.first == self && gestureRecognizer == self.navigationController?.interactivePopGestureRecognizer {
            return false
        } else {
            return true
        }
    }
}
