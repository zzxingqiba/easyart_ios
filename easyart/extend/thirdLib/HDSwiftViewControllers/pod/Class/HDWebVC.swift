//
//  HDWebVC.swift
//  HDSwiftViewControllers
//
//  Created by Damon on 2021/2/28.
//  Copyright © 2021 Damon. All rights reserved.
//

import UIKit
import DDUtils
import WebKit
import RxSwift
import HDHUD
import CoreImage
import SafariServices

open class HDWebVC: HDBaseVC {
    public private(set) var mWebView: HDWebView
    private var isDark = false
    public let mFAQSubject = PublishSubject<Void>() //点击投诉的回调
    public let mCleanSubject = PublishSubject<Void>() //点击清理的回调
    
    public convenience init(url: URL?, isDark: Bool = false) {
        let config = HDWebViewConfig(url: url)
        self.init(webViewConfig: config, isDark: isDark)
    }
    
    public init(webViewConfig:HDWebViewConfig, isDark: Bool = false) {
        mWebView = HDWebView(webViewConfig: webViewConfig, isDark: isDark)
        self.isDark = isDark
        super.init()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.mNavBackImage =  self.isDark ? UIImageHDVCBoundle(named: "nav_white_left") : UIImageHDVCBoundle(named: "nav_black_back")
        self.mNavBackgroundColor = self.isDark ? UIColor.dd.color(hexValue: 0x000000) : UIColor.dd.color(hexValue: 0xffffff)
        self.loadBarItem(image: self.isDark ? UIImageHDVCBoundle(named: "nav_white_more") : UIImageHDVCBoundle(named: "nav_black_more"), itemPosition: .right) { [weak self] (_) in
            self?.p_showMore()
        }
        self.p_bindView()
    }
    
    open override func createUI() {
        super.createUI()
        self.view.backgroundColor = UIColor.dd.color(hexValue: 0xffffff)

        self.mSafeView.addSubview(mSearchBar)
        mSearchBar.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(-40)
        }

        self.mSafeView.addSubview(mWebView)
        mWebView.snp.makeConstraints { (make) in
            make.top.equalTo(mSearchBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    //MARK: UI
    lazy var mBGView: UIView = {
        let tView = UIView()
        tView.backgroundColor = UIColor.dd.color(hexValue: 0x000000, alpha: 0.2)
        return tView
    }()
    
    lazy var mMorePopView: HDWebMorePopView = {
        let tMorePopView = HDWebMorePopView(isDark: self.isDark)
        return tMorePopView
    }()

    lazy var mSearchBar: HDWebSearchBar = {
        let tSearchBar = HDWebSearchBar()
        tSearchBar.isHidden = true
        return tSearchBar
    }()
}

private extension HDWebVC {
    func p_showMore() {
        self.view.addSubview(mBGView)
        mBGView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        if let url = self.mWebView.mWebView.url?.host {
            mMorePopView.mTitleLabel.text = "网址信息".ZXLocaleString + ": \(url)"
        }
        mBGView.addSubview(mMorePopView)
        mMorePopView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.bottom.equalTo(view)
        }
        mMorePopView.mCollectionView.reloadData()
        let transformAnimation = CABasicAnimation(keyPath: "transform.translation.y")
        transformAnimation.fromValue = UIScreenHeight + mMorePopView.frame.size.height
        transformAnimation.duration = 0.3
        transformAnimation.fillMode = CAMediaTimingFillMode.forwards
        transformAnimation.isCumulative = false
        transformAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transformAnimation.isRemovedOnCompletion = false
        transformAnimation.repeatCount = 1
        mMorePopView.layer.add(transformAnimation, forKey: "bottom")
    }
    
    func p_hideMore() {
        mMorePopView.removeFromSuperview()
        mBGView.removeFromSuperview()
    }
    
    func p_bindView() {
        _ = self.mWebView.mTitleChangeSubject.subscribe(onNext: { [weak self] (title) in
            guard let self = self else { return }
            self.loadBarTitle(title: title, textColor: self.isDark ? UIColor.dd.color(hexValue: 0xffffff) : UIColor.dd.color(hexValue: 0x333333), font: .systemFont(ofSize: 16, weight: .medium))
        })

        _ = self.mMorePopView.mCancelSubject.subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.p_hideMore()
        })
        
        _ = self.mMorePopView.mItemClickSubject.subscribe(onNext: { [weak self] (index) in
            guard let self = self else { return }
            switch index {
            case 0:
                self.mFAQSubject.onNext(())
            case 1:
                UIPasteboard.general.string = self.mWebView.mWebView.url?.absoluteString
                HDHUD.show("链接复制成功".ZXLocaleString, icon: .success)
            case 2:
                self.mWebView.mWebView.reload()
            case 3:
                self.mSearchBar.isHidden = false
                self.mSearchBar.snp.updateConstraints { (make) in
                    make.top.equalToSuperview()
                }
                
            case 4:
                if let url = self.mWebView.mWebView.url {
                    let safariVC = SFSafariViewController(url: url)
                    safariVC.delegate = self
                    self.present(safariVC, animated: true, completion: nil)
                } else {
                    HDHUD.show("链接打开失败".ZXLocaleString, icon: .error)
                }
            case 5:
                var logo: UIImage? = nil
                if let faviconURL = self.mWebView.mWebView.url?.host, let url = URL(string: "https://\(faviconURL)/favicon.ico"), let data = try? Data(contentsOf: url) {
                    logo = UIImage(data: data)
                }
                let image = self.generateQR(content: self.mWebView.mWebView.url?.absoluteString ?? "", logo: logo)
                self.save(image: image)
            case 6:
                guard let url = self.mWebView.mWebView.url else { return }
                DispatchQueue.main.async {
                    let shareActivityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                    shareActivityVC.completionWithItemsHandler = {(activityType, dissmiss, data, error) -> Void in

                    }
                    shareActivityVC.modalPresentationStyle = .fullScreen
                    shareActivityVC.popoverPresentationController?.sourceView = DDUtils.shared.getCurrentVC()?.view
                    self.present(shareActivityVC, animated: true, completion: {

                    })
                }
            case 7:
                self.mWebView.cleanWebDataSource { [weak self] in
                    self?.mCleanSubject.onNext(())
                }
            case 8:
                if UIPrintInteractionController.isPrintingAvailable {
                    let print = UIPrintInfo.printInfo()
                    print.outputType = .general
                    print.jobName = "print"
                    print.orientation = .portrait
                    print.duplex = .longEdge
                    
                    let printController = UIPrintInteractionController.shared
                    printController.printInfo = print
                    printController.printFormatter = self.mWebView.viewPrintFormatter()
                    printController.present(animated: true)
                } else {
                    HDHUD.show("当前页面不支持打印".ZXLocaleString, icon: .error)
                }
            default:
                break
            }
            self.p_hideMore()
        })

        //搜索
        _ = self.mSearchBar.mCloseSubject.subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.mSearchBar.isHidden = true
            self.mSearchBar.snp.updateConstraints { (make) in
                make.top.equalToSuperview().offset(-40)
            }
            self.resetHighlight()
        })

        _ = self.mSearchBar.mConfirmSubject.subscribe(onNext: { [weak self] (text) in
            guard let self = self else { return }
            self.highlightAllOccurences(string: text, complete: nil)
        })

        _ = self.mSearchBar.mJumpSubject.subscribe(onNext: { [weak self] (isNext) in
            guard let self = self else { return }
            if isNext {
                self.scrollDown()
            } else {
                self.scrollToTop()
            }
        })
    }


}

//生成二维码
private extension HDWebVC {
    func generateQR(content: String, logo: UIImage?, size: CGSize = CGSize(width: 600, height: 600), logoSize: CGSize = CGSize(width: 100, height: 100)) -> UIImage? {
        //生成二维码
        let filter = CIFilter(name: "CIQRCodeGenerator", parameters: ["inputMessage" : content.data(using: .utf8) ?? Data(), "inputCorrectionLevel" : "H"])
        guard let QRImage = filter?.outputImage else {
            return nil
        }
        //重新生成以便高清处理
        guard let cgImage = CIContext().createCGImage(QRImage, from: QRImage.extent) else {return UIImage(ciImage: QRImage)}
        UIGraphicsBeginImageContext(size)
        guard let context = UIGraphicsGetCurrentContext() else {return UIImage(ciImage: QRImage)}
        context.interpolationQuality = .none
        context.scaleBy(x: 1.0, y: -1.0)
        context.draw(cgImage, in: context.boundingBoxOfClipPath)
        //生成二维码
        let QRCodeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //画上icon
        guard let logo = logo, let sourceImage = QRCodeImage  else { return QRCodeImage }
        UIGraphicsBeginImageContext(size)
        //画图片
        sourceImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        //画上边框
        let borderContext = UIGraphicsGetCurrentContext()
        let addWidth: CGFloat = 10.0
        borderContext?.saveGState()
        borderContext?.setFillColor(UIColor.white.cgColor)
        borderContext?.fill(CGRect(x: (size.width - logoSize.width) * 0.5 - addWidth, y: (size.height - logoSize.height) * 0.5 - addWidth, width: logoSize.width + addWidth * 2, height: logoSize.height + addWidth * 2))
        borderContext?.restoreGState()
        //画上logo
        let logoImageRect = CGRect(x: (size.width - logoSize.width) * 0.5, y: (size.height - logoSize.height) * 0.5, width: logoSize.width, height: logoSize.height)
        logo.draw(in: logoImageRect)

        //生成最终图
        let resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        return resultImage
    }

    func save(image: UIImage?) {
        if let image = image {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
        } else {
            HDHUD.show("无图片数据，保存失败".ZXLocaleString, icon: .error)
        }
    }


    @objc private func image(image : UIImage, didFinishSavingWithError error : NSError?, contextInfo : AnyObject) {
        if error != nil {
            HDHUD.show("保存图片出错".ZXLocaleString, icon: .error)
        } else {
            HDHUD.show("已将图片保存到您手机相册".ZXLocaleString, icon: .success)
        }
    }
}

//查找
private extension HDWebVC {
    //加载js
    func evaluateJavaScript() {
        
    }
    
    // 搜索关键字 以及搜索完成之后的回调 查找的总数
    func highlightAllOccurences(string: String, complete: ((Int) -> Void)?) {
        //加载js
        self.evaluateJavaScript()
        let searchString = "WKWebView_HighlightAllOccurencesOfString('\(string)')"
        self.mWebView.mWebView.evaluateJavaScript(searchString) { [weak self] (result, error) in
            guard let self = self else { return }
            //字数显示
            self.mWebView.mWebView.evaluateJavaScript("WKWebView_SearchResultCount") { (result, error) in
                if let count = result as? Int {
                    self.mSearchBar.mCurrent = 0
                    self.mSearchBar.mTotal = count
                }
                if let complete = complete, let count = result as? Int {
                    complete(count)
                }
            }
        }
    }
    
    //上移
    func scrollToTop() {
        self.mWebView.mWebView.evaluateJavaScript("WKWebView_SearchPrev()") { [weak self] (result, error) in
            guard let self = self else { return }
            //字数显示
            self.mWebView.mWebView.evaluateJavaScript("currSelected") { (result, error) in
                if let count = result as? Int {
                    self.mSearchBar.mCurrent = count + 1
                }
            }
        }
    }
    
    //下移
    func scrollDown() {
        self.mWebView.mWebView.evaluateJavaScript("WKWebView_SearchNext()") { [weak self] (result, error) in
            guard let self = self else { return }
            //字数显示
            self.mWebView.mWebView.evaluateJavaScript("currSelected") { (result, error) in
                if let count = result as? Int {
                    self.mSearchBar.mCurrent = count + 1
                }
            }
        }
    }
    
    //移除高亮
    func resetHighlight() {
        self.mWebView.mWebView.evaluateJavaScript("WKWebView_RemoveAllHighlights()", completionHandler: nil)
    }
}

extension HDWebVC: SFSafariViewControllerDelegate {
    open func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
