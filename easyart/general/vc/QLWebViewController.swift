//
//  QLWebViewController.swift
//  shuijiaobao
//
//  Created by Damon on 2020/11/4.
//  Copyright © 2020 Damon. All rights reserved.
//

import UIKit
import WebKit

class QLWebViewController: BaseVC {
    private var url: URL

    init(url: URL) {
        self.url = url
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self._bindView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationBarTransparentType = .none
        if self.isBeingPresented {
            self.mCloseButton.isHidden = false
        } else {
            self.mCloseButton.isHidden = true
//            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        if !self.isBeingPresented {
//            self.navigationController?.setNavigationBarHidden(true, animated: true)
//        }
    }

    override func createUI() {
        super.createUI()
        self.mSafeView.addSubview(mWebView)
        mWebView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            if (self.isBeingPresented) {
                make.top.equalToSuperview().offset(30)
            } else {
                make.top.equalToSuperview()
            }
        }

        self.mSafeView.addSubview(mCloseButton)
        mCloseButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(3)
            make.right.equalToSuperview().offset(-16)
            make.width.height.equalTo(26)
        }
        
        self.mWebView.load(URLRequest(url: self.url))
    }
    
    //MARK: UI
    lazy var mWebView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()
    
    lazy var mCloseButton: UIButton = {
        let button = UIButton(type: .custom)
        button.isHidden = true
        button.setImage(UIImage(named: "cc-close-crude"), for: .normal)
        return button
    }()
}

extension QLWebViewController {
    func _bindView() {
        _ = self.mCloseButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: true)
        })
    }
}
