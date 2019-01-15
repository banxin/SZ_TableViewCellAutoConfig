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

// MARK: - instance method
public extension UIView {
    
    /// 设置阴影
    ///
    /// - Parameters:
    ///   - shadowColor:   shadowColor
    ///   - shadowOffset:  shadowOffset
    ///   - shadowOpacity: shadowOpacity
    ///   - shadowRadius:  shadowRadius
    func sz_setShadow(shadowColor: CGColor? = nil,
                       shadowOffset: CGSize? = nil,
                       shadowOpacity: Float? = nil,
                       shadowRadius: CGFloat? = nil) {
        
        if let color = shadowColor { layer.shadowColor = color }
        // shadowOffset阴影偏移,x向右偏移，y向下偏移，默认(0, -3),这个跟shadowRadius配合使用
        if let offset = shadowOffset { layer.shadowOffset = offset }
        // 阴影透明度，默认0
        if let opacity = shadowOpacity { layer.shadowOpacity = opacity }
        if let radius = shadowRadius { layer.shadowRadius = radius }
    }
    
    /// 设置圆角和描边
    ///
    /// - Parameters:
    ///   - cornerSize:  圆角 size
    ///   - borderWidth: 描边 width
    ///   - borderColor: 描边 color
    func sz_setRadiusAndBorder(cornerSize: CGFloat? = nil,
                                borderWidth: CGFloat? = nil,
                                borderColor: CGColor? = nil) {
        
        clipsToBounds = true
        
        if let size = cornerSize { layer.cornerRadius = size }
        if let width = borderWidth { layer.borderWidth = width }
        if let color = borderColor { layer.borderColor = color }
    }
}
