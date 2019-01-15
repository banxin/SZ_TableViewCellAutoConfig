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
    
//    /// cell的创建工厂类
//    private lazy var cellBuildFactory: SZCellBuilderFactory = SZCellBuilderFactory()
//    /// cell的事件控制工厂类
//    private lazy var cellControlFactory: SZCellControlFactory = SZCellControlFactory()
//
//    override init() {
//
//        super.init()
//
//        initCellBuilderFactory()
//        initCellControlFactory()
//    }
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

//// MARK: - private method
//extension SameDataModelViewModel: SZCellBuilderDataSource {
//    
//    func tableViewForCell() -> UITableView {
//        
//        return
//    }
//}
//
//// MARK: - private method
//extension SameDataModelViewModel {
//    
//    /// 初始化 cell builder 工厂
//    private func initCellBuilderFactory() {
//        
//        let oneCell = SameDataModelTypeOneCellBuilder()
//        let twoCell = SameDataModelTypeTwoCellBuilder()
//        
//        oneCell.dataSource = self
//        twoCell.dataSource = self
//        
//        cellBuildFactory.registerCellBuilder(cellBuilder: SameDataModelTypeOneCellBuilder())
//        cellBuildFactory.registerCellBuilder(cellBuilder: SameDataModelTypeTwoCellBuilder())
//        
//        for var builder in cellBuildFactory.allCellBuilderList() {
//            
//            if let tableView = builder.dataSource?.tableViewForCell?() {
//                
//                tableView.register(builder.cellClass(), forCellReuseIdentifier: builder.cellReuseId())
//            }
//        }
//    }
//    
//    /// 初始化 cell control 工厂
//    private func initCellControlFactory() {
//        
////        cellControllerFactory.registerMaterialCellController(cellController: MaterialNormalActionController())
////        cellControllerFactory.registerMaterialCellController(cellController: MaterialPosterActionController())
////        cellControllerFactory.registerMaterialCellController(cellController: MaterialVideoActionController())
////        cellControllerFactory.registerMaterialCellController(cellController: MaterialAdvertActionController())
////
////        for ctrl in cellControllerFactory.allCellControllers() {
////
////            ctrl.viewModel      = viewModel
////            ctrl.viewController = self
////            ctrl.tableView      = tableView
////        }
//    }
//}
