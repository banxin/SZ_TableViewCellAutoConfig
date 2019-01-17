//
//  SZDifferentDataModelCellBulider.swift
//  SZ_TableViewCellAutoConfig
//
//  Created by 山竹 on 2019/1/16.
//  Copyright © 2019 shanzhu. All rights reserved.
//

import UIKit

import HandyJSON

/// 工具类
class DifferentDataModelTypeUtil {
    
    /// 获取cell高度
    ///
    /// - Parameters:
    ///   - model:     数据模型
    ///   - tableView: tableView
    ///   - cell:      目标cell
    /// - Returns: 高度
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

// MARK: --------------------------- 分割线 -----------------------------------

/// 第一种类型 cell builder
class DifferentDataModelTypeOneCellBuilder: SZCellBuilderProtocol {
    
    var dataSource: SZCellBuilderDataSource?
    
    func supportDataType() -> String {
        
        return NSStringFromClass(DifferentDataModelOneModel.self)
    }
    
    func cellHeightWithModel(model: Any) -> CGFloat {
        
        return 104
    }
    
    func cellReuseId() -> String {
        
        return "DifferentDataModelTypeOneCellReuseId"
    }
    
    func cellClass() -> AnyClass {
        
        return DifferentDataModelOneCell.self
    }
}

/// 第二种类型 cell builder
class DifferentDataModelTypeTwoCellBuilder: SZCellBuilderProtocol {
    
    var dataSource: SZCellBuilderDataSource?
    
    func supportDataType() -> String {
        
        return NSStringFromClass(DifferentDataModelTwoModel.self)
    }
    
    func cellHeightWithModel(model: Any) -> CGFloat {
        
        if let cell = self.cellClass() as? UITableViewCell.Type,
            let model = model as? DifferentDataModelTwoModel,
            let tableView = dataSource?.tableViewForCellBuilder?() {
            
            return cell.sz_cellHeight(forTableView: tableView, config: { (targetCell) in
                
                if let pro = targetCell as? SZDifferentDataModelCellProtocol {
                    
                    pro.configWithData(data: model)
                }
                
            }, updateCacheIfNeeded: { () -> (key: String, stateKey: String?, shouldUpdate: Bool?) in
                
                // 优先使用 item 的 JSONString
                if let jsonStr = model.toJSONString() {
                    
                    return (jsonStr, nil, false)
                }
                
                // 如果转换不正确，使用 item ID
                if let id = model.id {
                    
                    return ("\(id)", nil, false)
                }
                
                // 默认
                return ("\(object_getClassName(model))", nil, true)
            })
        }
        
        return 0
    }
    
    func cellReuseId() -> String {
        
        return "DifferentDataModelTypeTwoCellReuseId"
    }
    
    func cellClass() -> AnyClass {
        
        return DifferentDataModelTwoCell.self
    }
}

/// 第三种类型 cell builder
class DifferentDataModelTypeThreeCellBuilder: SZCellBuilderProtocol {
    
    var dataSource: SZCellBuilderDataSource?
    
    func supportDataType() -> String {
        
        return NSStringFromClass(DifferentDataModelThreeModel.self)
    }
    
    func cellHeightWithModel(model: Any) -> CGFloat {
        
        if let cell = self.cellClass() as? UITableViewCell.Type,
            let model = model as? DifferentDataModelThreeModel,
            let tableView = dataSource?.tableViewForCellBuilder?() {
            
            return cell.sz_cellHeight(forTableView: tableView, config: { (targetCell) in
                
                if let pro = targetCell as? SZDifferentDataModelCellProtocol {
                    
                    pro.configWithData(data: model)
                }
                
            }, updateCacheIfNeeded: { () -> (key: String, stateKey: String?, shouldUpdate: Bool?) in
                
                // 优先使用 item 的 JSONString
                if let jsonStr = model.toJSONString() {
                    
                    return (jsonStr, nil, false)
                }
                
                // 如果转换不正确，使用 item ID
                if let id = model.id {
                    
                    return ("\(id)", nil, false)
                }
                
                // 默认
                return ("\(object_getClassName(model))", nil, true)
            })
        }
        
        return 0
    }
    
    func cellReuseId() -> String {
        
        return "DifferentDataModelTypeThreeCellReuseId"
    }
    
    func cellClass() -> AnyClass {
        
        return DifferentDataModelThreeCell.self
    }
}

/// 第四种类型 cell builder
class DifferentDataModelTypeFourCellBuilder: SZCellBuilderProtocol {
    
    var dataSource: SZCellBuilderDataSource?
    
    func supportDataType() -> String {
        
        return NSStringFromClass(DifferentDataModelFourModel.self)
    }
    
    func cellHeightWithModel(model: Any) -> CGFloat {
        
        return UIScreen.sz_layoutUI(originalNum: 80)
    }
    
    func cellReuseId() -> String {
        
        return "DifferentDataModelTypeFourCellReuseId"
    }
    
    func cellClass() -> AnyClass {
        
        return DifferentDataModelFourCell.self
    }
}
