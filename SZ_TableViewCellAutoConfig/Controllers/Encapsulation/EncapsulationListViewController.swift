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
        
        title = "不同数据类型封装后的列表"
        view.backgroundColor = UIColor.colorWithHex(hexString: "f1f2f3")
        
        autoConfigView.dataSource = self
        autoConfigView.delegate   = self
        
        /*
         支持的属性自定义测试
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
            
            self.autoConfigView.refreshView(with: self.viewModel.showArray ?? [])
            
            print("数据获取成功。。")
            
            }, fail: {
                
        })
    }
}

// MARK: - SZAutoCofigCellTableViewDataSource
extension EncapsulationListViewController: SZAutoCofigCellTableViewDataSource {
    
    func cellBuildersForAutoConfig() -> [Any] {
        
        let oneBuilder   = SZEncapsulationTypeOneCellBuilder()
        let twoBuilder   = SZEncapsulationTypeTwoCellBuilder()
        let threeBuilder = SZEncapsulationTypeThreeCellBuilder()
        let fourBuilder  = SZEncapsulationTypeFourCellBuilder()
        
        oneBuilder.dataSource   = self
        twoBuilder.dataSource   = self
        threeBuilder.dataSource = self
        fourBuilder.dataSource  = self
        
        return [oneBuilder,
                twoBuilder,
                threeBuilder,
                fourBuilder]
    }
    
    func cellControlsForAutoConfig() -> [Any] {
        
        let oneControl   = SZEncapsulationTypeOneActionControl()
        let twoControl   = SZEncapsulationTypeTwoActionControl()
        let threeControl = SZEncapsulationTypeThreeActionControl()
        let fourControl  = SZEncapsulationTypeFourActionControl()
        
        oneControl.dataSource   = self
        twoControl.dataSource   = self
        threeControl.dataSource = self
        fourControl.dataSource  = self
        
        return [oneControl,
                twoControl,
                threeControl,
                fourControl]
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
}

// MARK: - SZAutoCofigCellTableViewDelegate
extension EncapsulationListViewController: SZAutoCofigCellTableViewDelegate {
    
    func sz_autoCofigScrollViewDidScroll() {
        
        print("tableView 滚动了")
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
