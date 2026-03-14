//
//  LoginVC.swift
//  HiTalk
//
//  Created by Damon on 2024/6/3.
//

import UIKit
import RxRelay
import HDHUD
import SwiftyJSON
import DDUtils


class LoginVC: BaseVC {
    var loginResult: PublishRelay<Bool> = PublishRelay<Bool>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.dd.color(hexValue: 0xffffff)
        self._bindView()
        self._loadData()
    }
    

    override func createUI() {
        super.createUI()
        self.mSafeView.contentType = .flex
        
        self.mSafeView.addSubview(mEmailLoginView)
        mEmailLoginView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
        }
        
        self.mSafeView.addSubview(mLoginView)
        mLoginView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
        }
        
    }
    
    //MARK: UI
    lazy var mLoginView: DDLoginView = {
        let view = DDLoginView()
        return view
    }()
    
    lazy var mEmailLoginView: DDEmailLoginView = {
        let view = DDEmailLoginView()
        view.isHidden = true
        return view
    }()
}

private extension LoginVC {
    func _bindView() {
        _ = self.mLoginView.loginResult.subscribe(onNext: { [weak self] isLogin in
            guard let self = self else { return }
            self.loginResult.accept(isLogin)
            self.dismiss(animated: true) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    DDUtils.shared.getCurrentVC()?.navigationController?.popViewController(animated: true)
                }
            }
            
        })
        
        _ = self.mLoginView.emailClick.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.mLoginView.isHidden = true
            self.mEmailLoginView.isRegist = false
            self.mEmailLoginView.isHidden = false
        })
        
        _ = self.mLoginView.registClick.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.mLoginView.isHidden = true
            self.mEmailLoginView.isRegist = true
            self.mEmailLoginView.isHidden = false
        })
        
        _ = self.mLoginView.closeClick.subscribe(onNext: { [weak self] isLogin in
            guard let self = self else { return }
            self.dismiss(animated: true)
        })
        
        _ = self.mEmailLoginView.closeClick.subscribe(onNext: { [weak self] isLogin in
            guard let self = self else { return }
            self.mLoginView.isHidden = false
            self.mEmailLoginView.isHidden = true
        })
        
        _ = self.mEmailLoginView.loginResult.subscribe(onNext: { [weak self] isLogin in
            guard let self = self else { return }
            self.loginResult.accept(isLogin)
            self.dismiss(animated: true) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    DDUtils.shared.getCurrentVC()?.navigationController?.popViewController(animated: true)
                }
            }
        })
    }
    
    func _loadData() {
        
    }
    
    
}



