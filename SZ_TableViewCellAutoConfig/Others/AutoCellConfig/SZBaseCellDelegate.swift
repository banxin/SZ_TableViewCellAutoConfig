//
//  SZBaseCellDelegate.swift
//  SZ_TableViewCellAutoConfig
//
//  Created by 山竹 on 2019/1/11.
//  Copyright © 2019 shanzhu. All rights reserved.
//

import UIKit

/// base cell 代理 (自定义的 delegate 继承 base)
@objc protocol SZBaseCellDelegate {
    
    // MARK: - 可选扩展
    
    /// 选择了某个item
    ///
    /// - Parameter indexPath: indexPath tableView indexPath
    @objc optional func didSelectedItemAtIndexPath(indexPath: NSIndexPath)
}

/// base cell 配置 协议 (自定义的 protocol 继承 base)
protocol SZBaseCellProtocol {
    
    /// 代理
    var delegate: (SZCellControlProtocol & SZBaseCellDelegate)? {get set}
    
    /// 配置 cell 对应的数据模型
    ///
    /// - Parameter data: model
    func configWithData(data: Any)
}
