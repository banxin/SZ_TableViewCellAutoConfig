//
//  AutoCellConfigContentView.swift
//  SZ_TableViewCellAutoConfig
//
//  Created by 山竹 on 2019/1/11.
//  Copyright © 2019 shanzhu. All rights reserved.
//

import UIKit

import SnapKit

/// 内容view（如：时间：xxx 类似的view）
class AutoCellConfigContentView: UIView {
    
    /// 说明title
    private lazy var titleLabel: UILabel = UILabel.init(title: "", fontSize: 14, color: UIColor.colorWithHex(hexString: "a8a8a8"))
    /// 说明content
    private lazy var contentLabel: UILabel = UILabel.init(title: "", fontSize: 14, color: UIColor.colorWithHex(hexString: "666666"))
    
    // 左右的偏移量
    private var offet: CGFloat = 12
    /// 是否内容需要多行
    private var isTextNeedLines: Bool = true
    
    /// 便利构造 内容view
    ///
    /// - Parameters:
    ///   - title:           title
    ///   - titleWidth:      title 的宽度
    ///   - offet:           说明content 的宽度
    ///   - isTextNeedLines: 是否内容需要多行
    ///   - offet:           说明content 的宽度
    convenience init(title: String, isTextNeedLines: Bool = true, offet: CGFloat = 12) {
        
        self.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        self.offet           = offet
        self.isTextNeedLines = isTextNeedLines
        
        setupUI()
        
        titleLabel.text = title
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI
extension AutoCellConfigContentView {
    
    /// UI设置
    private func setupUI() {
        
        // 某些版本（10.3.3）有问题，需要设置优先级
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        titleLabel.font = UIFont(name: "PingFangSC-Regular", size: 14)
        
        addSubview(titleLabel)
        
        contentLabel.numberOfLines = 0
        contentLabel.font = UIFont(name: "PingFangSC-Regular", size: 14)
        
        addSubview(contentLabel)
        
        layoutViews()
    }
    
    /// 设置约束
    private func layoutViews() {
        
        titleLabel.snp.makeConstraints { (make) in
            
            make.top.equalToSuperview()
            make.left.equalTo(self.offet)
        }
        
        contentLabel.snp.makeConstraints { (make) in
            
            make.top.equalToSuperview()
            make.left.equalTo(self.titleLabel.snp.right)
            // bug 如果直接使用 equalToSuperview，则没法自动撑开，偏移 0.01 都是OK的
            make.right.equalToSuperview().offset(self.offet > 0 ? -self.offet : -0.01)
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - public method
extension AutoCellConfigContentView {
    
    /// 设置内容O
    ///
    /// - Parameter content: 内容str
    func setupContent(content: String, contentColor: UIColor = UIColor.colorWithHex(hexString: "666666")) {
        
        // 自动撑开如果使用 "" 不会触发，所以做了个判断 以后有时间优化 @山竹
        setupContentAttributedText(content: content == "" ? " " : content)
        contentLabel.textColor = contentColor
    }
}

// MARK: - private method
extension AutoCellConfigContentView {
    
    /// 设置内容的富文本（需要行间距 5）
    ///
    /// - Parameter content: 内容的文本
    private func setupContentAttributedText(content: String) {
        
        // iOS 9.0 之后才支持 平方字体，之前的话，使用会crash
        if #available(iOS 9, *) {
            
            let paragraph = NSMutableParagraphStyle()
            
            paragraph.lineSpacing = 4
            
            let attributes = [NSAttributedString.Key.paragraphStyle : paragraph]
            contentLabel.attributedText = NSMutableAttributedString.init(string: content, attributes: attributes)
            
        } else {
            
            contentLabel.text = content
        }
    }
}
