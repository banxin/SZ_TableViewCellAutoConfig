////
////  SameDataModelListView.swift
////  SZ_TableViewCellAutoConfig
////
////  Created by 山竹 on 2019/1/14.
////  Copyright © 2019 shanzhu. All rights reserved.
////
//
//import UIKit
//
//import SnapKit
//import Then
//
///// 相同数据模型 view
//class SameDataModelListView: UIView {
//    
//    var viewModel: SameDataModelViewModel?
//    
//    /// 表格 view
//    private var tableView: UITableView = UITableView.init(frame: CGRect.zero, style: .grouped).then {
//        
//        $0.backgroundColor = UIColor.colorWithHex(hexString: "f5f5f5")
//        $0.separatorStyle  = .none
//        $0.tableFooterView = UIView()
//        
//        // 解决 reload 闪烁
//        $0.estimatedRowHeight           = 0
//        $0.estimatedSectionHeaderHeight = 0
//        $0.estimatedSectionFooterHeight = 0
//    }
//    
//    /// 普通的 sectionHeader
//    var normalSectionHeader = UIView().then {
//        
//        $0.frame = CGRect(x: 0, y: 0, width: UIScreen.main.sz_screenWidth, height: 12)
//        $0.backgroundColor = UIColor.colorWithHex(hexString: "f5f5f5")
//    }
//
//    override init(frame: CGRect) {
//        
//        super.init(frame: frame)
//
//        setupUI()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//// MARK: - UI
//extension SameDataModelListView {
//    
//    /// 设置UI
//    private func setupUI() {
//        
//        backgroundColor = UIColor.colorWithHex(hexString: "f5f5f5")
//        
//        tableView.dataSource = self
//        tableView.delegate   = self
//        
//        addSubview(tableView)
//        
//        tableView.snp.makeConstraints { (maker) in
//            
//            maker.edges.equalToSuperview()
//        }
//    }
//}
//
//// MARK: - public method
//extension SameDataModelListView {
//    
//    /// 刷新UI
//    func refreshView() {
//        
//        tableView.reloadData()
//    }
//}
//
//// MARK: - UITableViewDataSource & UITableViewDelegate
//extension SameDataModelListView: UITableViewDataSource, UITableViewDelegate {
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//        return 1
//    }
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        
//        return viewModel?.showArray.count ?? 0
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        return UITableViewCell()
//    }
//}
//
//// MARK: - private method
//extension SameDataModelListView {
//    
//    
//}
