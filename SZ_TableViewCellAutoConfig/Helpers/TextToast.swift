//
//  TextToast.swift
//  SZ_RxProDemo
//
//  Created by 山竹 on 2018/11/19.
//  Copyright © 2018年 SZ. All rights reserved.
//

import UIKit

import SnapKit

/// margin
private let kTextMargin: CGFloat = 15

/// 纯文本 toast
public class TextToast: UILabel {
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - override
    
    override public func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: UIEdgeInsets(top: kTextMargin, left: kTextMargin, bottom: kTextMargin, right: kTextMargin)))
    }
}

// MARK: - UI
extension TextToast {
    
    /// 设置UI
    private func setupUI() {
        
        backgroundColor = UIColor.black.withAlphaComponent(0.7)
        numberOfLines   = 0
        font            = UIFont.systemFont(ofSize: 14)
        textColor       = UIColor.white
        lineBreakMode   = .byWordWrapping
        
        clipsToBounds      = true
        layer.cornerRadius = 5
    }
}

// MARK: - static method
public extension TextToast {
    
    /// 展示toast
    ///
    /// - Parameters:
    ///   - message:     toast内容
    ///   - dismissTime: 消失时间（默认 2.5s）
    static func showToast(message: String, dismissTime: Float = 2.5) {
        
        let toast: TextToast = TextToast()
        
        toast.text = message
        
        let size: CGSize = message.sz_fetchSize(font: toast.font, size: CGSize(width: (UIApplication.shared.delegate?.window??.bounds.size.width)! - kTextMargin * 4, height: CGFloat(MAXFLOAT)), model: toast.lineBreakMode)
        
        UIApplication.shared.delegate?.window??.addSubview(toast)
        
        toast.snp.makeConstraints { (make) in
            
            make.center.equalToSuperview()
            make.height.equalTo(size.height + kTextMargin * 2 + 1) // 加一防止四舍五入的问题
            make.width.equalTo(size.width + kTextMargin * 2 + 1)
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime(floatLiteral: dismissTime)) {
            
            toast.removeFromSuperview()
        }
    }
}
