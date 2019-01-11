//
//  SZCellControlFactory.swift
//  SZ_TableViewCellAutoConfig
//
//  Created by 山竹 on 2019/1/11.
//  Copyright © 2019 shanzhu. All rights reserved.
//

import UIKit

/// cell 控制 DataSource
@objc protocol SZCellControlDataSource {
    
    // MARK: - 可选扩展
    
    /// 配置cell的数据模型（需要拿到数据做一些事情）
    ///
    /// - Parameter indexPath: indexPath
    /// - Returns: 数据模型
    @objc optional func dataModelForCell(indexPath: NSIndexPath)
    
    /// 获取cell的tableView（可能需要用到table，例：刷新cell的某一cell 或 某一个 section）
    ///
    /// - Returns: tableView
    @objc optional func tableViewForCell() -> UITableView
    
    /// 获取cell的当前 VC （可能需要用到vc，例：执行跳转）
    ///
    /// - Returns: 当前 VC
    @objc optional func currentViewControllerForCell() -> UIViewController
}

/// cell 控制 protocol
@objc protocol SZCellControlProtocol {
    
    /// dataSource
    var dataSource: SZCellControlDataSource? {get set}
    
    /// 响应多种类型的cell
    ///
    /// - Returns: 响应多个类型cell所对应的数据类型的 classString
    func supportDataTypes() -> [String]
    
//    // MARK: - 可选扩展
//    
//    /// 选择了某个item
//    ///
//    /// - Parameter indexPath: indexPath tableView indexPath
//    @objc optional func didSelectedItemAtIndexPath(indexPath: NSIndexPath)
}

/// cell 事件处理control 分发工厂
class SZCellControlFactory: NSObject {
    
    //    static let sharedInstance = MaterialCellControllerFactory()
    //
    //    // 这样可以防止其他人使用默认的“（）”类初始化器
    //    private override init() {}
    
    // 存储注册cell 的 dic
    private lazy var cellControllsDict = [String : SZCellControlProtocol & SZBaseCellDelegate]()
}

// MARK: - public method
extension SZCellControlFactory {
    
    /// 注册 cellController
    ///
    /// - Parameter cellController: 具备处理cell事件的cotroller
    func registerCellController(cellController: SZCellControlProtocol & SZBaseCellDelegate) {
        
        let keys = cellController.supportDataTypes()
        
        for key in keys {
            
            cellControllsDict[key] = cellController
        }
    }
    
    /*
     提供两种方式获取cellController的实例，对应supportDataTypes的两种key:
     
     一种是model的classString；
     一种是指定的key。
     */
    
    /// 根据数据类型获取对应的 cellController
    ///
    /// - Parameter dataType: 数据类型
    /// - Returns: 对应的 cellController
    func getCellControllerWithDataType(dataType: AnyClass) -> (SZCellControlProtocol & SZBaseCellDelegate)? {
        
        return cellControllsDict[NSStringFromClass(dataType)] ?? nil
    }
    
    /// 根据注册key 获取 cellController
    ///
    /// - Parameter registerKey: 注册key
    /// - Returns: 对应的 cellController
    func getCellControllerWithDataTypeRegisterKey(registerKey: String) -> (SZCellControlProtocol & SZBaseCellDelegate)? {
        
        return cellControllsDict[registerKey] ?? nil
    }
    
    /// 获取所有的 cellController
    ///
    /// - Returns: cellController ary
    func allCellControllers() -> [SZCellControlProtocol & SZBaseCellDelegate] {
        
        return Array(cellControllsDict.values)
    }
    
    /// 清除所有的数据
    func clean() {
        
        cellControllsDict.removeAll()
    }
}
