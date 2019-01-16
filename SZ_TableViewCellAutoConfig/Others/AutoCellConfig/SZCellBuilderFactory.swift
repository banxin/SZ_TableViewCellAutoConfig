//
//  SZCellBuilderFactory.swift
//  SZ_TableViewCellAutoConfig
//
//  Created by 山竹 on 2019/1/11.
//  Copyright © 2019 shanzhu. All rights reserved.
//

import UIKit

/// cell 创建 dataSource
@objc protocol SZCellBuilderDataSource {
    
    /// 获取cell的tableView （可能需要用到table，例：自动缓存行高时）
    @objc optional func tableViewForCellBuilder() -> UITableView
}

/// cell 创建 protocol
protocol SZCellBuilderProtocol {
    
    // dataSource
    var dataSource: SZCellBuilderDataSource? {get set}
    
    /// cell 数据类型（classString 或者 某个指定的key）
    ///
    /// - Returns: 类型
    func supportDataType() -> String
    
    /// cell 高度
    ///
    /// - Parameter model: cell model
    /// - Returns: cell 高度
    func cellHeightWithModel(model: Any) -> CGFloat
    
    /// cell 注册ID
    ///
    /// - Returns: 注册ID
    func cellReuseId() -> String
    
    /// cell class
    ///
    /// - Returns: class
    func cellClass() -> AnyClass
}

/// cell 创建工厂
class SZCellBuilderFactory: NSObject {

    // 存储注册cell 的 dic
    private lazy var builderDict = [String : SZCellBuilderProtocol]()
}

// MARK: - public method
extension SZCellBuilderFactory {
    
    /// 注册
    ///
    /// - Parameter cellBuilder: 某个 cell 实例
    func registerCellBuilder(cellBuilder: SZCellBuilderProtocol) {
        
        // 注册 cell
        if let tableView = cellBuilder.dataSource?.tableViewForCellBuilder?() {
            
            tableView.register(cellBuilder.cellClass(), forCellReuseIdentifier: cellBuilder.cellReuseId())
        }
        
        builderDict[cellBuilder.supportDataType()] = cellBuilder
    }
    
    /*
     提供两种方式获取cell的实例，对应supportDataType的两种key:
     
     一种是model的classString；
     一种是指定的key。
     */
    
    /// 根据class类型 获取cell实例
    ///
    /// - Parameter dataType: 某个class类型实例
    /// - Returns: 已注册的cell实例
    func getCellBuilderWithDataType(dataType: AnyClass) -> SZCellBuilderProtocol? {
        
        return builderDict[NSStringFromClass(dataType)] ?? nil
    }
    
    /// 根据注册key 获取cell实例
    ///
    /// - Parameter registerKey: 注册key
    /// - Returns: 已注册的cell实例
    func getCellBuilderWithRegisterKey(registerKey: String) -> SZCellBuilderProtocol? {
        
        return builderDict[registerKey] ?? nil
    }
    
    /// 获取所有注册的cell dic
    ///
    /// - Returns: 所有的cell
    func allCellBuilder() -> [String : SZCellBuilderProtocol] {
        
        return builderDict
    }
    
    /// 获取所有的cell list
    ///
    /// - Returns: 所有的cell
    func allCellBuilderList() -> [SZCellBuilderProtocol] {
        
        return Array(builderDict.values)
    }
}
