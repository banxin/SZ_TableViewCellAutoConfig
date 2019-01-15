//
//  SameDataModelTypeCell.swift
//  SZ_TableViewCellAutoConfig
//
//  Created by 山竹 on 2019/1/11.
//  Copyright © 2019 shanzhu. All rights reserved.
//

import UIKit

import Then
import SnapKit

/// 相同数据类型 base Cell
class SameDataModelTypeBaseCell: UITableViewCell, SZSameDataModelCellProtocol {
    
    // model
    var itemModel: SameDataModel?
    
    /// 背景 view
    var backView: UIView = UIView().then {
        
        $0.backgroundColor = UIColor.white
        $0.sz_setRadiusAndBorder(cornerSize: 5)
    }
    
    /// 名称
    var nameLabel: UILabel = UILabel().then {
        
        $0.font          = UIFont(name: "PingFangSC-Medium", size: 16)
        $0.textColor     = UIColor.colorWithHex(hexString: "444444")
        $0.numberOfLines = 0
    }
    
    /// 类型
    var typeView: AutoCellConfigContentView = AutoCellConfigContentView(title: "类型：")
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        baseSetupUI()
        addTouchEvent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ShopVisitBaseCellProtocol
    
    var delegate: (SZBaseCellDelegate & SZCellControlProtocol)?
    
    func configWithData(data: Any) {
        
        itemModel = data as? SameDataModel
        
        configData()
    }
    
    func doSomethingConfigElse() {
        
        print("做点别的配置什么的！！！")
    }
}

// MARK: - UI
extension SameDataModelTypeBaseCell {
    
    /// 设置UI
    private func baseSetupUI() {
        
        selectionStyle = .none
        backgroundColor = UIColor.clear
        
        addSubview(backView)
        addSubview(nameLabel)
        addSubview(typeView)
        
        baseLayoutViews()
        
        // 离屏渲染 - 异步绘制
        layer.drawsAsynchronously = true
        // 栅格化 - 异步绘制之后，会生成一张独立的图像，cell在屏幕滚动的时候，本质上滚动的是这张图片
        // cell 优化，要尽量减少图层的数量，相当于就只有一层
        // 停止滚动之后，可以接收监听
        layer.shouldRasterize = true
        // 使用栅格化，必须注意指定分辨率
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    /// 添加约束
    func baseLayoutViews() {
        
        nameLabel.snp.makeConstraints { (maker) in
            
            maker.left.equalTo(24)
            maker.top.equalTo(12)
            maker.width.equalTo(UIScreen.main.sz_screenWidth - 48)
        }
        
        typeView.snp.makeConstraints { (maker) in
            
            maker.left.equalTo(12)
            maker.width.equalTo(UIScreen.main.sz_screenWidth - 24)
            maker.top.equalTo(self.nameLabel.snp.bottom).offset(8)
        }
    }
    
    private func addTouchEvent() {
        
        nameLabel.sz_addTouchEvent { [weak self] (_) in
            
            guard let `self` = self else { return }
            
            self.touchedName()
        }
    }
}

// MARK: - IBAction
extension SameDataModelTypeBaseCell {
    
    /// 点击了名称
    private func touchedName() {
        
        if let d = delegate as? SZSameDataModelCellDelegate {
            
            d.tapedNameOnCell?(cell: self)
        }
    }
}

// MARK: - private method
extension SameDataModelTypeBaseCell {
    
    /// 配置数据
    private func configData() {
        
        guard let model = itemModel else { return }
        
        nameLabel.text = model.name
        typeView.setupContent(content: model.type.rawValue)
    }
}

// MARK: - --------------------- 分割线 ---------------------

/// 相同数据类型 第一种Cell
class SameDataModelTypeOneCell: SameDataModelTypeBaseCell {
    
    /// 时间
    var timeView: AutoCellConfigContentView = AutoCellConfigContentView(title: "时间：")
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - override
    
    override func configWithData(data: Any) {
        
        super.configWithData(data: data)
        
        configData()
    }
}

// MARK: - UI
extension SameDataModelTypeOneCell {
    
    /// 设置UI
    private func setupUI() {
        
        addSubview(timeView)
        
        sz_lastViewInCell = backView
        
        layoutViews()
    }
    
    /// 添加约束
    private func layoutViews() {
        
        baseLayoutViews()
        
        timeView.snp.makeConstraints { (maker) in
            
            maker.left.width.equalTo(self.typeView)
            maker.top.equalTo(self.typeView.snp.bottom).offset(8)
        }
        
        backView.snp.remakeConstraints { (maker) in
            
            maker.top.equalToSuperview()
            maker.left.equalTo(12)
            maker.right.equalTo(-12)
            maker.bottom.equalTo(self.timeView.snp.bottom).offset(12)
        }
    }
}

// MARK: - private method
extension SameDataModelTypeOneCell {
    
    /// 配置数据
    private func configData() {
        
        guard let model = itemModel else { return }
        
        timeView.setupContent(content: model.timeStr ?? "")
    }
}

// MARK: - --------------------- 分割线 ---------------------

/// 相同数据类型 第二种Cell
class SameDataModelTypeTwoCell: SameDataModelTypeBaseCell {
    
    // 简介
    var descView: AutoCellConfigContentView = AutoCellConfigContentView(title: "简介：", isTextNeedLines: true)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - override
    
    override func configWithData(data: Any) {
        
        super.configWithData(data: data)
        
        configData()
    }
}

// MARK: - UI
extension SameDataModelTypeTwoCell {
    
    /// 设置UI
    private func setupUI() {
        
        addSubview(descView)
        
        sz_lastViewInCell = backView
        
        layoutViews()
    }
    
    /// 添加约束
    private func layoutViews() {
        
        baseLayoutViews()
        
        descView.snp.makeConstraints { (maker) in
            
            maker.left.width.equalTo(self.typeView)
            maker.top.equalTo(self.typeView.snp.bottom).offset(6)
        }
        
        backView.snp.remakeConstraints { (maker) in
            
            maker.top.equalToSuperview()
            maker.left.equalTo(12)
            maker.right.equalTo(-12)
            maker.bottom.equalTo(self.descView.snp.bottom).offset(12)
        }
    }
}

// MARK: - private method
extension SameDataModelTypeTwoCell {
    
    /// 配置数据
    private func configData() {
        
        guard let model = itemModel else { return }
        
        descView.setupContent(content: model.desc ?? "")
    }
}
