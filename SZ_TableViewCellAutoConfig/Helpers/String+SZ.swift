//
//  String+SZ.swift
//  SZ_RxProDemo
//
//  Created by 山竹 on 2018/11/19.
//  Copyright © 2018年 SZ. All rights reserved.
//

import UIKit

// MARK: - String 扩展
public extension String {
    
    /// 从左截取到指定长度的字符串
    func left(to count: Int) -> String {
        
        if self.count < count { return self }
        
        return "\(self[..<index(startIndex, offsetBy: count)])"
    }
    
    /// 获取 self 的 size
    ///
    /// - Parameters:
    ///   - font:  字体大小
    ///   - size:  指定的size
    ///   - model: LineBreakMode
    /// - Returns: self 的 size
    func sz_fetchSize(font: UIFont = UIFont.systemFont(ofSize: 14), size: CGSize, model: NSLineBreakMode) -> CGSize {
        
        let paragraph = NSMutableParagraphStyle()
        
        paragraph.lineBreakMode = model
        
        // 统一控制 文字大小（14），行间距（5），段落间距（5），统一字体颜色（666666）
        let attributes = [kCTFontAttributeName as NSAttributedString.Key : font,
                          kCTParagraphStyleAttributeName as NSAttributedString.Key : paragraph]
        
        let rect: CGRect = (self as NSString).boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: attributes, context: nil)
        
        return rect.size
    }
}
