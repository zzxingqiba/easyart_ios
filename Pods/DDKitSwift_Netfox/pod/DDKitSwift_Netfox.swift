//
//  NetFox+zxkit.swift
//  DDKitSwift_Netfox
//
//  Created by Damon on 2021/7/17.
//

import Foundation
import DDKitSwift
import netfox

func UIImageHDBoundle(named: String?) -> UIImage? {
    guard let name = named else { return nil }
    guard let bundlePath = Bundle(for: DDKitSwift_Netfox.self).path(forResource: "DDKitSwift_Netfox", ofType: "bundle") else { return UIImage(named: name) }
    guard let bundle = Bundle(path: bundlePath) else { return UIImage(named: name) }
    return UIImage(named: name, in: bundle, compatibleWith: nil)
}

extension String{
    var ZXLocaleString: String {
        guard let bundlePath = Bundle(for: DDKitSwift_Netfox.self).path(forResource: "DDKitSwift_Netfox", ofType: "bundle") else { return NSLocalizedString(self, comment: "") }
        guard let bundle = Bundle(path: bundlePath) else { return NSLocalizedString(self, comment: "") }
        let msg = NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
        return msg
    }
}

open class DDKitSwift_Netfox: DDKitSwiftPluginProtocol {
    public init() {
        NFX.sharedInstance().setGesture(.custom)
        NFX.sharedInstance().start()
    }
    
    public var pluginIdentifier: String {
        return "com.ddkit.netfox"
    }

    public var pluginIcon: UIImage? {
        return UIImageHDBoundle(named: "netfox_logo")
    }

    public var pluginTitle: String {
        return "NetWork".ZXLocaleString
    }

    public var pluginType: DDKitSwiftPluginType {
        return .other
    }

    public var isRunning: Bool {
        return NFX.sharedInstance().isStarted()
    }
    
    public func start() {
        DDKitSwift.hide()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if !self.isRunning {
                NFX.sharedInstance().start()
            }
            NFX.sharedInstance().show()
        }
    }

    public func stop() {
        DDKitSwift.hide()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if !self.isRunning {
                NFX.sharedInstance().start()
            }
            NFX.sharedInstance().show()
        }
    }


}
