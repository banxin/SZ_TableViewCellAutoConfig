//
//  UILabel+SZ.swift
//  SZ_RxProDemo
//
//  Created by 山竹 on 2018/11/9.
//  Copyright © 2018年 SZ. All rights reserved.
//

import UIKit

// MARK: - 便利构造函数
public extension UILabel {
    
    /// 便利构造函数
    ///
    /// - parameter title:    title
    /// - parameter fontSize: fontSize，默认 14 号字
    /// - parameter color:    color，默认深灰色
    ///
    /// - returns: UILabel
    /// 参数后面的值是参数的默认值，如果不传递，就使用默认值
    convenience init(title: String, fontSize: CGFloat = 14, color: UIColor = UIColor.darkGray) {
        self.init()
        
        text      = title
        textColor = color
        font      = UIFont.systemFont(ofSize: fontSize)
    }
}

// MARK: - static method
public extension UILabel {
    
    /// 获取 text文本 的宽度
    ///
    /// - Parameters:
    ///   - title: text文本
    ///   - font:  text文本的字号
    static func hpc_getWidthWithTitle(title: String, font: UIFont = UIFont.systemFont(ofSize: 14)) -> CGFloat {
        
        let label = UILabel.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.sz_screenWidth, height: 0))
        
        label.text = title
        label.font = font
        
        label.sizeToFit()
        
        return label.frame.size.width
    }
}

