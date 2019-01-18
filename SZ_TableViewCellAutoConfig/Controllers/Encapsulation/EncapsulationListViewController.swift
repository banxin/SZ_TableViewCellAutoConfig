//
//  EncapsulationListViewController.swift
//  SZ_TableViewCellAutoConfig
//
//  Created by 山竹 on 2019/1/17.
//  Copyright © 2019 shanzhu. All rights reserved.
//

import UIKit

import Then
import SnapKit
import MJRefresh

/// 封装后的列表
class EncapsulationListViewController: UIViewController {

    /// VM
    private var viewModel: DifferentDataModelViewModel = DifferentDataModelViewModel()
    
    /// cell自动配置view
    private var autoConfigView: SZAutoCofigCellTableView = SZAutoCofigCellTableView()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupUI()
        loadData()
    }
}

// MARK: - UI
extension EncapsulationListViewController {
    
    /// 设置UI
    private func setupUI() {
        
        title = "封装后的实现"
        view.backgroundColor = UIColor.colorWithHex(hexString: "f1f2f3")
        
        autoConfigView.dataSource = self
        autoConfigView.delegate   = self
        
        /*
         支持的属性自定义
         */
        
//        autoConfigView.sz_backgroundColor = UIColor.red
//        autoConfigView.isNeedFirstSectionHeader = false
//        autoConfigView.sectionFooterHeight = 10
//        autoConfigView.isNeedLastSectionFooter = false
        
        view.addSubview(autoConfigView)
        
        autoConfigView.snp.makeConstraints { (maker) in
            
            maker.edges.equalToSuperview()
        }
    }
}

// MARK: - Data
extension EncapsulationListViewController {
    
    /// 获取数据
    private func loadData() {
        
        viewModel.fetchDifferentDataModelList(success: { [weak self] in
            
            guard let `self` = self else { return }
            
            self.autoConfigView.refreshView(with: self.viewModel.showArray ?? [],
                                            isFirstPage: self.viewModel.isFirstPage,
                                            isHaveNext: self.viewModel.isHaveNext)
            
            }, fail: {
                
        })
    }
}

// MARK: - SZAutoCofigCellTableViewDataSource
extension EncapsulationListViewController: SZAutoCofigCellTableViewDataSource {
    
    func cellBuildersForAutoConfig() -> [Any] {
        
        /// 需要支持的 cellBuilders
        let supportBuilders: [SZCellBuilderProtocol] = [SZEncapsulationTypeOneCellBuilder(),
                                                        SZEncapsulationTypeTwoCellBuilder(),
                                                        SZEncapsulationTypeThreeCellBuilder(),
                                                        SZEncapsulationTypeFourCellBuilder()]
        
        // 设置 dataSource
        for var builder in supportBuilders {
            
            builder.dataSource = self
        }
        
        return supportBuilders
    }
    
    func cellControlsForAutoConfig() -> [Any] {
        
        /// 需要支持的 cellControls
        let supportControls: [SZCellControlProtocol] = [SZEncapsulationTypeOneActionControl(),
                                                        SZEncapsulationTypeTwoActionControl(),
                                                        SZEncapsulationTypeThreeActionControl(),
                                                        SZEncapsulationTypeFourActionControl()]
        
        // 设置 dataSource
        for control in supportControls {
            
            control.dataSource = self
        }
        
        return supportControls
    }
    
    /*
     可选方法的测试
     */
    
//    func tableFooterViewForAutoConfig() -> UIView {
//
//        return UIView().then {
//
//            $0.frame           = CGRect(x: 0,
//                                        y: 0,
//                                        width: UIScreen.main.sz_screenWidth,
//                                        height: 30)
//            $0.backgroundColor = UIColor.red
//        }
//    }
//
//    func tableHeaderViewForAutoConfig() -> UIView {
//
//        return UIView().then {
//
//            $0.frame           = CGRect(x: 0,
//                                        y: 0,
//                                        width: UIScreen.main.sz_screenWidth,
//                                        height: 30)
//            $0.backgroundColor = UIColor.blue
//        }
//    }
    
    func refreshHeaderForAutoConfig() -> MJRefreshHeader {
        
        return MJRefreshNormalHeader()
        
//        return MJRefreshNormalHeader(refreshingBlock: { [weak self] in
//
//            guard let `self` = self else { return }
//
//            self.loadData()
//        })
    }
    
    func refreshFooterForAutoConfig() -> MJRefreshFooter {
        
        return MJRefreshAutoStateFooter()
        
//        return MJRefreshAutoStateFooter(refreshingBlock: { [weak self] in
//
//            guard let `self` = self else { return }
//
//            self.loadData()
//
////            self.loadDataMore()
//        })
    }
}

// MARK: - SZAutoCofigCellTableViewDelegate
extension EncapsulationListViewController: SZAutoCofigCellTableViewDelegate {
    
    /*
     可选方法的测试
     */
    
//    func sz_autoCofigScrollViewDidScroll() {
//
//        print("tableView 滚动了")
//    }
    
    func sz_reloadData(isRefresh: Bool) {
        
        viewModel.page = isRefresh ? 1 : viewModel.page + 1
        
        self.loadData()
    }
}

// MARK: - SZCellBuilderDataSource
extension EncapsulationListViewController: SZCellBuilderDataSource {
    
    func tableViewForCellBuilder() -> UITableView {
        
        return autoConfigView.outerTableView
    }
}

// MARK: - SZCellControlDataSource
extension EncapsulationListViewController: SZCellControlDataSource {
    
    func dataModelForCell(indexPath: NSIndexPath) -> Any? {
        
        return viewModel.showArray?[indexPath.section]
    }
    
    func tableViewForCellControl() -> UITableView {
        
        return autoConfigView.outerTableView
    }
    
    func currentViewControllerForCell() -> UIViewController {
        
        return self
    }
}
