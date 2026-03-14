//
//  AppDelegate.swift
//  HiTalk
//
//  Created by Damon on 2024/5/24.
//

import DDKitSwift
import DDKitSwift_FileBrowser
import DDKitSwift_FPS
import DDKitSwift_Netfox
import DDKitSwift_Ping
import DDKitSwift_UserDefaultManager
import DDUtils
import ESTabBarController_swift
import GoogleSignIn
import HDHUD
import IQKeyboardManagerSwift
import IQKeyboardToolbarManager
import StripePayments
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        DDKitSwift.regist(plugin: DDKitSwift_Netfox())
        DDKitSwift.regist(plugin: DDKitSwift_FPS())
        DDKitSwift.regist(plugin: DDKitSwift_Ping(url: "https://xapi.easyartonline.com"))
        DDKitSwift.regist(plugin: DDKitSwift_FileBrowser())
        DDKitSwift.regist(plugin: DDKitSwift_UserDefaultManager())
        DDCacheTools.setup()
        //
        var imageList = [UIImage]()
        for i in 0 ..< 150 {
            if let image = UIImage(named: "load_\(i).png") {
                imageList.append(image)
            }
        }
        HDHUD.loadingImage = UIImage.animatedImage(with: imageList, duration: 1)
        //
        self._setupVC()
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.resignOnTouchOutside = true
        IQKeyboardToolbarManager.shared.isEnabled = true
        return true
    }
    
    func _setupVC() {
        let vc = self._setupTabBar()
        
        self.window?.backgroundColor = UIColor.dd.color(hexValue: 0xeeeeee)
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
    }
    
    func _setupTabBar() -> BaseTabBarController {
        let tabBarController = BaseTabBarController()
        if #available(iOS 15, *) {
            let bar = UITabBarAppearance()
            bar.backgroundImage = UIImage()
            bar.backgroundColor = UIColor.dd.color(hexValue: 0xffffff, alpha: 0.1)
            bar.shadowImage = UIImage()
            tabBarController.tabBar.scrollEdgeAppearance = bar
            tabBarController.tabBar.standardAppearance = bar
        } else {
            tabBarController.tabBar.shadowImage = UIImage()
            tabBarController.tabBar.backgroundImage = UIImage()
            tabBarController.tabBar.backgroundColor = UIColor.dd.color(hexValue: 0xffffff, alpha: 0.1)
        }
//        tabBarController.tabBar.shadowImage =  UIImage.dd.getImage(color: ThemeColor.line.color())
//        tabBarController.tabBar.backgroundColor = UIColor.dd.color(hexValue: 0xffffff, alpha: 0.95)
//        tabBarController.tabBar.backgroundImage = UIImage()
        
        let homeVC = HomeVC()
        let v1 = BaseNavigationController(rootViewController: homeVC)
//        let searchVC = SearchVC()
        let searchVC = DDSearchVC()
        let v2 = BaseNavigationController(rootViewController: searchVC)
        let activeVC = ActiveVC()
        let v3 = BaseNavigationController(rootViewController: activeVC)
        let mineVC = MineVC()
        let v4 = BaseNavigationController(rootViewController: mineVC)
        let meVC = MeVC()
        let v5 = BaseNavigationController(rootViewController: meVC)

        v1.tabBarItem = ESTabBarItem(BaseTabBarItemContentView(textColor: UIColor.dd.color(hexValue: 0x2f323e)), title: nil, image: UIImage(named: "tab1"), selectedImage: UIImage(named: "tab_selected1"))
        v2.tabBarItem = ESTabBarItem(BaseTabBarItemContentView(textColor: UIColor.dd.color(hexValue: 0x2f323e)), title: nil, image: UIImage(named: "tab2"), selectedImage: UIImage(named: "tab_selected2"))
        v3.tabBarItem = ESTabBarItem(BaseTabBarItemContentView(textColor: UIColor.dd.color(hexValue: 0x2f323e)), title: nil, image: UIImage(named: "tab5"), selectedImage: UIImage(named: "tab_selected5"))
        v4.tabBarItem = ESTabBarItem(BaseTabBarItemContentView(textColor: UIColor.dd.color(hexValue: 0x2f323e)), title: nil, image: UIImage(named: "tab4"), selectedImage: UIImage(named: "tab_selected4"))
        v5.tabBarItem = ESTabBarItem(BaseTabBarItemContentView(textColor: UIColor.dd.color(hexValue: 0x2f323e)), title: nil, image: UIImage(named: "tab4"), selectedImage: UIImage(named: "tab_selected4"))

        tabBarController.viewControllers = [v4, v5, v1, v2, v3]
        
        // 添加小红点
        _ = DDUserTools.shared.userInfo.subscribe(onNext: { userModel in
            if userModel.collect_new || userModel.new_sys_msg || userModel.new_follow_msg || userModel.order_new || userModel.sellout_new {
                v4.tabBarItem.badgeValue = ""
            } else {
                v4.tabBarItem.badgeValue = nil
            }
        })

        return tabBarController
    }
}

extension AppDelegate {
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        let stripeHandled = StripeAPI.handleURLCallback(with: url)
        if stripeHandled {
            return true
        }
        if url.scheme == "speakpal" {
            if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
               let queryItems = components.queryItems
            {
                var oauthToken: String?
                var oauthVerifier: String?
                
                for item in queryItems {
                    if item.name == "oauth_token" {
                        oauthToken = item.value
                    } else if item.name == "oauth_verifier" {
                        oauthVerifier = item.value
                    }
                }
                
                _ = DDUserTools.shared.twitterLogin(oauth_token: oauthToken, oauth_verifier: oauthVerifier).subscribe(onSuccess: { isLogin in
                    if let vc = DDUtils.shared.getCurrentVC() as? LoginVC {
                        vc.loginResult.accept(isLogin)
                        vc.dismiss(animated: true)
                    }
                })
            }
            return true
        } else {
            // 谷歌登陆
            return GIDSignIn.sharedInstance.handle(url)
        }
    }
}
