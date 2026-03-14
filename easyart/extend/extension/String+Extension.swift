//
//  String+Extension.swift
//  HiTalk
//
//  Created by Damon on 2024/5/29.
//

import Foundation
import UIKit

extension String{
    var localString: String {
//        return NSLocalizedString(self, comment: "")
        let lang = DDConfigTools.shared.getLanguage()
        if let json = DDConfigTools.shared.languageJSON(language: lang) {
            return json[self].string ?? self
        }
        return self
    }
    
    static func isAvailable(_ str: String?) -> Bool {
        return str != nil && !str!.isEmpty
    }
    
    //过滤emoji
    func removingEmojis() -> String {
        return self.filter { !$0.unicodeScalars.contains(where: { $0.properties.isEmojiPresentation || $0.properties.isEmojiModifierBase }) }
//        return self.filter { !$0.unicodeScalars.contains(where: { $0.properties.isEmoji }) }
        // 正则表达式匹配 Emoji
//                let emojiPattern = "[\\p{Emoji}]+"
//                let regex = try? NSRegularExpression(pattern: emojiPattern, options: [])
//                
//                // 使用正则表达式替换
//                let range = NSRange(location: 0, length: self.utf16.count)
//                let filteredString = regex?.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "")
//                
//                return filteredString ?? self
    }
    
    func isOnlySymbolString() -> Bool {
        // 使用正则表达式匹配所有非标点符号的字符，包括中文、英文、数字和空白字符
        let pattern = "[\\p{L}\\p{N}]"
        // 创建正则表达式对象
        if let regex = try? NSRegularExpression(pattern: pattern, options: .useUnicodeWordBoundaries) {
            let range = NSRange(location: 0, length: self.utf16.count)
            // 查找匹配项
            let matches = regex.firstMatch(in: self, options: [], range: range)
            // 如果找到匹配项，则不是只包含标点符号的字符串
            return matches == nil && self.count > 0
        }
        return false
    }
}

//消息处理
extension String {
    //过滤消息
    func filterMessage() -> String {
        var message = self.removingEmojis()
        message = message.replacingOccurrences(of: "---", with: "")
        message = message.replacingOccurrences(of: "**", with: "")
        message = message.replacingOccurrences(of: "\n\n", with: "\n")
        return message
    }
    
    //分词之后的消息
    func msgAttributeString(chatID: String, needSplit: Bool) -> NSAttributedString {
        let text = self.filterMessage()
        let isHtml = text.contains("<a") || text.contains("<img")
        let attributed = NSMutableAttributedString()
        if isHtml, let data = text.data(using: .utf8) {
            if let attribu = try? NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil) {
                attributed.append(attribu)
            } else {
                attributed.append(NSAttributedString(string: text))
            }
        } else if needSplit {
            attributed.append(text._splitText(chatID: chatID))
        } else {
            attributed.append(NSAttributedString(string: text))
        }
        return attributed
    }
    
    //增加复制按钮
    static func copyButton() -> NSAttributedString {
        let attributed = NSMutableAttributedString(string: "  ")
        let copyAttach = NSTextAttachment(image: UIImage(named: "icon-copy")!)
        copyAttach.bounds = CGRect(x: 0, y: -8, width: 30, height: 30)
        attributed.append(NSAttributedString(attachment: copyAttach))
        attributed.addAttributes([.link: "copyClick"], range: NSRange(location: 2, length: attributed.length - 2))
        return attributed
    }
}

private extension String {
    func _splitText(chatID: String) -> NSAttributedString {
        let text = self
        let pattern = "([" + "\"“”＂," + "，；。:：;.！!？?—\\s" + "]+)"
        let regex = try! NSRegularExpression(pattern: pattern, options: [])

        let results = regex.matches(in: text, options: [], range: NSRange(text.startIndex..., in: text))

        let attributedString = NSMutableAttributedString()

        var currentIndex = text.startIndex
        
        var index = 0
        for result in results {
            // 获取正则匹配前的部分
            let range = Range(uncheckedBounds: (lower: currentIndex, upper: text.index(text.startIndex, offsetBy: result.range.location)))
            let substring = text[range]
            
            // 添加普通文本
            let attributedPart = NSMutableAttributedString(string: String(substring))
//            attributedPart.addAttributes([.link: "click\(index)://", .foregroundColor: UIColor.red], range: NSRange(location: 0, length: substring.count))
            attributedPart.addAttributes([.attachment: "click_\(index)_\(chatID)_\(substring)"], range: NSRange(location: 0, length: substring.count))
            attributedPart.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: substring.count))
            attributedString.append(attributedPart)
            
            // 获取正则匹配的部分
            let matchRange = Range(result.range, in: text)!
            let matchSubstring = text[matchRange]
            
            // 添加符号部分
            let attributedMatchPart = NSMutableAttributedString(string: String(matchSubstring))
//            attributedMatchPart.addAttribute(.foregroundColor, value: UIColor.red, range: NSRange(location: 0, length: matchSubstring.count))
            attributedString.append(attributedMatchPart)
            
            currentIndex = text.index(text.startIndex, offsetBy: result.range.location + result.range.length)
            
            index = index + 1
        }

        // 添加最后一个部分
        if currentIndex < text.endIndex {
            let finalRange = currentIndex..<text.endIndex
            let finalSubstring = text[finalRange]
            
            let finalAttributedPart = NSMutableAttributedString(string: String(finalSubstring))
            finalAttributedPart.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: finalSubstring.count))
            attributedString.append(finalAttributedPart)
        }
        
        return attributedString
    }
}
