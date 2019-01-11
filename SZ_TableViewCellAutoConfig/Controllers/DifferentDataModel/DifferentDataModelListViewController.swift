//
//  DifferentDataModelListViewController.swift
//  SZ_TableViewCellAutoConfig
//
//  Created by 山竹 on 2019/1/11.
//  Copyright © 2019 shanzhu. All rights reserved.
//

import UIKit

/// 不同数据类型的 列表
class DifferentDataModelListViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()

        setupUI()
    }
}

// MARK: - UI
extension DifferentDataModelListViewController {
    
    /// 设置UI
    private func setupUI() {
        
        title = "不同数据类型自动配置列表"
        view.backgroundColor = UIColor.colorWithHex(hexString: "f1f2f3")
    }
}
