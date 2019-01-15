//
//  SZSameDataModelCellBulider.swift
//  SZ_TableViewCellAutoConfig
//
//  Created by 山竹 on 2019/1/11.
//  Copyright © 2019 shanzhu. All rights reserved.
//

import UIKit

import HandyJSON

/// 工具类
class SameDataModelTypeUtil {
    
    /// 获取cell高度
    ///
    /// - Parameters:
    ///   - model:     数据模型
    ///   - tableView: tableView
    ///   - cell:      高度
    /// - Returns: button
    static func cellHeightWithModel(model: Any, tableView: UITableView, cell: AnyClass) -> CGFloat {
        
        guard let cell = cell as? UITableViewCell.Type, let model = model as? SameDataModel else { return 0 }
        
        var idIdentify: String? = nil
        
        if let jsonStr = model.toJSONString() {
            
            // key 使用model的jsonStr最靠谱，如果使用 hashCode 的话，则需要model继承自NSObject，感觉没必要，JSONString占不了多少内存
            idIdentify = jsonStr
        }
        
        idIdentify = "\(model.id ?? 0)"
        
        return cell.sz_cellHeight(forTableView: tableView, config: { (targetCell) in
            
            let pro = targetCell as? SZSameDataModelCellProtocol
            
            if ((pro?.configWithData(data: model)) != nil) {
                
                pro?.configWithData(data: model)
            }
            
        }, updateCacheIfNeeded: { () -> (key: String, stateKey: String?, shouldUpdate: Bool?) in
            
            if let id = idIdentify {
                
                return (id, nil, false)
            }
            
            return ("\(object_getClassName(model))", nil, true)
        })
    }
}

/// 第一种类型 cell builder
class SameDataModelTypeOneCellBuilder: SZCellBuilderProtocol {
    
    var dataSource: SZCellBuilderDataSource?
    
    func supportDataType() -> String {
        
        return SameDataModelType.one.rawValue
    }
    
    func cellHeightWithModel(model: Any) -> CGFloat {
        
        if let tableView = dataSource?.tableViewForCellBuilder?() {
            
            return SameDataModelTypeUtil.cellHeightWithModel(model: model, tableView: tableView, cell: self.cellClass())
        }
        
        return 0
    }
    
    func cellReuseId() -> String {
        
        return "SameDataModelTypeOneCellReuseId"
    }
    
    func cellClass() -> AnyClass {
        
        return SameDataModelTypeOneCell.self
    }
}

/// 第二种类型 cell builder
class SameDataModelTypeTwoCellBuilder: SZCellBuilderProtocol {
    
    var dataSource: SZCellBuilderDataSource?
    
    func supportDataType() -> String {
        
        return SameDataModelType.two.rawValue
    }
    
    func cellHeightWithModel(model: Any) -> CGFloat {
        
        if let tableView = dataSource?.tableViewForCellBuilder?() {
            
            return SameDataModelTypeUtil.cellHeightWithModel(model: model, tableView: tableView, cell: self.cellClass())
        }
        
        return 0
    }
    
    func cellReuseId() -> String {
        
        return "SameDataModelTypeTwoCellReuseId"
    }
    
    func cellClass() -> AnyClass {
        
        return SameDataModelTypeTwoCell.self
    }
}
