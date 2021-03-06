//
//  SZDifferentDataModelActionControl.swift
//  SZ_TableViewCellAutoConfig
//
//  Created by 山竹 on 2019/1/16.
//  Copyright © 2019 shanzhu. All rights reserved.
//

import UIKit

/// 不同数据模型 事件处理基类
class SZDifferentDataModelBaseActionControl: NSObject, SZCellControlProtocol, SZDifferentDataModelCellDelegate {
    
    // MARK: - SZCellControlProtocol
    
    var dataSource: SZCellControlDataSource?
    
    func supportDataTypes() -> [String] {
        
        return [NSStringFromClass(DifferentDataModelOneModel.self),
                NSStringFromClass(DifferentDataModelTwoModel.self),
                NSStringFromClass(DifferentDataModelThreeModel.self),
                NSStringFromClass(DifferentDataModelFourModel.self)]
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

/// 不同数据模型类型一 事件处理
class SZDifferentDataModelTypeOneActionControl: SZDifferentDataModelBaseActionControl {
    
    override func supportDataTypes() -> [String] {
        
        return [NSStringFromClass(DifferentDataModelOneModel.self)]
    }
    
    // MARK: - SZDifferentDataModelCellDelegate
    
    func tapedWeatherIconOnCell(cell: UITableViewCell) {
        
        print("点击了 天气图片")
    }
}

// MARK: - --------------------- 分割线 ---------------------

/// 不同数据模型类型二 事件处理
class SZDifferentDataModelTypeTwoActionControl: SZDifferentDataModelBaseActionControl {
    
    override func supportDataTypes() -> [String] {
        
        return [NSStringFromClass(DifferentDataModelTwoModel.self)]
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

/// 不同数据模型类型三 事件处理
class SZDifferentDataModelTypeThreeActionControl: SZDifferentDataModelBaseActionControl {
    
    override func supportDataTypes() -> [String] {
        
        return [NSStringFromClass(DifferentDataModelThreeModel.self)]
    }
    
    // MARK: - SZDifferentDataModelCellDelegate
    
    func tapedNameOnCell(cell: UITableViewCell) {
        
        print("点击了 名字")
    }
}

// MARK: - --------------------- 分割线 ---------------------

/// 不同数据模型类型四 事件处理
class SZDifferentDataModelTypeFourActionControl: SZDifferentDataModelBaseActionControl {
    
    override func supportDataTypes() -> [String] {
        
        return [NSStringFromClass(DifferentDataModelFourModel.self)]
    }
    
    // MARK: - SZDifferentDataModelCellDelegate
    
    // 该类型，不需要cell点击事件，重写父类方法
    override func didSelectedItemAtIndexPath(indexPath: IndexPath) { return }
    
    func tapedImageItemOnCell(cell: UITableViewCell) {
        
        print("点击了 图片item")
    }
}
