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

// MARK: ---------------------- SZAutoCofigCellTableViewDataSource ----------------------

/// 自动配置 cell view dataSource
@objc protocol SZAutoCofigCellTableViewDataSource {
    
    /// 获取自动配置的 cellBuilders
    ///
    /// - Returns: cellBuilders
    @objc func cellBuildersForAutoConfig() -> [Any]
    
    /// 获取自动配置的 cellControls
    ///
    /// - Returns: cellBuilders
    @objc func cellControlsForAutoConfig() -> [Any]
    
    /// 获取table的 tableHaderView
    ///
    /// - Returns: tableHaderView
    @objc optional func tableHeaderViewForAutoConfig() -> UIView
    
    /// 获取table的 tableFooterView
    ///
    /// - Returns: tableFooterView
    @objc optional func tableFooterViewForAutoConfig() -> UIView
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
    
    /// 背景颜色
    var sz_backgroundColor: UIColor = UIColor.colorWithHex(hexString: "f5f5f5") {
        
        didSet {
            
            self.tableView.backgroundColor = sz_backgroundColor
        }
    }
    /// section header 高度
    var sectionHeaderHeight: CGFloat = 12
    /// section footer 高度（tableView的bug，设置0的话，不生效）
    var sectionFooterHeight: CGFloat = 0.01
    /// 是否需要首个section header
    var isNeedFirstSectionHeader: Bool = true
    /// 是否需要最后一个section footer
    var isNeedLastSectionFooter: Bool  = true
    
    /// dataSource
    var dataSource: SZAutoCofigCellTableViewDataSource? {
        
        didSet {
            
            self.initFactory()
        }
    }
    /// delegate
    var delegate: SZAutoCofigCellTableViewDelegate?
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
        $0.tableFooterView = UIView().then({
            
            $0.frame = CGRect(x: 0, y: 0, width: UIScreen.main.sz_screenWidth, height: 0.01)
        })
        
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
        
        showArray = items
        
        sz_reloadTableView()
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
            if let itemTypePtl = item as? SZCellModelExtentionProtocol,
                let cellBuilder = cellBuildFactory.getCellBuilderWithRegisterKey(registerKey: itemTypePtl.modelExtentionItemType()),
                var cell = tableView.dequeueReusableCell(withIdentifier: cellBuilder.cellReuseId()) as? SZBaseCellProtocol,
                let cellControlDelegate = cellControlFactory.getCellControlWithDataTypeRegisterKey(registerKey: itemTypePtl.modelExtentionItemType()) {
                
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
            if let itemTypePtl = item as? SZCellModelExtentionProtocol,
                let cellBuilder = cellBuildFactory.getCellBuilderWithRegisterKey(registerKey: itemTypePtl.modelExtentionItemType()) {
                
                return cellBuilder.cellHeightWithModel(model: item)
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 && !isNeedFirstSectionHeader {
            
            return 0.01
        }
        
        // tableView bug 设置0不生效
        return sectionHeaderHeight > 0 ? sectionHeaderHeight : 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 && !isNeedFirstSectionHeader {
            
            return nil
        }
        
        return UIView().then {
            
            $0.frame           = CGRect(x: 0,
                                        y: 0,
                                        width: UIScreen.main.sz_screenWidth,
                                        height: sectionHeaderHeight > 0 ? sectionHeaderHeight : 0.01)
            $0.backgroundColor = self.sz_backgroundColor
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if section == showArray.count - 1 && !isNeedLastSectionFooter {
            
            return 0.01
        }
        
        // tableView bug 设置0不生效
        return sectionFooterHeight > 0 ? sectionFooterHeight : 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if section == showArray.count - 1 && !isNeedLastSectionFooter {
            
            return nil
        }
        
        return UIView().then {
            
            $0.frame           = CGRect(x: 0,
                                        y: 0,
                                        width: UIScreen.main.sz_screenWidth,
                                        height: sectionFooterHeight > 0 ? sectionFooterHeight : 0.01)
            $0.backgroundColor = self.sz_backgroundColor
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 保护代码，防止切换过快，导致的数组越界
        if showArray.count > 0 && indexPath.section < showArray.count {
            
            let item = showArray[indexPath.section]
            
            // 根据数据类型，获取对应的cell
            if let itemTypePtl = item as? SZCellModelExtentionProtocol,
                let cellControlDelegate = cellControlFactory.getCellControlWithDataTypeRegisterKey(registerKey: itemTypePtl.modelExtentionItemType()) {
                
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
    
    /// 初始化工厂
    private func initFactory() {

        initCellBuilderFactory()
        initCellControlFactory()
    }
    
    /// 初始化 cell builder 工厂
    private func initCellBuilderFactory() {
        
        if let builders = dataSource?.cellBuildersForAutoConfig() {
            
            for builder in builders {
                
                if let b = builder as? SZCellBuilderProtocol {
                    
                    cellBuildFactory.registerCellBuilder(cellBuilder: b)
                }
            }
        }
    }
    
    /// 初始化 cell control 工厂
    private func initCellControlFactory() {
        
        if let controls  = dataSource?.cellControlsForAutoConfig() {
            
            for control in controls {
                
                if let c = control as? (SZCellControlProtocol & SZBaseCellDelegate) {
                    
                    cellControlFactory.registerCellControl(cellController: c)
                }
            }
        }
    }
    
    /// 重新 load TableView
    private func sz_reloadTableView() {
        
        if let header = dataSource?.tableHeaderViewForAutoConfig?() {
            
            tableView.tableHeaderView = header
        }
        
        if let footer = dataSource?.tableFooterViewForAutoConfig?() {
            
            tableView.tableFooterView = footer
        }
        
        tableView.reloadData()
    }
}
