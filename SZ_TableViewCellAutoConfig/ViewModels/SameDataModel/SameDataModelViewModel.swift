//
//  SameDataModelViewModel.swift
//  SZ_TableViewCellAutoConfig
//
//  Created by 山竹 on 2019/1/14.
//  Copyright © 2019 shanzhu. All rights reserved.
//

import UIKit

import HandyJSON

/// 相同数据模型 viewModel 回调
typealias SameDataModelViewModelCallback = (() -> Void)

/// 相同数据模型 VM
class SameDataModelViewModel: NSObject {

    /// 展示数据列表
    var showArray: [SameDataModel]?
}

// MARK: - public method
extension SameDataModelViewModel {
    
    /// 获取相同数据模型 列表
    ///
    /// - Parameters:
    ///   - success: 成功回调
    ///   - fail:    失败回调
    func fetchSameDataModelList(success: @escaping SameDataModelViewModelCallback, fail: @escaping SameDataModelViewModelCallback) {
        
        if let dic = TableViewCellAutoConfigUtil.fetchLoacalMockData(fileName: "SameDataModel"),
            let dataDics = dic["data"] as? [[String: Any]],
            dataDics.count > 0 {
            
            var array: [SameDataModel] = []
            
            for dicItem in dataDics {
                
                if let item = SameDataModel.deserialize(from: dicItem) {
                    
                    array.append(item)
                }
            }
            
            if array.count > 0 {
                
                showArray = array
                
                success()
            }
            
            fail()
        }
        
        fail()
    }
}
