//
//  SZSameDataModelCellBulider.swift
//  SZ_TableViewCellAutoConfig
//
//  Created by 山竹 on 2019/1/11.
//  Copyright © 2019 shanzhu. All rights reserved.
//

import UIKit

/// 第一种类型 cell builder
class SameDataModelTypeOneCellBuilder: SZCellBuilderProtocol {
    
    var dataSource: SZCellBuilderDataSource?
    
    func supportDataType() -> String {
        
        return "TypeOne"
    }
    
    func cellHeightWithModel(model: Any) -> CGFloat {
        
        if let tableView = dataSource?.tableViewForCell?() {
            
            print("\(tableView)")
        }
        
        return 0
        
//        return MaterialUtils.materialCellHeightWithModel(model: model, tableView: tableView!, cell: self.cellClass())
    }
    
    func cellReuseId() -> String {
        
        return "SameDataModelTypeOneCellReuseId"
    }
    
    func cellClass() -> AnyClass {
        
        return UITableViewCell.self
    }
}
