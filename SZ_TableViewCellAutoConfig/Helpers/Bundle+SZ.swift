//
//  Bundle+SZ.swift
//  SZ_RxProDemo
//
//  Created by 山竹 on 2018/11/8.
//  Copyright © 2018年 SZ. All rights reserved.
//

import Foundation

// MARK: - 计算型属性
public extension Bundle {
    
    /// 命名空间
    var sz_namespace: String {
        
        return infoDictionary?["CFBundleName"] as? String ?? ""
    }
}
