//
//  UIColor+Adjusted.swift
//  easyart
//
//  Created by Damon on 2024/12/10.
//

import UIKit

extension UIColor {
    /// 调整颜色亮度
    /// - Parameter percentage: 调整比例（负值变暗，正值变亮）
    /// - Returns: 调整后的颜色
    func adjusted(by percentage: CGFloat) -> UIColor {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        // 获取当前颜色的 RGBA 值
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            // 按比例调整亮度
            return UIColor(
                red: min(red + percentage / 100, 1.0),
                green: min(green + percentage / 100, 1.0),
                blue: min(blue + percentage / 100, 1.0),
                alpha: alpha
            )
        }
        return self // 无法解析 RGBA 时返回原色
    }
}

