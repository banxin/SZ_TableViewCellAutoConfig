//
//  DifferentDataModelCell.swift
//  SZ_TableViewCellAutoConfig
//
//  Created by 山竹 on 2019/1/15.
//  Copyright © 2019 shanzhu. All rights reserved.
//

import UIKit

import Kingfisher
import Then
import SnapKit

// MARK: ------------------------------ 分割线 ------------------------------



// MARK: ------------------------------ 分割线 ------------------------------

// MARK: ------------------------------ 分割线 ------------------------------

/// 不同数据类型 第三种 Cell
class DifferentDataModelThreeCell: UITableViewCell, SZDifferentDataModelCellProtocol {
    
    // model
    var itemModel: DifferentDataModelThreeModel?
    
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
    
    // 简介
    var descView: AutoCellConfigContentView = AutoCellConfigContentView(title: "简介：", isTextNeedLines: true)
    
    /// 类型
    var typeView: AutoCellConfigContentView = AutoCellConfigContentView(title: "类型：")
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        addTouchEvent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ShopVisitBaseCellProtocol
    
    var delegate: (SZBaseCellDelegate & SZCellControlProtocol)?
    
    func configWithData(data: Any) {
        
        itemModel = data as? DifferentDataModelThreeModel
        
        configData()
    }
    
    func doSomethingConfigElse() {
        
        print("做点别的配置什么的！！！")
    }
}

// MARK: - UI
extension DifferentDataModelThreeCell {
    
    /// 设置UI
    private func setupUI() {
        
        selectionStyle = .none
        backgroundColor = UIColor.clear
        
        addSubview(backView)
        addSubview(nameLabel)
        addSubview(typeView)
        addSubview(descView)
        
        sz_lastViewInCell = backView
        
        layoutViews()
        
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
    func layoutViews() {
        
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
    
    private func addTouchEvent() {
        
        nameLabel.sz_addTouchEvent { [weak self] (_) in
            
            guard let `self` = self else { return }
            
            self.touchedName()
        }
    }
}

// MARK: - IBAction
extension DifferentDataModelThreeCell {
    
    /// 点击了名称
    private func touchedName() {
        
        if let d = delegate as? SZDifferentDataModelCellDelegate {
            
            d.tapedNameOnCell?(cell: self)
        }
    }
}

// MARK: - private method
extension DifferentDataModelThreeCell {
    
    /// 配置数据
    private func configData() {
        
        guard let model = itemModel else { return }
        
        nameLabel.text = model.name
        typeView.setupContent(content: model.type.rawValue)
        descView.setupContent(content: model.desc ?? "")
    }
}

// MARK: ------------------------------ 分割线 ------------------------------

/// item cell
class DifferentDataModelFourItemCell: UICollectionViewCell {
    
    // item data
    var itemData: DifferentDataModelFourItemModel? {
        
        didSet {
            
            configData()
        }
    }
    
    lazy var imgItem: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI
extension DifferentDataModelFourItemCell {
    
    /// 设置UI
    private func setupUI() {
        
        backgroundColor = UIColor.colorWithHex(hexString: "f7f7f7")
        
        imgItem.contentMode = .scaleAspectFill
        
        imgItem.clipsToBounds      = true
        imgItem.layer.cornerRadius = 5
        
        contentView.addSubview(imgItem)
        
        layoutViews()
    }
    
    /// 布局
    private func layoutViews() {
        
        imgItem.snp.makeConstraints { (make) in
            
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - private method
extension DifferentDataModelFourItemCell {
    
    /// 配置数据
    private func configData() {
        
        imgItem.kf.setImage(with: URL(string: itemData?.imgUrl ?? ""))
    }
}

/// item cell identifier
private let kDifferentDataModelFourCellIdentifier = "kDifferentDataModelFourCellIdentifier"

/// 第四种类型 cell
class DifferentDataModelFourCell: UITableViewCell, SZDifferentDataModelCellProtocol {
    
    /// 横向滚动 表格 view
    var collectionView: UICollectionView?
    
    /// item list
    var advertItemList: [DifferentDataModelFourItemModel]? {
        
        didSet {
            
            collectionView?.reloadData()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SZDifferentDataModelCellProtocol
    
    /// 代理
    var delegate: (SZBaseCellDelegate & SZCellControlProtocol)?
    
    /// 配置数据
    ///
    /// - Parameter data: 模型
    func configWithData(data: Any) {
        
        guard let model = data as? DifferentDataModelFourModel,
            let items = model.items else { return }
        
        if items.count > 0 {
            
            advertItemList = items
        }
    }
    
    func doSomethingConfigElse() {
        
        print("做点别的配置什么的！！！")
    }
}

// MARK: - UI
extension DifferentDataModelFourCell {
    
    /// 设置UI
    private func setupUI() {
        
        backgroundColor = UIColor.colorWithHex(hexString: "f7f7f7")
        
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        flowLayout.scrollDirection = .horizontal
        
        collectionView = UICollectionView.init(frame: CGRect(x: 12, y: 12, width: UIScreen.main.sz_screenWidth - 12, height: UIScreen.sz_layoutUI(originalNum: 80)), collectionViewLayout: flowLayout)
        
        collectionView?.backgroundColor                = UIColor.colorWithHex(hexString: "f7f7f7")
        collectionView?.showsVerticalScrollIndicator   = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.delegate   = self
        collectionView?.dataSource = self
        collectionView?.register(DifferentDataModelFourItemCell.self, forCellWithReuseIdentifier: kDifferentDataModelFourCellIdentifier)
        
        addSubview(collectionView!)
        
        // 离屏渲染 - 异步绘制
        layer.drawsAsynchronously = true
        // 栅格化 - 异步绘制之后，会生成一张独立的图像，cell在屏幕滚动的时候，本质上滚动的是这张图片
        // cell 优化，要尽量减少图层的数量，相当于就只有一层
        // 停止滚动之后，可以接收监听
        layer.shouldRasterize = true
        // 使用栅格化，必须注意指定分辨率
        layer.rasterizationScale = UIScreen.main.scale
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate & UICollectionViewDelegateFlowLayout
extension DifferentDataModelFourCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return advertItemList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if advertItemList?.count ?? 0 > indexPath.row {
            
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kDifferentDataModelFourCellIdentifier, for: indexPath) as? DifferentDataModelFourItemCell {
                
                cell.itemData = advertItemList?[indexPath.row]
                
                return cell
            }
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if advertItemList?.count ?? 0 > indexPath.row {
            
            if let item = advertItemList?[indexPath.row],
                let _ = item.imgUrl,
                let d = delegate as? SZDifferentDataModelCellDelegate {
                
                d.tapedImageItemOnCell?(cell: self)
            }
        }
    }
    
    // item size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: UIScreen.sz_layoutUI(originalNum: 140), height: UIScreen.sz_layoutUI(originalNum: 80))
    }
    
    // 纵向 间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 4
    }
    
    // 横向 间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
}
