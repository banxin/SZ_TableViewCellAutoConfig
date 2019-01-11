//
//  UIViewController+SZ.swift
//  SZ_RxProDemo
//
//  Created by 山竹 on 2018/10/17.
//  Copyright © 2018年 SZ. All rights reserved.
//

import UIKit

typealias AlertCallback =  ((UIAlertAction) -> Void)

// MARK: - UIViewController 扩展
extension UIViewController {
    
    func flash(title: String, message: String, callback: AlertCallback? = nil) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(
            title: "OK",
            style: UIAlertAction.Style.default,
            handler: callback)
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

