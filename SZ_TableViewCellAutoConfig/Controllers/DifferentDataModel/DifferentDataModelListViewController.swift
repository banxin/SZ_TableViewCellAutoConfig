//
//  DifferentDataModelListViewController.swift
//  SZ_TableViewCellAutoConfig
//
//  Created by 山竹 on 2019/1/11.
//  Copyright © 2019 shanzhu. All rights reserved.
//

import UIKit

import Then
import SnapKit

/// 不同数据类型的 列表
class DifferentDataModelListViewController: UIViewController {
    
    /// VM
    private var viewModel: DifferentDataModelViewModel = DifferentDataModelViewModel()
    
    /// 表格 view
    private var tableView: UITableView = UITableView.init(frame: CGRect.zero, style: .grouped).then {
        
        $0.backgroundColor = UIColor.colorWithHex(hexString: "f5f5f5")
        $0.separatorStyle  = .none
        // 不设置这个就有个默认高度。。。
        $0.tableHeaderView = UIView().then({
            
            $0.frame = CGRect(x: 0, y: 0, width: UIScreen.main.sz_screenWidth, height: 0.01)
        })
        $0.tableFooterView = UIView()
        
        // 解决 reload 闪烁
        $0.estimatedRowHeight           = 0
        $0.estimatedSectionHeaderHeight = 0
        $0.estimatedSectionFooterHeight = 0
    }
    
    /// cell的创建工厂类
    private lazy var cellBuildFactory: SZCellBuilderFactory = SZCellBuilderFactory()
    /// cell的事件控制工厂类
    private lazy var cellControlFactory: SZCellControlFactory = SZCellControlFactory()

    override func viewDidLoad() {
        
        super.viewDidLoad()

        setupUI()
        loadData()
        initCellBuilderFactory()
        initCellControlFactory()
    }
}

// MARK: - UI
extension DifferentDataModelListViewController {
    
    /// 设置UI
    private func setupUI() {
        
        title = "不同数据类型未封装实现"
        view.backgroundColor = UIColor.colorWithHex(hexString: "f1f2f3")
        
        tableView.dataSource = self
        tableView.delegate   = self
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (maker) in
            
            maker.edges.equalToSuperview()
        }
    }
}

// MARK: - Data
extension DifferentDataModelListViewController {
    
    /// 获取数据
    private func loadData() {
        
        viewModel.fetchDifferentDataModelList(success: { [weak self] in
            
            guard let `self` = self else { return }
            
            self.tableView.reloadData()
            
            }, fail: {
                
        })
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension DifferentDataModelListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return viewModel.showArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 保护代码，防止切换过快，导致的数组越界
        if viewModel.showArray?.count ?? 0 > 0 && indexPath.section < viewModel.showArray?.count ?? 0 {
            
            // 根据数据类型，获取对应的cell
            if let data = viewModel.showArray?[indexPath.section],
                let type = type(of: data) as? AnyClass,
                let cellBuilder = cellBuildFactory.getCellBuilderWithDataType(dataType: type),
                var cell = tableView.dequeueReusableCell(withIdentifier: cellBuilder.cellReuseId()) as? SZBaseCellProtocol,
                let cellControlDelegate = cellControlFactory.getCellControlWithDataType(dataType: type) {
                
                cell.delegate = cellControlDelegate
                
                cell.configWithData(data: data)
                
//                // 测试代码
//                cell.doSomethingConfigElse()
                
                return cell as? UITableViewCell ?? UITableViewCell()
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // 保护代码，防止切换过快，导致的数组越界
        if viewModel.showArray?.count ?? 0 > 0 && indexPath.section < viewModel.showArray?.count ?? 0 {
            
            // 根据数据类型，获取对应的cell
            if let item = viewModel.showArray?[indexPath.section],
                let type = type(of: item) as? AnyClass,
                let cellBuilder = cellBuildFactory.getCellBuilderWithDataType(dataType: type) {
                
                return cellBuilder.cellHeightWithModel(model: item)
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 12
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return UIView().then {
            
            $0.frame = CGRect(x: 0, y: 0, width: UIScreen.main.sz_screenWidth, height: 12)
            $0.backgroundColor = UIColor.colorWithHex(hexString: "f5f5f5")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 保护代码，防止切换过快，导致的数组越界
        if viewModel.showArray?.count ?? 0 > 0 && indexPath.section < viewModel.showArray?.count ?? 0 {
            
            // 根据数据类型，获取对应的cell
            if let data = viewModel.showArray?[indexPath.section],
                let type = type(of: data) as? AnyClass,
                let cellControlDelegate = cellControlFactory.getCellControlWithDataType(dataType: type) {
                
                cellControlDelegate.didSelectedItemAtIndexPath?(indexPath: indexPath)
            }
        }
    }
}

// MARK: - SZCellBuilderDataSource
extension DifferentDataModelListViewController: SZCellBuilderDataSource {
    
    func tableViewForCellBuilder() -> UITableView {
        
        return tableView
    }
}

// MARK: - SZCellControlDataSource
extension DifferentDataModelListViewController: SZCellControlDataSource {
    
    func dataModelForCell(indexPath: NSIndexPath) -> Any? {
        
        return viewModel.showArray?[indexPath.section]
    }
    
    func tableViewForCellControl() -> UITableView {
        
        return tableView
    }
    
    func currentViewControllerForCell() -> UIViewController {
        
        return self
    }
}

// MARK: - private method
extension DifferentDataModelListViewController {
    
    /// 初始化 cell builder 工厂
    private func initCellBuilderFactory() {
        
        let oneBuilder   = DifferentDataModelTypeOneCellBuilder()
        let twoBuilder   = DifferentDataModelTypeTwoCellBuilder()
        let threeBuilder = DifferentDataModelTypeThreeCellBuilder()
        let fourBuilder  = DifferentDataModelTypeFourCellBuilder()
        
        oneBuilder.dataSource   = self
        twoBuilder.dataSource   = self
        threeBuilder.dataSource = self
        fourBuilder.dataSource  = self
        
        cellBuildFactory.registerCellBuilder(cellBuilder: oneBuilder)
        cellBuildFactory.registerCellBuilder(cellBuilder: twoBuilder)
        cellBuildFactory.registerCellBuilder(cellBuilder: threeBuilder)
        cellBuildFactory.registerCellBuilder(cellBuilder: fourBuilder)
    }
    
    /// 初始化 cell control 工厂
    private func initCellControlFactory() {
        
        let oneControl   = SZDifferentDataModelTypeOneActionControl()
        let twoControl   = SZDifferentDataModelTypeTwoActionControl()
        let threeControl = SZDifferentDataModelTypeThreeActionControl()
        let fourControl  = SZDifferentDataModelTypeFourActionControl()
        
        oneControl.dataSource   = self
        twoControl.dataSource   = self
        threeControl.dataSource = self
        fourControl.dataSource  = self
        
        cellControlFactory.registerCellControl(cellController: oneControl)
        cellControlFactory.registerCellControl(cellController: twoControl)
        cellControlFactory.registerCellControl(cellController: threeControl)
        cellControlFactory.registerCellControl(cellController: fourControl)
    }
}
