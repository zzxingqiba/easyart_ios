//
//  UnderlinedTextView.swift
//  easyart
//
//  Created by Damon on 2024/12/18.
//

import UIKit

class UnderlinedTextView: UITextView {
    
    // 固定行高
    private let fixedLineHeight: CGFloat = 40.0
    private let bottomPadding: CGFloat = 6
    
    override var font: UIFont? {
        didSet {
            updateAttributedText()
        }
    }
    
    override var text: String! {
        didSet {
            super.text = text
            updateAttributedText()
        }
    }
    
    // 更新文本的属性，动态调整行高
    private func updateAttributedText() {
        guard let font = self.font else { return }
        
        // 保留原始文本内容
        let currentText = self.text ?? ""
        
        // 设置行高，确保每行的高度为固定值
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = fixedLineHeight
        paragraphStyle.maximumLineHeight = fixedLineHeight
        
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .font: font
        ]
        
        // 创建一个新的 attributedString
        let attributedText = NSAttributedString(string: currentText, attributes: attributes)
        self.attributedText = attributedText
    }
    
    
    // 绘制下划线
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // 使用固定行高
        let lineHeight = fixedLineHeight
        
        // 设置下划线样式
        context.setStrokeColor(ThemeColor.line.color().cgColor)
        context.setLineWidth(1.0)
        
        // 计算下划线的起始位置
        var startY = textContainerInset.top + lineHeight + bottomPadding
        
        // 绘制每行下划线
        while startY < self.bounds.height {
            context.move(to: CGPoint(x: textContainerInset.left, y: startY))
            context.addLine(to: CGPoint(x: self.bounds.width - textContainerInset.right, y: startY))
            startY += lineHeight
        }
        
        // 绘制下划线
        context.strokePath()
    }
    
    // 更新布局时重新绘制下划线
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setNeedsDisplay()
    }
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        var orginal = super.caretRect(for: position)
        var height: CGFloat = 14
        if let font = self.font {
            height = font.lineHeight + 2
        }
        orginal.origin.y = orginal.origin.y + orginal.size.height - height
        orginal.size.height = height
        return orginal
    }
}
