//
//  UIScreen+SZ.swift
//  SZ_RxProDemo
//
//  Created by 山竹 on 2018/10/9.
//  Copyright © 2018年 SZ. All rights reserved.
//

import UIKit

extension UIScreen {
    
    /// 屏幕宽
    var sz_screenWidth: CGFloat {
        
        return UIScreen.main.bounds.size.width
    }
    
    /// 屏幕高
    var sz_screenHeight: CGFloat {
        
        return UIScreen.main.bounds.size.height
    }
    
    /// 导航栏高度
    var sz_navHeight: CGFloat {
        
        return UIDevice.current.sz_isNotchPhone ? 88 : 64
    }
}

public extension UIScreen {
    
    /// 根据屏幕适配
    ///
    /// - Parameter originalNum: 原始值
    /// - Returns: 适配后的值
    static func sz_layoutUI(originalNum: CGFloat) -> CGFloat {
        
        return UIScreen.main.sz_screenWidth / 375.0 * originalNum
    }
}
