//
//  DDUserDefaultManager+zxkit.swift
//  DDUserDefaultManager
//
//  Created by Damon on 2021/7/15.
//

import Foundation
import DDKitSwift
import DDUserDefaultManager

func UIImageHDBoundle(named: String?) -> UIImage? {
    guard let name = named else { return nil }
    guard let bundlePath = Bundle(for: DDKitSwift_UserDefaultManager.self).path(forResource: "DDKitSwift_UserDefaultManager", ofType: "bundle") else { return UIImage(named: name) }
    guard let bundle = Bundle(path: bundlePath) else { return UIImage(named: name) }
    return UIImage(named: name, in: bundle, compatibleWith: nil)
}

extension String{
    var ZXLocaleString: String {
        guard let bundlePath = Bundle(for: DDKitSwift_UserDefaultManager.self).path(forResource: "DDKitSwift_UserDefaultManager", ofType: "bundle") else { return NSLocalizedString(self, comment: "") }
        guard let bundle = Bundle(path: bundlePath) else { return NSLocalizedString(self, comment: "") }
        let msg = NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
        return msg
    }
}

open class DDKitSwift_UserDefaultManager: DDKitSwiftPluginProtocol {
    public init() {
        
    }    
    
    public var pluginIdentifier: String {
        return "com.ddkit.DDKitSwift_UserDefaultManager"
    }

    public var pluginIcon: UIImage? {
        return UIImageHDBoundle(named: "DDUserDefaultManager")
    }

    public var pluginTitle: String {
        return "UserDefaultManager".ZXLocaleString
    }

    public var pluginType: DDKitSwiftPluginType {
        return .data
    }

    public var isRunning: Bool {
        return false
    }
    
    public func start() {
        let vc = DDUserDefaultVC()
        DDKitSwift.getCurrentNavigationVC()?.pushViewController(vc, animated: true)
    }

    public func stop() {

    }
}

