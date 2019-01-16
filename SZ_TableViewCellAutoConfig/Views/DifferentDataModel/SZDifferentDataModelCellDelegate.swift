//
//  SZDifferentDataModelCellDelegate.swift
//  SZ_TableViewCellAutoConfig
//
//  Created by 山竹 on 2019/1/16.
//  Copyright © 2019 shanzhu. All rights reserved.
//

import UIKit

/// 不同的数据模型 cell 代理
@objc protocol SZDifferentDataModelCellDelegate: SZBaseCellDelegate {
    
    // MARK: - optional
    
    /// 点击了baseCell上的名称
    ///
    /// - Parameter cell: 对应的cell
    @objc optional func tapedNameOnCell(cell: UITableViewCell)
    
    /// 点击了baseCell上的图片item
    ///
    /// - Parameter cell: 对应的cell
    @objc optional func tapedImageItemOnCell(cell: UITableViewCell)
    
    /// 点击了baseCell上的天气图标
    ///
    /// - Parameter cell: 对应的cell
    @objc optional func tapedWeatherIconOnCell(cell: UITableViewCell)
}

/// 不同的数据模型 cell 控制 代理
@objc protocol SZDifferentDataModelCellControlProtocol: SZCellControlProtocol {
    
    /// 做点别的什么事情
    @objc func doSomethingElse()
}

/// 不同的数据模型 cell 配置 协议
protocol SZDifferentDataModelCellProtocol: SZBaseCellProtocol {
    
    /// 做点别的什么事情
    func doSomethingConfigElse()
}
