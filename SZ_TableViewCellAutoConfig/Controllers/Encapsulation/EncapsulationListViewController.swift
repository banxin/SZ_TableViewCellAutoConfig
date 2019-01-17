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
    
    func cellBuildersForAutoConfig() -> [SZCellBuilderProtocol]? {
        
        let oneBuilder   = DifferentDataModelTypeOneCellBuilder()
        let twoBuilder   = DifferentDataModelTypeTwoCellBuilder()
        let threeBuilder = DifferentDataModelTypeThreeCellBuilder()
        let fourBuilder  = DifferentDataModelTypeFourCellBuilder()
        
        oneBuilder.dataSource   = self
        twoBuilder.dataSource   = self
        threeBuilder.dataSource = self
        fourBuilder.dataSource  = self
        
        return [oneBuilder,
                twoBuilder,
                threeBuilder,
                fourBuilder]
    }
    
    func cellControlsForAutoConfig() -> [SZBaseCellDelegate & SZCellControlProtocol]? {
        
        let oneControl   = SZDifferentDataModelTypeOneActionControl()
        let twoControl   = SZDifferentDataModelTypeTwoActionControl()
        let threeControl = SZDifferentDataModelTypeThreeActionControl()
        let fourControl  = SZDifferentDataModelTypeFourActionControl()
        
        oneControl.dataSource   = self
        twoControl.dataSource   = self
        threeControl.dataSource = self
        fourControl.dataSource  = self
        
        return [oneControl,
                twoControl,
                threeControl,
                fourControl]
    }
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
