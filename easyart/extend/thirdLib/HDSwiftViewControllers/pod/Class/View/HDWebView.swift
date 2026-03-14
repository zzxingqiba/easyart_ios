//
//  HDWebView.swift
//  HDSwiftViewControllers
//
//  Created by Damon on 2020/3/23.
//  Copyright © 2020 Damon. All rights reserved.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa
import DDUtils

open class HDWebViewConfig {
    //web配置
    open private(set) lazy var webConfig: WKWebViewConfiguration = {
        let tWebConfig = WKWebViewConfiguration()
        tWebConfig.allowsInlineMediaPlayback = true
        let preference = WKPreferences()
        preference.javaScriptEnabled = true
        tWebConfig.preferences = preference
        return tWebConfig
    }()
    //是否开启左滑网页返回，默认开启
    public var allowsBackForwardNavigationGestures = true
    //是否允许页面放大缩小， 默认允许
    public var mBouncesZoom = true
    //浏览器的进度条颜色，默认#FFE981
    public var webProgressColor =  UIColor.dd.color(hexValue:0xff7676)
    //网址的请求
    public var urlRequest:URLRequest?
    
    fileprivate var mAppSchemeArray = [String]()
    
    /// 增加需要用app打开的链接开头
    /// - Parameter appScheme: app的scheme
    open func addAppPolicySchemeUrl(_ appScheme:String) -> Void {
        self.mAppSchemeArray.append(appScheme)
    }
    
    convenience public init(url:URL?) {
        var request:URLRequest?
        if let tUrl = url {
            request = URLRequest(url: tUrl)
        }
        self.init(urlRequest:request)
    }
    
    convenience public init(urlRequest:URLRequest?) {
        self.init()
        self.urlRequest = urlRequest
    }
}

open class HDWebView: UIView {
    public var webViewConfig:HDWebViewConfig = HDWebViewConfig()
    public let mDidFinishSubject = PublishSubject<Void>()
    public let mTitleChangeSubject = BehaviorRelay<String>(value: "")
    private var disposeBag = DisposeBag()
    
    //MARK:UI控件
    public private(set) lazy var mWebView: WKWebView = {
        let tWebView = WKWebView(frame: CGRect.zero, configuration: self.webViewConfig.webConfig)
        tWebView.scrollView.delegate = self
        tWebView.navigationDelegate = self
        tWebView.uiDelegate = self
        tWebView.isOpaque = false
        tWebView.allowsBackForwardNavigationGestures = self.webViewConfig.allowsBackForwardNavigationGestures
        tWebView.scrollView.bouncesZoom = self.webViewConfig.mBouncesZoom
        return tWebView
    }()
    
    public private(set) lazy var mProgressView: UIProgressView = {
        let tProgressView = UIProgressView()
        tProgressView.alpha = 1.0;
        tProgressView.progressTintColor = self.webViewConfig.webProgressColor
        tProgressView.backgroundColor = UIColor.clear
        return tProgressView
    }()
    
    //MARK:初始化方式
    public init(webViewConfig:HDWebViewConfig, isDark: Bool = false) {
        super.init(frame: CGRect.zero)
        self.webViewConfig = webViewConfig
        self.mWebView.backgroundColor = isDark ? UIColor.dd.color(hexValue: 0x000000) : UIColor.dd.color(hexValue: 0xffffff)
        self.p_createUI()
        self.p_bindView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK:public method
    open func loadRequest(_ urlRequest:URLRequest) -> Void {
        self.mWebView.load(urlRequest)
    }
    
    ///  清理浏览器缓存
    open func cleanWebDataSource(complete: @escaping (()->Void)) {
        let websiteDataType = WKWebsiteDataStore.allWebsiteDataTypes()
        let dateFrom = Date(timeIntervalSince1970: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataType, modifiedSince: dateFrom) {
            complete()
        }
    }
}

extension HDWebView {
    //MARK:布局
    private func p_createUI() -> Void {
        //主页面和标题
        self.addSubview(self.mWebView)
        self.mWebView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        //MARK: 进度条进度显示
        self.addSubview(self.mProgressView)
        self.mProgressView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self)
            make.height.equalTo(3)
        }

        if let request = self.webViewConfig.urlRequest {
            self.mWebView.load(request)
        }
    }

    func p_bindView() {
        _ = self.mWebView.rx.observe(NSNumber.self, "estimatedProgress").subscribe(onNext: { [weak self] (newValue) in
            guard let self = self else { return }
            let progress = newValue?.floatValue ?? 0.0
            self.mProgressView.alpha = 1.0
            self.mProgressView.setProgress(progress, animated: true)
            if progress >= 1.0 {
                UIView.animate(withDuration: 0.3, delay: 0.3, options: UIView.AnimationOptions.curveEaseOut, animations: {
                    self.mProgressView.alpha = 0.0
                }) { (finished) in
                    self.mProgressView.setProgress(0.0, animated: false)
                }
            }
        }).disposed(by: disposeBag)

        _ = self.mWebView.rx.observe(String.self, "title").subscribe(onNext: { [weak self] (title) in
            guard let self = self else { return }
            self.mTitleChangeSubject.accept(title ?? "")
        }).disposed(by: disposeBag)
    }
}

extension HDWebView: WKNavigationDelegate, UIScrollViewDelegate, WKUIDelegate {
    //MARK:WKNavigationDelegate
    open func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.mDidFinishSubject.onNext(())
    }

    open func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            var shouldAppOpen = false
            if !self.webViewConfig.mAppSchemeArray.isEmpty {
                for appscheme in self.webViewConfig.mAppSchemeArray {
                    if url.absoluteString.hasPrefix(appscheme) {
                        shouldAppOpen = true
                        break
                    }
                }
            }
            if shouldAppOpen {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    decisionHandler(WKNavigationActionPolicy.cancel)
                } else {
                    decisionHandler(WKNavigationActionPolicy.allow)
                }
            } else {
                decisionHandler(WKNavigationActionPolicy.allow)
            }
        } else {
            decisionHandler(WKNavigationActionPolicy.allow)
        }
    }
    
    
    open func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
}
