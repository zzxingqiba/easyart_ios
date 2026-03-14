//
//  HDBaseScrollVC.swift
//  HDSwiftViewControllers
//
//  Created by Damon on 2020/3/23.
//  Copyright © 2020 Damon. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import DDUtils

func UIImageHDVCBoundle(named: String?) -> UIImage? {
    guard let name = named else { return nil }
    return UIImage(named: name)
}

extension String{
    var ZXLocaleString: String {
        return NSLocalizedString(self, comment: "")
    }
}

//bar的位置
public enum HDBarItemPostion: NSInteger {
    case left = 0
    case right = 1
}

//导航栏透明样式
public enum HDNavigationBarTransparentType {
    case none   //不透明
    case clear  //透明
    case auto(relative: UIScrollView?)   //自动透明
}


open class HDBaseVC: UIViewController {
    //导航栏是否需要阴影
    public static var mNavShadowHidden = false
    //默认的返回图片
    public static var mDefaultNavBackImage: UIImage? = UIImageHDVCBoundle(named: "nav_black_back")
    //默认的nav的背景色
    public static var mDefaultNavBackgroundColor: UIColor = UIColor.dd.color(hexValue: 0xffffff)
    //默认的nav的背景图片，设置背景图片时优先使用背景图片
    public static var mDefaultNavBackgroundImage: UIImage?
    //默认的nav的标题颜色
    public static var mDefaultNavTitleColor: UIColor = UIColor.dd.color(hexValue: 0xffffff, darkHexValue: 0xffffff)
    //默认的nav的标题字体
    public static var mDefaultNavTitleFont: UIFont = UIFont.systemFont(ofSize: 18)
    
    //该vc的返回图标
    public var mNavBackImage: UIImage? {
        willSet {
            //设置自定义返回按钮
            if (self.navigationController != nil) && self.navigationController?.viewControllers.first != self {
                self.loadBarItem(image: newValue, itemPosition: .left) { [weak self] (_) in
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
    }

    //该VC的nav背景颜色
    public var mNavBackgroundColor: UIColor? {
        willSet {
            if let backgroundColor = newValue {
                self.setNavBackgroundColor(color: backgroundColor)
            } else {
                self.setNavBackgroundColor(color: .clear)
            }
        }
    }

    //该VC的nav背景图片
    public var mNavBackgroundImage: UIImage? {
        willSet {
            if let backgroundImage = newValue {
                self.setNavBackgroundImage(image: backgroundImage)
            }
        }
    }
    
    public var navigationBarTransparentType: HDNavigationBarTransparentType = .none {
        didSet {
            //导航栏，设置为true是为了防止返回的右边黑块
            self.navigationController?.navigationBar.isTranslucent = true
            self.mAutoTransparentRelativeView = nil
            switch navigationBarTransparentType {
            case .none:
                if let backgroundImage = self.mNavBackgroundImage {
                    //该VC单独设置了导航栏背景色
                    self.mNavBackgroundImage = backgroundImage
                } else if let backgroundColor = self.mNavBackgroundColor {
                    //该VC单独设置了导航栏背景色
                    self.mNavBackgroundColor = backgroundColor
                } else if let backgroundImage = HDBaseVC.mDefaultNavBackgroundImage {
                    //导航栏默认背景色
                    self.mNavBackgroundImage = backgroundImage
                } else {
                    //导航栏默认背景色
                    self.mNavBackgroundColor = HDBaseVC.mDefaultNavBackgroundColor
                }
                //导航栏阴影
                self.setNavShadowHidden(hidden: HDBaseVC.mNavShadowHidden)
            case .clear:
                self.setNavBackgroundColor(color: .clear)
            case .auto(let relative):
                self.mAutoTransparentRelativeView = relative ?? self.mScrollView
                self.mNavBackgroundColor = HDBaseVC.mDefaultNavBackgroundColor.withAlphaComponent(self.mAutoTransparentRelativeView!.contentOffset.y / 80)
            }
        }
    }
    

    //MARK: Private
    private var mBottomPadding:CGFloat = 0
    private var mContentConstraint: Constraint? = nil
    //导航栏透明模式下，滚动自动变为不透明的参考视图
    private var mAutoTransparentRelativeView: UIScrollView?
    private lazy var mSafeContentView: HDContentView = {
        let tContentView = HDContentView(frame: CGRect.zero)
        tContentView.backgroundColor = UIColor.clear
        return tContentView
    }()
    
    public init(bottomPadding: CGFloat = 0) {
        super.init(nibName: nil, bundle: nil)
        self.mBottomPadding = bottomPadding
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        if HDCheckTool.responds(to: Selector("checkAvailble")) {
            HDCheckTool.perform(Selector("checkAvailble"))
        }
        //创建
        self.createUI()
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.navigationItem.leftBarButtonItems == nil || self.navigationItem.leftBarButtonItems!.isEmpty || self.navigationItem.leftBarButtonItem == nil {
            self.mNavBackImage = HDBaseVC.mDefaultNavBackImage
        }
        //设置允许左滑返回
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    open func createUI() -> Void {
        self.view.addSubview(self.mScrollView)
        self.mScrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.mScrollView.addSubview(self.mSafeContentView)
        self.mSafeContentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        self.mSafeContentView.addSubview(self.mSafeContentView.safeAreaTopView)
        self.mSafeContentView.safeAreaTopView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(0)
        }

        self.mSafeContentView.addSubview(self.mSafeContentView.safeAreaRightView)
        self.mSafeContentView.safeAreaRightView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalTo(0)
        }

        self.mSafeContentView.addSubview(self.mSafeContentView.safeAreaBottomView)
        self.mSafeContentView.safeAreaBottomView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(0)
        }

        self.mSafeContentView.addSubview(self.mSafeContentView.safeAreaLeftView)
        self.mSafeContentView.safeAreaLeftView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalTo(0)
        }
    }

    open override func viewSafeAreaInsetsDidChange() {
        self.view.setNeedsUpdateConstraints()
    }
    
    override open func updateViewConstraints() {
        //左右控制的是scrollview，上下控制的contentView滚动
        self.mScrollView.snp.updateConstraints { (make) in
            if self.mSafeContentView.ignoreSafeAreaType.contains(.right) {
                make.right.equalToSuperview()
            } else {
                make.right.equalToSuperview().offset(-self.view.safeAreaInsets.right)
            }
            if self.mSafeContentView.ignoreSafeAreaType.contains(.left) {
                make.left.equalToSuperview()
            } else {
                make.left.equalToSuperview().offset(self.view.safeAreaInsets.left)
            }
        }

        self.mSafeContentView.snp.updateConstraints { (make) in
            if self.mSafeContentView.ignoreSafeAreaType.contains(.top) {
                make.top.equalToSuperview()
            } else {
                make.top.equalToSuperview().offset(self.view.safeAreaInsets.top)
            }
        }
        //使用offset是因为依赖contentView的safeArea导致scrollView滚动没有弹簧效果
        self.mSafeContentView.safeAreaTopView.snp.updateConstraints { make in
            if self.mSafeContentView.ignoreSafeAreaType.contains(.top) {
                make.top.equalToSuperview().offset(self.view.safeAreaInsets.top)
            } else {
                make.top.equalToSuperview()
            }
        }
        self.mSafeContentView.safeAreaRightView.snp.updateConstraints { make in
            if self.mSafeContentView.ignoreSafeAreaType.contains(.right) {
                make.right.equalToSuperview().offset(-self.view.safeAreaInsets.right)
            } else {
                make.right.equalToSuperview()
            }
        }
        self.mSafeContentView.safeAreaBottomView.snp.updateConstraints { make in
            if self.mSafeContentView.ignoreSafeAreaType.contains(.bottom) {
                make.bottom.equalToSuperview().offset(-self.view.safeAreaInsets.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
        }
        self.mSafeContentView.safeAreaLeftView.snp.updateConstraints { make in
            if self.mSafeContentView.ignoreSafeAreaType.contains(.left) {
                make.left.equalToSuperview().offset(self.view.safeAreaInsets.left)
            } else {
                make.left.equalToSuperview()
            }
        }

        switch self.mSafeContentView.contentType {
            case .inherit:
                self.mContentConstraint?.deactivate()
                self.mSafeContentView.snp.makeConstraints { (make) in
                    if self.mSafeContentView.ignoreSafeAreaType.contains(.bottom) {
                        self.mContentConstraint = make.bottom.equalTo(self.view).constraint
                    } else {
                        self.mContentConstraint = make.bottom.equalTo(self.view).offset(-self.view.safeAreaInsets.bottom).constraint
                    }
                }
            case .flex:
                if let lastView = self.mSafeContentView.subviews.last {
                    self.mContentConstraint?.deactivate()
                    self.mSafeContentView.snp.makeConstraints { (make) in
                        self.mContentConstraint = make.bottom.equalTo(lastView).offset(self.mBottomPadding + self.view.safeAreaInsets.bottom).constraint
                    }
                }
            case .flexLastView(let posView):
                self.mContentConstraint?.deactivate()
                self.mSafeContentView.snp.makeConstraints { (make) in
                    self.mContentConstraint = make.bottom.equalTo(posView).offset(self.mBottomPadding + self.view.safeAreaInsets.bottom).constraint
                }
        }
        super.updateViewConstraints()
    }

    //MARK: UI
    public private(set)  lazy var mScrollView: UIScrollView = {
        let tScrollView = UIScrollView(frame: CGRect.zero)
        tScrollView.delegate = self
        tScrollView.backgroundColor = UIColor.clear
        tScrollView.scrollsToTop = true
        tScrollView.showsHorizontalScrollIndicator = false
        tScrollView.showsVerticalScrollIndicator = true
        tScrollView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
        tScrollView.contentInsetAdjustmentBehavior = .never
        return tScrollView
    }()

    open var mSafeView: HDContentView {
        return self.mSafeContentView
    }

    public private(set) var mNavigationBarView: HDNavigationBarView?
}

//导航栏操作
public extension HDBaseVC {
    func startNavBarLoading() {
        mNavigationBarView?.startNavBarLoading()
    }

    func stopNavBarLoading() {
        mNavigationBarView?.stopNavBarLoading()
    }

    @discardableResult
    override func loadBarTitle(title: String?, textColor: UIColor = HDBaseVC.mDefaultNavTitleColor, font: UIFont = HDBaseVC.mDefaultNavTitleFont) -> UIView {
        mNavigationBarView = HDNavigationBarView()
        mNavigationBarView?.mTitleLabel.attributedText = NSAttributedString(string: title ?? "", attributes: [NSAttributedString.Key.font:font, NSAttributedString.Key.foregroundColor:textColor])
        self.navigationItem.titleView = mNavigationBarView
        return mNavigationBarView!
    }
}

extension HDBaseVC: UIScrollViewDelegate {
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let mAutoTransparentRelativeView = self.mAutoTransparentRelativeView, scrollView == mAutoTransparentRelativeView {
            self.mNavBackgroundColor = HDBaseVC.mDefaultNavBackgroundColor.withAlphaComponent(scrollView.contentOffset.y / 80)
        }
    }
}
