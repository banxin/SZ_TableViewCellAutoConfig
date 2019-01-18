//
//  SZEncapsulationCellBuilder.swift
//  SZ_TableViewCellAutoConfig
//
//  Created by 山竹 on 2019/1/17.
//  Copyright © 2019 shanzhu. All rights reserved.
//

import Foundation

import HandyJSON

// MARK: --------------------------- 分割线 -----------------------------------

/// 第一种类型 cell builder
class SZEncapsulationTypeOneCellBuilder: SZCellBuilderProtocol {
    
    var dataSource: SZCellBuilderDataSource?
    
    func supportDataType() -> String {
        
        return DifferentDataModelType.one.rawValue
    }
    
    func cellHeightWithModel(model: Any) -> CGFloat {
        
        return 104
    }
    
    func cellReuseId() -> String {
        
        return "SZEncapsulationTypeOneCellReuseId"
    }
    
    func cellClass() -> AnyClass {
        
        return DifferentDataModelOneCell.self
    }
}

/// 第二种类型 cell builder
class SZEncapsulationTypeTwoCellBuilder: SZCellBuilderProtocol {
    
    var dataSource: SZCellBuilderDataSource?
    
    func supportDataType() -> String {
        
        return DifferentDataModelType.two.rawValue
    }
    
    func cellHeightWithModel(model: Any) -> CGFloat {
        
        if let cell = self.cellClass() as? UITableViewCell.Type,
            let model = model as? DifferentDataModelTwoModel,
            let tableView = dataSource?.tableViewForCellBuilder?() {
            
            return cell.sz_cellHeight(forTableView: tableView, config: { (targetCell) in
                
                if let pro = targetCell as? SZBaseCellProtocol {
                    
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
        
        return "SZEncapsulationTypeTwoCellReuseId"
    }
    
    func cellClass() -> AnyClass {
        
        return DifferentDataModelTwoCell.self
    }
}

/// 第三种类型 cell builder
class SZEncapsulationTypeThreeCellBuilder: SZCellBuilderProtocol {
    
    var dataSource: SZCellBuilderDataSource?
    
    func supportDataType() -> String {
        
        return DifferentDataModelType.three.rawValue
    }
    
    func cellHeightWithModel(model: Any) -> CGFloat {
        
        if let cell = self.cellClass() as? UITableViewCell.Type,
            let model = model as? DifferentDataModelThreeModel,
            let tableView = dataSource?.tableViewForCellBuilder?() {
            
            return cell.sz_cellHeight(forTableView: tableView, config: { (targetCell) in
                
                if let pro = targetCell as? SZBaseCellProtocol {
                    
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
        
        return "SZEncapsulationTypeThreeCellReuseId"
    }
    
    func cellClass() -> AnyClass {
        
        return DifferentDataModelThreeCell.self
    }
}

/// 第四种类型 cell builder
class SZEncapsulationTypeFourCellBuilder: SZCellBuilderProtocol {
    
    var dataSource: SZCellBuilderDataSource?
    
    func supportDataType() -> String {
        
        return DifferentDataModelType.four.rawValue
    }
    
    func cellHeightWithModel(model: Any) -> CGFloat {
        
        return UIScreen.sz_layoutUI(originalNum: 80)
    }
    
    func cellReuseId() -> String {
        
        return "SZEncapsulationTypeFourCellReuseId"
    }
    
    func cellClass() -> AnyClass {
        
        return DifferentDataModelFourCell.self
    }
}
