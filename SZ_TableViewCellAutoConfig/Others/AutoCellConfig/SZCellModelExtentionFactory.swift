//
//  SZCellModelExtentionFactory.swift
//  SZ_TableViewCellAutoConfig
//
//  Created by 山竹 on 2019/1/15.
//  Copyright © 2019 shanzhu. All rights reserved.
//

import UIKit

/*
 Array 返回的数据模型不一样的时候，使用该类
 */

/// 模型转换 protocol
protocol SZCellModelExtentionProtocol {
    
    /// 需要转换的model 的 key
    ///
    /// - Returns: key
    func modelExtentionItemType() -> String
}

/// 模型转换分发工厂
class SZCellModelExtentionFactory: NSObject {
    
    // 存储cell model 的 dic
    private lazy var extentionDict = [String : SZCellModelExtentionProtocol]()
}

// MARK: - public method
extension SZCellModelExtentionFactory {
    
    /// 注册 model
    ///
    /// - Parameter model: model
    func registerModelExtention(model: SZCellModelExtentionProtocol) {
        
        extentionDict[model.modelExtentionItemType()] = model
    }
    
    /// 根据 itemType 获取相应的model类型
    ///
    /// - Parameter itemType: model 的 itemType
    /// - Returns: 相应的model类型
    func getModelWithDataType(itemType: String) -> SZCellModelExtentionProtocol? {
        
        return extentionDict[itemType]
    }
}
