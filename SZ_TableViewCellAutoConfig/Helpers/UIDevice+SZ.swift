//
//  UIDevice+SZ.swift
//  SZ_RxProDemo
//
//  Created by 山竹 on 2018/10/9.
//  Copyright © 2018年 SZ. All rights reserved.
//

import UIKit

// MARK: - static method
public extension UIDevice {
    
    /// 是否是刘海屏
    var sz_isNotchPhone: Bool {
        
        if #available(iOS 11.0, *) {
            
            if let keyWindow = UIApplication.shared.delegate?.window,
                let bottonSafeInset = keyWindow?.safeAreaInsets.bottom {
                
                if bottonSafeInset > 0 {
                    
                    return true
                }
            }
        }
        
        return false
    }
}
