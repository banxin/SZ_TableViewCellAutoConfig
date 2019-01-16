//
//  DifferentDataModelViewModel.swift
//  SZ_TableViewCellAutoConfig
//
//  Created by 山竹 on 2019/1/16.
//  Copyright © 2019 shanzhu. All rights reserved.
//

import UIKit

import HandyJSON

/// 不同数据模型 viewModel 回调
typealias DifferentDataModelViewModelCallback = (() -> Void)

/// 不同数据模型 VM
class DifferentDataModelViewModel: NSObject {
    
    /// 展示数据列表
    var showArray: [Any]?
    
    /// model 转换 工厂
    private var cellModelExtensionFactory: SZCellModelExtentionFactory = SZCellModelExtentionFactory()
    
    override init() {
        
        super.init()
        
        initModelExtensionFactory()
    }
}

// MARK: - public method
extension DifferentDataModelViewModel {
    
    /// 获取不同数据模型 列表
    ///
    /// - Parameters:
    ///   - success: 成功回调
    ///   - fail:    失败回调
    func fetchDifferentDataModelList(success: @escaping DifferentDataModelViewModelCallback, fail: @escaping DifferentDataModelViewModelCallback) {
        
        if let dic = TableViewCellAutoConfigUtil.fetchLoacalMockData(fileName: "DifferentDataModel"),
            let dataDics = dic["data"] as? [[String: Any]],
            dataDics.count > 0 {
            
            let array: [Any] = self.convert(originAry: dataDics)
            
            if array.count > 0 {
                
                showArray = array
                
                success()
            }
            
            fail()
        }
        
        fail()
    }
}

// MARK: - private method
extension DifferentDataModelViewModel {
    
    /// 初始化 model 转换工厂
    private func initModelExtensionFactory() {
        
        cellModelExtensionFactory.registerModelExtention(model: DifferentDataModelOneModel()   as SZCellModelExtentionProtocol)
        cellModelExtensionFactory.registerModelExtention(model: DifferentDataModelTwoModel()   as SZCellModelExtentionProtocol)
        cellModelExtensionFactory.registerModelExtention(model: DifferentDataModelThreeModel() as SZCellModelExtentionProtocol)
        cellModelExtensionFactory.registerModelExtention(model: DifferentDataModelFourModel()  as SZCellModelExtentionProtocol)
    }
    
    /// 转换
    ///
    /// - Parameter originAry: 原始的dic ary
    private func convert(originAry: [[String: Any]]) -> [Any] {
        
        var showAry = [Any]()
        
        /*
         data 中存在 不同的数据类型，故而手动转换，
         同时也存在一个过滤的操作，如果不是指定的 type ，则忽略
         */
        for itemDic in originAry {
            
            guard let itemType = itemDic["type"] as? String,
                let cls = cellModelExtensionFactory.getModelWithDataType(itemType: itemType) as? HandyJSON,
                let model = type(of: cls).deserialize(from: itemDic) else {
                    
                    continue
            }
            
            showAry.append(model)
        }
        
        return showAry
    }
}
