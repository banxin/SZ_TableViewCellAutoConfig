//
//  SameDataModelListViewController.swift
//  SZ_TableViewCellAutoConfig
//
//  Created by 山竹 on 2019/1/11.
//  Copyright © 2019 shanzhu. All rights reserved.
//

import UIKit

/// 相同数据类型的 列表
class SameDataModelListViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()

        setupUI()
    }
}

// MARK: - UI
extension SameDataModelListViewController {
    
    /// 设置UI
    private func setupUI() {
        
        title = "相同数据类型自动配置列表"
        view.backgroundColor = UIColor.colorWithHex(hexString: "f1f2f3")
    }
}
