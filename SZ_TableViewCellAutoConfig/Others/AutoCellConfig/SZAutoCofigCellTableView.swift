//
//  SZAutoCofigCellTableView.swift
//  SZ_TableViewCellAutoConfig
//
//  Created by 山竹 on 2019/1/17.
//  Copyright © 2019 shanzhu. All rights reserved.
//

import UIKit

import Then
import SnapKit

// MARK: ---------------------- SZAutoCellCofigType ----------------------

/// cell 的配置类型
///
/// - sameModel:      相同数据类型（使用指定的key）
/// - differentModel: 不同数据类型（使用数据类型的 classStr）
enum SZAutoCellCofigType: Int {
    
    case sameModel      = 0
    case differentModel = 1
}

// MARK: ---------------------- SZAutoCofigCellTableViewDataSource ----------------------

/// 自动配置 cell view dataSource
protocol SZAutoCofigCellTableViewDataSource {
    
    /// 获取自动配置的 cellBuilders
    ///
    /// - Returns: cellBuilders
    func cellBuildersForAutoConfig() -> [SZCellBuilderProtocol]?
    
    /// 获取自动配置的 cellControls
    ///
    /// - Returns: cellBuilders
    func cellControlsForAutoConfig() -> [SZCellControlProtocol & SZBaseCellDelegate]?
}

// MARK: ---------------------- SZAutoCofigCellTableViewDelegate ----------------------

/// 自动配置 cell view delegate
@objc protocol SZAutoCofigCellTableViewDelegate {
    
    /// 列表滚动
    @objc optional func sz_autoCofigScrollViewDidScroll()
}

// MARK: ---------------------- SZAutoCofigCellTableView ----------------------

/// 自动配置 cell view
class SZAutoCofigCellTableView: UIView {
    
    // MARK: - pulic property
    
    /// dataSource
    var dataSource: SZAutoCofigCellTableViewDataSource?
    /// delegate
    var delegate: SZAutoCofigCellTableViewDelegate?
    /// 配置类型
    var configType: SZAutoCellCofigType = .sameModel
    /// tableView（对外提供的tableview，防止被篡改）
    var outerTableView: UITableView {
        
        return tableView
    }
    
    // MARK: - private property
    
    /// cell的创建工厂类
    private lazy var cellBuildFactory: SZCellBuilderFactory = SZCellBuilderFactory()
    /// cell的事件控制工厂类
    private lazy var cellControlFactory: SZCellControlFactory = SZCellControlFactory()
    
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
    
    /// 展示数据
    private var showArray: [Any] = []
    
    init(frame: CGRect, dataSource: Any) {
        
        super.init(frame: frame)
        
        setupUI()
    }

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI
extension SZAutoCofigCellTableView {
    
    /// 设置UI
    private func setupUI() {
        
        tableView.dataSource = self
        tableView.delegate   = self
        
        addSubview(tableView)
        
        tableView.snp.makeConstraints { (maker) in
            
            maker.edges.equalToSuperview()
        }
    }
}

// MARK: - public method
extension SZAutoCofigCellTableView {
    
    /// 刷新页面
    ///
    /// - Parameter items: 数据s
    func refreshView(with items: [Any]) {
        
        checkFactory()
        
        showArray = items
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension SZAutoCofigCellTableView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return showArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 保护代码，防止切换过快，导致的数组越界
        if showArray.count > 0 && indexPath.section < showArray.count {
            
            let item = showArray[indexPath.section]
            
            // 根据数据类型，获取对应的cell
            if let type = type(of: item) as? AnyClass,
                let cellBuilder = cellBuildFactory.getCellBuilderWithDataType(dataType: type),
                var cell = tableView.dequeueReusableCell(withIdentifier: cellBuilder.cellReuseId()) as? SZBaseCellProtocol,
                let cellControlDelegate = cellControlFactory.getCellControlWithDataType(dataType: type) {
                
                cell.delegate = cellControlDelegate
                
                cell.configWithData(data: item)
                
                // 测试代码
                // TODO: 没有定义在基类的配置，即自定义配置有问题
//                cell.doSomethingConfigElse()
                
                return cell as? UITableViewCell ?? UITableViewCell()
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // 保护代码，防止切换过快，导致的数组越界
        if showArray.count > 0 && indexPath.section < showArray.count {
            
            let item = showArray[indexPath.section]
            
            // 根据数据类型，获取对应的cell
            if let type = type(of: item) as? AnyClass,
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
        if showArray.count > 0 && indexPath.section < showArray.count {
            
            let item = showArray[indexPath.section]
            
            // 根据数据类型，获取对应的cell
            if let type = type(of: item) as? AnyClass,
                let cellControlDelegate = cellControlFactory.getCellControlWithDataType(dataType: type) {
                
                cellControlDelegate.didSelectedItemAtIndexPath?(indexPath: indexPath)
            }
        }
    }
}

// MARK: - UIScrollViewDelegate
extension SZAutoCofigCellTableView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        delegate?.sz_autoCofigScrollViewDidScroll?()
    }
}

// MARK: - private method
extension SZAutoCofigCellTableView {
    
    /// check factory 是否初始化完成
    private func checkFactory() {
        
        if cellBuildFactory.allCellBuilderList().isEmpty {
            
            initCellBuilderFactory()
        }
        
        if cellControlFactory.allCellControls().isEmpty {
            
            initCellControlFactory()
        }
    }
    
    /// 初始化 cell builder 工厂
    private func initCellBuilderFactory() {
        
        if let builders = dataSource?.cellBuildersForAutoConfig() {
            
            for builder in builders {
                
                cellBuildFactory.registerCellBuilder(cellBuilder: builder)
            }
        }
    }
    
    /// 初始化 cell control 工厂
    private func initCellControlFactory() {
        
        if let controls  = dataSource?.cellControlsForAutoConfig() {
            
            for control in controls {
                
                cellControlFactory.registerCellControl(cellController: control)
            }
        }
    }
}
