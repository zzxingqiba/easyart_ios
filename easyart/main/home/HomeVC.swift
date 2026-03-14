//
//  HomeVC.swift
//  easyart
//
//  Created by Damon on 2024/9/9.
//

import UIKit
import DDLoggerSwift
import SwiftyJSON
import CoreMotion

class HomeVC: BaseVC {
    var mBannerList = [JSON]()
    let motionManager = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true
        self.view.backgroundColor = UIColor.dd.color(hexValue: 0xffffff)
        self._loadData()
        self._bindView()
        
        if APP_DEBUG {
            //摇一摇
            if motionManager.isAccelerometerAvailable {
                motionManager.accelerometerUpdateInterval = 0.1
                motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
                    guard let data = data, error == nil else { return }
                    // 计算加速度变化（矢量和）
                    let acceleration = data.acceleration
                    let shakeThreshold: Double = 2.0 // 设定摇动检测阈值（可调整）
                    let magnitude = sqrt(acceleration.x * acceleration.x +
                                         acceleration.y * acceleration.y +
                                         acceleration.z * acceleration.z)
                    
                    if magnitude > shakeThreshold {
                        DDLoggerSwift.showShare()
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !self.mContentView.isHidden {
            self.mContentView.reloadData()
        }
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        if (BottomSafeAreaHeight < 0) {
            BottomSafeAreaHeight = self.view.safeAreaInsets.bottom / 2
            if BottomSafeAreaHeight != 0 {
                BottomSafeAreaHeight = BottomSafeAreaHeight + 10
            }
        }
    }
    
    override func createUI() {
        super.createUI()
        
        self.view.addSubview(mBannerView)
        mBannerView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.view)
        }
        
        self.view.addSubview(mContentView)
        mContentView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    

    //MARK: UI
    lazy var mBannerView: HomeBanner = {
        let view = HomeBanner()
        view.backgroundColor = UIColor.dd.color(hexValue: 0xeeeeee)
        return view
    }()
    
    lazy var mContentView: HomeContentView = {
        let view = HomeContentView()
        view.isHidden = true
        return view
    }()
}

extension HomeVC {
    func _loadData() {
        _ = DDServerConfigTools.shared.updateConfig().subscribe(onSuccess: { json in
            printLog("配置拉取成功")
            self.mBannerList = json["banner_list"].arrayValue
            self.mBannerView.updateUI(list: json["banner_list"].arrayValue)
        })
    }
    
    func _bindView() {
        _ = self.mBannerView.scrollPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.mBannerView.isHidden = true
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            self.tabBarController?.tabBar.isHidden = false
            self.mContentView.reloadData()
            self.mContentView.isHidden = false
        })
        
        _ = self.mBannerView.clickPublish.subscribe(onNext: { [weak self] index in
            guard let self = self else { return }
            self.mBannerView.isHidden = true
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            self.tabBarController?.tabBar.isHidden = false
            self.mContentView.reloadData()
            self.mContentView.isHidden = false
            //点击跳转
            let model = self.mBannerList[index]
            //跳转详情页
            if model["jump_type"].intValue == 3 {
                let vc = DetailVC(goodsID: model["jump_id"].stringValue)
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
        
        _ = self.mContentView.clickPublish.subscribe(onNext: { [weak self] model in
            guard let self = self else { return }
            let vc = DetailVC(goodsID: model.goods_id)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
        _ = self.mContentView.authorClickPublish.subscribe(onNext: { [weak self] model in
            guard let self = self else { return }
            let vc = DDAuthorDetailVC(id: model.artist_id)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        })
    }
}
