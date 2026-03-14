//
//  BaseVC.swift
//  Menses
//
//  Created by Damon on 2020/9/18.
//  Copyright © 2020 Damon. All rights reserved.
//

import UIKit

import RxSwift
import DDLoggerSwift

class BaseVC: HDBaseVC {
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBarTransparentType = .none
        self.setNavShadowHidden(hidden: true)
//        self.loadBarTitle(title: "easyart".localString, textColor: UIColor.dd.color(hexValue: 0x000000))
        let titleView = UIView()
        let imageView = UIImageView(image: UIImage(named: "easy-title"))
        imageView.contentMode = .scaleAspectFit // 设置图片内容模式
        titleView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        self.navigationItem.titleView = titleView

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        printWarn("\(Self.self) == viewWillAppear")
    }
    
    deinit {
        printWarn("\(Self.self) == 销毁")
    }
    
    override func createUI() {
        super.createUI()
        self.view.backgroundColor = UIColor.dd.color(hexValue: 0xffffff)
    }
}

extension UIViewController {
    func loadBarItem(image : UIImage? = nil, title: String? = nil, titleColor: UIColor = UIColor.dd.color(hexValue: 0x000000), font: UIFont = UIFont.systemFont(ofSize: 14, weight: .medium), itemPosition : HDBarItemPostion, selector : @escaping ((UIBarButtonItem) -> Void)) -> Void {
        var barItem: UIBarButtonItem?
        if let image = image {
            barItem = UIBarButtonItem(image: image.withRenderingMode(.alwaysOriginal), style: .plain, target: nil, action: nil)
            _ = barItem!.rx.tap.asDriver().drive(onNext: { (_) in
                selector(barItem!)
            })
        } else if let title = title, !title.isEmpty {
            let button = UIButton(type: .custom)
            button.setAttributedTitle(NSAttributedString(string: title, attributes: [NSAttributedString.Key.font:font, NSAttributedString.Key.foregroundColor:titleColor]), for: .normal)
            barItem = UIBarButtonItem(customView: button)
            _ = button.rx.tap.asDriver().drive(onNext: { (_) in
                selector(barItem!)
            })
        }

        guard let tBarItem = barItem else { return }
        if itemPosition == HDBarItemPostion.left {
            self.navigationItem.leftBarButtonItem = tBarItem
        } else {
            self.navigationItem.rightBarButtonItems?.removeAll()
            self.navigationItem.rightBarButtonItem = tBarItem
        }
    }
    
    //右侧添加两个按钮
    func loadBarItems(image : UIImage?, title: String = "", image2 : UIImage?, title2: String = "", itemPosition : HDBarItemPostion, selector:@escaping ((UIBarButtonItem, Int))->Void) -> Void {
        var barItems:[UIBarButtonItem] = []
        if (title == "") {
            let barItem = UIBarButtonItem(image: image?.withRenderingMode(.alwaysOriginal), style: .plain, target: nil, action: nil)
            _ = barItem.rx.tap.asDriver().drive(onNext: { (_) in
                selector((barItem, 0))
            })
            barItems.append(barItem)
        }else {
            let barItem = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
            _ = barItem.rx.tap.asDriver().drive(onNext: { (_) in
                selector((barItem, 0))
            })
            barItems.append(barItem)
        }
        
        if (title2 == "") {
            let barItem2 = UIBarButtonItem(image: image2?.withRenderingMode(.alwaysOriginal), style: .plain, target: nil, action: nil)
            _ = barItem2.rx.tap.asDriver().drive(onNext: { (_) in
                selector((barItem2, 1))
            })
            barItems.append(barItem2)
        }else {
            let barItem2 = UIBarButtonItem(title: title2, style: .plain, target: nil, action: nil)
            _ = barItem2.rx.tap.asDriver().drive(onNext: { (_) in
                selector((barItem2, 1))
            })
            barItems.append(barItem2)
        }
        
        if itemPosition == .left {
            self.navigationItem.leftBarButtonItems = barItems
        } else {
            self.navigationItem.rightBarButtonItems = barItems
        }
    }
}

