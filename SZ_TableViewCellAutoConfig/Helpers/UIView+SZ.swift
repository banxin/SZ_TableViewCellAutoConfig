//
//  UIView+SZ.swift
//  SZ_RxProDemo
//
//  Created by 山竹 on 2018/11/9.
//  Copyright © 2018年 SZ. All rights reserved.
//

import UIKit

// MARK: - 添加点击事件

/// 关联属性 key
private var kUIViewTouchEventKey = "kUIViewTouchEventKey"

/// 点击事件闭包
public typealias UIViewTouchEvent = (AnyObject) -> ()

public extension UIView {
    
    private var touchEvent: UIViewTouchEvent? {
        
        set {
            
            objc_setAssociatedObject(self, &kUIViewTouchEventKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        
        get {
            
            if let event = objc_getAssociatedObject(self, &kUIViewTouchEventKey) as? UIViewTouchEvent {
                
                return event
            }
            
            return nil
        }
    }
    
    /// 添加点击事件
    ///
    /// - Parameter event: 闭包
    func sz_addTouchEvent(event: @escaping UIViewTouchEvent) {
        
        self.touchEvent = event
        
        // 先判断当前是否有交互事件，如果没有的话。。。所有gesture的交互事件都会被添加进gestureRecognizers中
        if (self.gestureRecognizers == nil) {
            
            self.isUserInteractionEnabled = true
            
            // 添加单击事件
            let tapEvent = UITapGestureRecognizer.init(target: self, action: #selector(touchedAciton))
            
            self.addGestureRecognizer(tapEvent)
        }
    }
    
    /// 点击事件处理
    @objc private func touchedAciton() {
        
        guard let touchEvent = self.touchEvent else {
            
            return
        }
        
        touchEvent(self)
    }
}
