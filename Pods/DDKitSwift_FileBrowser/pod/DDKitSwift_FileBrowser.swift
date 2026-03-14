//
//  DDFileBrowser+DDKitSwift.swift
//  DDFileBrowserDemo
//
//  Created by Damon on 2021/5/11.
//

import Foundation
import DDFileBrowser
import DDKitSwift

func UIImageHDBoundle(named: String?) -> UIImage? {
    guard let name = named else { return nil }
    guard let bundlePath = Bundle(for: DDKitSwift_FileBrowser.self).path(forResource: "DDKitSwift_FileBrowser", ofType: "bundle") else { return UIImage(named: name) }
    guard let bundle = Bundle(path: bundlePath) else { return UIImage(named: name) }
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
        if let bundlePath = Bundle(for: DDKitSwift_FileBrowser.self).path(forResource: "DDKitSwift_FileBrowser", ofType: "bundle"), let bundle = Bundle(path: bundlePath) {
            return NSLocalizedString(self, tableName: nil, bundle: bundle, value: self, comment: "")
        }
        return self
    }
}

open class DDKitSwift_FileBrowser: DDKitSwiftPluginProtocol {
    private var tool = DDFileBrowser.shared
    
    public init() {
        
    }
    
    public var pluginIdentifier: String {
        return "com.DDKitSwift.DDKitSwift_FileBrowser"
    }

    public var pluginIcon: UIImage? {
        return UIImageHDBoundle(named: "DDFileBrowser")
    }

    public var pluginTitle: String {
        return "FileBrowser".ZXLocaleString
    }

    public var pluginType: DDKitSwiftPluginType {
        return .other
    }

    public var isRunning: Bool {
        return false
    }
    
    public func start() {
//        self.tool.start()
        let vc = DDFileBrowserVC()
        DDKitSwift.getCurrentNavigationVC()?.pushViewController(vc, animated: true)
    }

    public func stop() {
        
    }
}
