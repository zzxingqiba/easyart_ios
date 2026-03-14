//
//  DDSearchSizeRange.swift
//  easyart
//
//  Created by Damon on 2024/11/28.
//

import Foundation

enum DDSearchSizeRange {
    case small
    case medium
    case large
    case custom(min: Int, max: Int)
}

extension DDSearchSizeRange {
    func id() -> Int {
        switch self {
        case .small:
            return 1
        case .medium:
            return 2
        case .large:
            return 3
        case .custom(_, _):
            return 4
        }
    }
    
    func range() -> (Int, Int) {
        switch self {
        case .small:
            return (0, 40)
        case .medium:
            return (40, 100)
        case .large:
            return (100, 1000)
        case .custom(let min, let max):
            return (min, max)
        }
    }
    
    func title() -> String {
        switch self {
        case .small:
            return "Small (under 40cm)".localString
        case .medium:
            return "Medium (40 - 100cm)".localString
        case .large:
            return "Large (over 100cm)".localString
        case .custom(_, _):
            return "Custom Size".localString
        }
    }
}

