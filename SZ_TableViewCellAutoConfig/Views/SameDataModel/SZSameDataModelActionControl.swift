//
//  SZSameDataModelActionControl.swift
//  SZ_TableViewCellAutoConfig
//
//  Created by 山竹 on 2019/1/15.
//  Copyright © 2019 shanzhu. All rights reserved.
//

import UIKit

/// 相同数据模型 事件处理基类
class SZSameDataModelBaseActionControl: NSObject, SZSameDataModelCellControlProtocol, SZSameDataModelCellDelegate {
    
    // MARK: - SZCellControlProtocol
    
    var dataSource: SZCellControlDataSource?
    
    func supportDataTypes() -> [String] {
        
        return [SameDataModelType.one.rawValue, SameDataModelType.two.rawValue]
    }
    
    func doSomethingElse() {
        
        print("做点其他的控制")
    }
    
    // MARK: - SZSameDataModelCellDelegate
    
    func didSelectedItemAtIndexPath(indexPath: IndexPath) {
        
        print("点击了 cell")
    }
    
    func tapedNameOnCell(cell: UITableViewCell) {
        
        print("点击了 name")
    }
}

/// 相同数据模型类型一 事件处理
class SZSameDataModelTypeOneActionControl: SZSameDataModelBaseActionControl {
    
    override func supportDataTypes() -> [String] {
        
        return [SameDataModelType.one.rawValue]
    }
}

/// 相同数据模型类型二 事件处理
class SZSameDataModelTypeTwoActionControl: SZSameDataModelBaseActionControl {
    
    override func supportDataTypes() -> [String] {
        
        return [SameDataModelType.two.rawValue]
    }
}
