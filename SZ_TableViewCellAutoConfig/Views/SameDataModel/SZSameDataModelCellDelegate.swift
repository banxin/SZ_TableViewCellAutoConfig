//
//  SZSameDataModelCellDelegate.swift
//  SZ_TableViewCellAutoConfig
//
//  Created by 山竹 on 2019/1/11.
//  Copyright © 2019 shanzhu. All rights reserved.
//

import UIKit

/// 相同的数据模型 cell 代理
@objc protocol SZSameDataModelCellDelegate: SZBaseCellDelegate {
    
    // MARK: - optional
    
    /// 点击了baseCell上的名称
    ///
    /// - Parameter cell: 对应的cell
    @objc optional func tapedNameOnCell(cell: UITableViewCell)
}

/// 相同的数据模型 cell 控制 代理
@objc protocol SZSameDataModelCellControlProtocol: SZCellControlProtocol {
    
    /// 做点别的什么事情
    @objc func doSomethingElse()
}

/// 相同的数据模型 cell 配置 协议
protocol SZSameDataModelCellProtocol: SZBaseCellProtocol {
    
    /// 做点别的什么事情
    func doSomethingConfigElse()
}
