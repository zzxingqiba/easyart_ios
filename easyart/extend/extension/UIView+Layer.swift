//
//  UIView+Layer.swift
//  easyart
//
//  Created by Damon on 2024/12/10.
//

import Foundation
import UIKit

extension UIView {
    func addBorderCorners(corners: UIRectCorner, corner: CGFloat) {
        self.layoutIfNeeded()
        let maskPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: corner, height: corner)).cgPath
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath
        self.layer.mask = maskLayer
    }
    
    func addBorderCornersAndShadow(corners: UIRectCorner, cornerRadius: CGFloat, shadowOffset: CGSize, shadowColor: UIColor, shadowRadius: CGFloat, fillColor: UIColor = UIColor.dd.color(hexValue: 0xFFFFFF)) {
        if shadowRadius > 0 {
            //绘制阴影
            let shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
            let context = UIGraphicsGetCurrentContext()
            context?.setShadow(offset: shadowOffset, blur: shadowRadius, color: shadowColor.cgColor)
            fillColor.setFill()
            shadowPath.fill()
        }
        
        //绘制mask
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        maskLayer.frame = self.bounds
        layer.mask = maskLayer
    }
    
    //增加内阴影
    func addInnerShadow() {
        // 更新自动布局的 bounds
            self.setNeedsLayout()
            self.layoutIfNeeded()
            
            self.removeInnerShadow()
            
            // 创建一个阴影图层
            let shadowLayer = CAShapeLayer()
            shadowLayer.name = "InnerShadowLayer"
            shadowLayer.frame = bounds
            
        // 设置阴影颜色、偏移、透明度和模糊半径
            shadowLayer.shadowColor = UIColor.black.cgColor
            shadowLayer.shadowOffset = CGSize(width: 0, height: 0)
        shadowLayer.shadowOpacity = 0.8
            shadowLayer.shadowRadius = 3.0

            // 设置填充规则为 even-odd
            shadowLayer.fillRule = .evenOdd

            // 创建路径
            let outerPath = UIBezierPath(rect: bounds.insetBy(dx: -3, dy: -3)) // 外部路径
            let innerPath = UIBezierPath(rect: bounds).reversing()                           // 内部路径
            outerPath.append(innerPath)                              // 反转内部路径并添加到外部路径

            // 将路径赋值给图层
            shadowLayer.path = outerPath.cgPath
            shadowLayer.masksToBounds = true
            // 添加阴影图层到视图的主图层
            layer.addSublayer(shadowLayer)
    }
    
    func removeInnerShadow() {
        // 查找并移除名为 "InnerShadowLayer" 的子图层
        layer.sublayers?.removeAll(where: { $0.name == "InnerShadowLayer" })
    }
    
    /// 在视图的指定角上裁出斜角切角
    /// - Parameters:
    ///   - corner: 需要切掉的角 (.topLeft, .topRight, .bottomLeft, .bottomRight)
    ///   - size: 斜角的边长
    public enum Corner: Int {
            case TopRight
            case TopLeft
            case BottomRight
            case BottomLeft
            case All
        }
    func cutDiagonalCorner(corner: Corner, length: CGFloat) {
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        let maskLayer = CAShapeLayer()
                var path: CGPath?
                switch corner {
                case .All:
                    path = self.makeAnglePathWithRect(self.bounds, topLeftSize: length, topRightSize: length, bottomLeftSize: length, bottomRightSize: length)
                case .TopRight:
                    path = self.makeAnglePathWithRect(self.bounds, topLeftSize: 0.0, topRightSize: length, bottomLeftSize: 0.0, bottomRightSize: 0.0)
                case .TopLeft:
                    path = self.makeAnglePathWithRect(self.bounds, topLeftSize: length, topRightSize: 0.0, bottomLeftSize: 0.0, bottomRightSize: 0.0)
                case .BottomRight:
                    path = self.makeAnglePathWithRect(self.bounds, topLeftSize: 0.0, topRightSize: 0.0, bottomLeftSize: 0.0, bottomRightSize: length)
                case .BottomLeft:
                    path = self.makeAnglePathWithRect(self.bounds, topLeftSize: 0.0, topRightSize: 0.0, bottomLeftSize: length, bottomRightSize: 0.0)
                }
                maskLayer.path = path
                maskLayer.fillRule = .evenOdd
                self.layer.mask = maskLayer
    }
    
    func removeDiagonalCornerMask() {
        layer.mask = nil
    }
}

private extension UIView {
    func makeAnglePathWithRect(_ rect: CGRect, topLeftSize tl: CGFloat, topRightSize tr: CGFloat, bottomLeftSize bl: CGFloat, bottomRightSize br: CGFloat) -> CGPath {
            var points = [CGPoint]()

            points.append(CGPointMake(rect.origin.x + tl, rect.origin.y))
            points.append(CGPointMake(rect.origin.x + rect.size.width - tr, rect.origin.y))
            points.append(CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + tr))
            points.append(CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height - br))
            points.append(CGPointMake(rect.origin.x + rect.size.width - br, rect.origin.y + rect.size.height))
            points.append(CGPointMake(rect.origin.x + bl, rect.origin.y + rect.size.height))
            points.append(CGPointMake(rect.origin.x, rect.origin.y + rect.size.height - bl))
            points.append(CGPointMake(rect.origin.x, rect.origin.y + tl))

        let path = CGMutablePath()
        path.move(to: points.first!, transform: .identity)
        for point in points {
                if point != points.first {
                    path.addLine(to: point, transform: .identity)
                }
            }
        path.addLine(to: points.first!, transform: .init())
            return path
        }
}
