//
//  DispatchTime+SZ.swift
//  SZ_TableViewCellAutoConfig
//
//  Created by 山竹 on 2019/1/18.
//  Copyright © 2019 shanzhu. All rights reserved.
//

import Foundation

// MARK: - 初始化方法扩展
extension DispatchTime: ExpressibleByFloatLiteral {
    
    /// DispatchTime.now() + Float 值 初始化 DispatchTime
    ///
    /// - Parameter value: Float 值
    public init(floatLiteral value: Float) {
        
        self = DispatchTime.now() + .milliseconds(Int(value * 1000))
    }
    
    /// DispatchTime.now() + Int 值 初始化 DispatchTime
    ///
    /// - Parameter value: Int 值
    public init(integerLiteral value: Int) {
        
        self = DispatchTime.now() + .seconds(value)
    }
}
