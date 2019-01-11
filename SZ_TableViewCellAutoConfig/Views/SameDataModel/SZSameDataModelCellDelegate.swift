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
    
    /// 点击了baseCell上的类型
    ///
    /// - Parameter cell: 对应的cell
    @objc optional func tapedTypeOnBaseCell(cell: UITableViewCell)
}

/// 相同的数据模型 cell 配置 协议
protocol SZSameDataModelCellProtocol: SZBaseCellProtocol {
    
    /// 代理
    var delegate: (SZCellControlProtocol & SZSameDataModelCellDelegate)? {get set}
}
