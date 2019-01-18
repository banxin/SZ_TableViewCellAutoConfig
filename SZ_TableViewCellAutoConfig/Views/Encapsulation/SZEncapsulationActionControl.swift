//
//  SZEncapsulationActionControl.swift
//  SZ_TableViewCellAutoConfig
//
//  Created by 山竹 on 2019/1/17.
//  Copyright © 2019 shanzhu. All rights reserved.
//

import UIKit

/// 封装 事件处理基类
class SZEncapsulationBaseActionControl: NSObject, SZCellControlProtocol, SZDifferentDataModelCellDelegate {
    
    // MARK: - SZCellControlProtocol
    
    var dataSource: SZCellControlDataSource?
    
    func supportDataTypes() -> [String] {
        
        return [DifferentDataModelType.one.rawValue,
                DifferentDataModelType.two.rawValue,
                DifferentDataModelType.three.rawValue,
                DifferentDataModelType.four.rawValue]
    }
    
    func doSomethingElse() {
        
        print("做点其他的控制")
    }
    
    /*
     需要给子类重写，所以不放在 extension
     */
    
    // MARK: - SZDifferentDataModelCellDelegate
    
    func didSelectedItemAtIndexPath(indexPath: IndexPath) {
        
        print("点击了 cell")
    }
}

// MARK: - --------------------- 分割线 ---------------------

/// 封装类型一 事件处理
class SZEncapsulationTypeOneActionControl: SZEncapsulationBaseActionControl {
    
    override func supportDataTypes() -> [String] {
        
        return [DifferentDataModelType.one.rawValue]
    }
    
    // MARK: - SZDifferentDataModelCellDelegate
    
    func tapedWeatherIconOnCell(cell: UITableViewCell) {
        
        print("点击了 天气图片")
    }
}

// MARK: - --------------------- 分割线 ---------------------

/// 封装类型二 事件处理
class SZEncapsulationTypeTwoActionControl: SZEncapsulationBaseActionControl {
    
    override func supportDataTypes() -> [String] {
        
        return [DifferentDataModelType.two.rawValue]
    }
    
    // MARK: - SZDifferentDataModelCellDelegate
    
    func tapedShopOnCell(cell: UITableViewCell) {
        
        print("点击了 门店")
    }
    
    func tapedMaterialOnCell(cell: UITableViewCell) {
        
        print("点击了 素材")
    }
    
    func tapedKnowledgeOnCell(cell: UITableViewCell) {
        
        print("点击了 知识")
    }
}

// MARK: - --------------------- 分割线 ---------------------

/// 封装类型三 事件处理
class SZEncapsulationTypeThreeActionControl: SZEncapsulationBaseActionControl {
    
    override func supportDataTypes() -> [String] {
        
        return [DifferentDataModelType.three.rawValue]
    }
    
    // MARK: - SZDifferentDataModelCellDelegate
    
    func tapedNameOnCell(cell: UITableViewCell) {
        
        print("点击了 名字")
    }
}

// MARK: - --------------------- 分割线 ---------------------

/// 封装类型四 事件处理
class SZEncapsulationTypeFourActionControl: SZEncapsulationBaseActionControl {
    
    override func supportDataTypes() -> [String] {
        
        return [DifferentDataModelType.four.rawValue]
    }
    
    // MARK: - SZDifferentDataModelCellDelegate
    
    // 该类型，不需要cell点击事件，重写父类方法
    override func didSelectedItemAtIndexPath(indexPath: IndexPath) { return }
    
    func tapedImageItemOnCell(cell: UITableViewCell) {
        
        print("点击了 图片item")
    }
}
