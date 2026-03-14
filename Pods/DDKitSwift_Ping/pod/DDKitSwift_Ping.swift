//
//  DDPingTools+zxkit.swift
//  DDPingTools
//
//  Created by Damon on 2021/4/29.
//

import Foundation
import DDKitSwift
import DDPingTools
import DDLoggerSwift

func UIImageHDBoundle(named: String?) -> UIImage? {
    guard let name = named else { return nil }
    guard let bundlePath = Bundle(for: DDKitSwift_Ping.self).path(forResource: "DDKitSwift_Ping", ofType: "bundle") else { return nil }
    let bundle = Bundle(path: bundlePath)
    return UIImage(named: name, in: bundle, compatibleWith: nil)
}

extension String{
    var ZXLocaleString: String {
        //优先使用主项目翻译
        let mainValue = NSLocalizedString(self, comment: "")
        if mainValue != self {
            return mainValue
        }
        //使用自己的bundle
        if let bundlePath = Bundle(for: DDKitSwift_Ping.self).path(forResource: "DDKitSwift_Ping", ofType: "bundle"), let bundle = Bundle(path: bundlePath) {
            return NSLocalizedString(self, tableName: nil, bundle: bundle, value: self, comment: "")
        }
        return self
    }
}

//ZXKitPlugin
open class DDKitSwift_Ping: DDKitSwiftPluginProtocol {
    private var url: String
    
    public init(url: String) {
        self.url = url
    }
    
    public var pluginIdentifier: String {
        return "com.ddkit.DDKitSwift_Ping"
    }

    public var pluginIcon: UIImage? {
        return UIImageHDBoundle(named: "HDPingTool.png")
    }

    public var pluginTitle: String {
        return "Website Speed Test".ZXLocaleString
    }

    public var pluginType: DDKitSwiftPluginType {
        return .other
    }

    public func start() {
        let vc = DDPingViewController()
        vc.defaultUrl = self.url
        DDKitSwift.getCurrentNavigationVC()?.pushViewController(vc, animated: true)
    }
    
    public var isRunning: Bool {
        return false
    }
    
    public func stop() {
        
    }
}
