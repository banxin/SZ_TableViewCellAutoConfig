//
//  MainListViewController.swift
//  SZ_RxProDemo
//
//  Created by 山竹 on 2018/11/8.
//  Copyright © 2018年 SZ. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import Then

private let kMainCellReuseIdentifier = "kMainCellReuseIdentifier"

/// 主页面
class MainListViewController: UITableViewController {

    /// rx资源回收bag
    private let bag: DisposeBag = DisposeBag()
    
    /// 展示数据
    private var demos = BehaviorRelay<[String]>(value: ["SameDataModel Demo", "DifferentDataModel Demo"])
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupUI()
        rxBind()
    }
}

// MARK: - UI
extension MainListViewController {
    
    private func setupUI() {
        
        title = "TableViewCellAutoConfig Demos"
        view.backgroundColor = UIColor.white
        
        tableView.delegate = nil
        tableView.dataSource = nil
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: kMainCellReuseIdentifier)
    }
}

// MARK: - private method
extension MainListViewController {
    
    private func rxBind() {
        
        // 将数据源数据绑定到tableView上
        demos.bind(to: tableView!.rx.items(cellIdentifier: kMainCellReuseIdentifier)) { (_, demoName, originCell) in
            
            originCell.selectionStyle  = .none
            originCell.accessoryType   = .disclosureIndicator
            originCell.textLabel?.text = demoName
            
        }.disposed(by: bag)
        
        // 处理点击事件
        tableView?.rx.modelSelected(NSString.self)
            .map({ (demoName) -> String in
                
                // map 操作符，做一次变换
                if let vcPrfix = demoName.components(separatedBy: " ").first {
                    
                    return vcPrfix + "ListViewController"
                }
                
                return ""
            })
            .subscribe(onNext: { [weak self] (vcName) in
            
                guard let `self` = self else { return }
                
                if let cls = NSClassFromString(Bundle.main.sz_namespace + "." + vcName) as? NSObject.Type,
                    let vc = cls.init() as? UIViewController {
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            
        }).disposed(by: bag)
    }
}
