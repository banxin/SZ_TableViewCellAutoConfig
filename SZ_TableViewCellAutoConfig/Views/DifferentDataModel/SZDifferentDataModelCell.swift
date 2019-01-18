//
//  SZDifferentDataModelCell.swift
//  SZ_TableViewCellAutoConfig
//
//  Created by 山竹 on 2019/1/16.
//  Copyright © 2019 shanzhu. All rights reserved.
//

import UIKit

import Kingfisher
import Then
import SnapKit

// MARK: ------------------------------ 分割线 ------------------------------

/// 不同数据类型 第一种 Cell
class DifferentDataModelOneCell: UITableViewCell, SZBaseCellProtocol {
    
    // model
    var itemModel: DifferentDataModelOneModel?
    
    /// 星期
    var week: UILabel = UILabel().then {
        
        $0.font      = UIFont(name: "PingFangSC-Semibold", size: 20)
        $0.textColor = UIColor.colorWithHex(hexString: "EE4D37")
    }
    /// 日期
    var date: UILabel = UILabel().then {
        
        $0.font      = UIFont(name: "PingFangSC-Semibold", size: 17)
        $0.textColor = UIColor.colorWithHex(hexString: "4A4A4A")
    }
    /// 温度
    var temperature: UILabel = UILabel().then {
        
        $0.font      = UIFont.systemFont(ofSize: 17)
        $0.textColor = UIColor.colorWithHex(hexString: "4A4A4A")
    }
    /// 天气
    var weatherIcon: UIImageView = UIImageView()
    /// 湿度
    var humid: UILabel = UILabel().then {
        
        $0.font          = UIFont.systemFont(ofSize: 17)
        $0.textColor     = UIColor.colorWithHex(hexString: "4A4A4A")
        $0.textAlignment = .right
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ShopVisitBaseCellProtocol
    
//    func doSomethingConfigElse() {
//
//        print("做点别的配置什么的！！！")
//    }
    
    var delegate: (SZBaseCellDelegate & SZCellControlProtocol)?
    
    func configWithData(data: Any) {
        
        itemModel = data as? DifferentDataModelOneModel
        
        configData()
    }
}

// MARK: - UI
extension DifferentDataModelOneCell {
    
    private func setupUI() {
        
        selectionStyle = .none
        
        addSubview(week)
        addSubview(date)
        addSubview(temperature)
        addSubview(weatherIcon)
        addSubview(humid)
        
        layoutViews()
        
        addTouchEvent()
    }
    
    private func layoutViews() {
        
        weatherIcon.snp.makeConstraints { (maker) in
            
            maker.top.equalTo(11)
            maker.right.equalTo(-15)
            maker.size.equalTo(CGSize(width: 58, height: 58))
        }
        
        week.snp.makeConstraints { (maker) in
            
            maker.top.equalTo(8)
            maker.left.equalTo(15)
            maker.right.equalTo(self.weatherIcon.snp.left).offset(-8)
        }
        
        date.snp.makeConstraints { (maker) in
            
            maker.left.right.equalTo(self.week)
            maker.top.equalTo(self.week.snp.bottom).offset(8)
        }
        
        temperature.snp.makeConstraints { (maker) in
            
            maker.top.equalTo(self.date.snp.bottom).offset(8)
            maker.left.equalTo(self.week)
            maker.right.equalTo(self.humid.snp.left)
        }
        
        humid.snp.makeConstraints { (maker) in
            
            maker.top.equalTo(self.date.snp.bottom).offset(8)
            maker.right.equalTo(self.weatherIcon)
            maker.left.equalTo(self.temperature.snp.right)
        }
    }
    
    /// 添加点击事件
    private func addTouchEvent() {
        
        weatherIcon.sz_addTouchEvent { [weak self] (_) in
            
            guard let `self` = self else { return }
            
            self.touchedWeatherIcon()
        }
    }
}

// MARK: - private method
extension DifferentDataModelOneCell {
    
    private func touchedWeatherIcon() {
        
        if let d = delegate as? SZDifferentDataModelCellDelegate {
            
            d.tapedWeatherIconOnCell?(cell: self)
        }
    }
    
    /// 配置数据
    private func configData() {
        
        guard let model = itemModel else { return }
        
        week.text         = model.week
        date.text         = model.date
        humid.text        = model.humidity
        temperature.text  = model.temperature
        weatherIcon.image = UIImage.sz_weatherIcon(of: model.icon ?? "")
    }
}

// MARK: ------------------------------ 分割线 ------------------------------

/// 不同数据类型 第二种 Cell
class DifferentDataModelTwoCell: UITableViewCell, SZBaseCellProtocol {
    
    /// 背景 view
    private lazy var backView: UIView = {
        
        let v = UIView()
        
        v.backgroundColor = UIColor.white
        v.clipsToBounds   = true
        v.layer.cornerRadius = 5
        
        return v
    }()
    /// 品牌logo
    private lazy var logoImage: UIImageView = {
        
        let logo = UIImageView()
        
        logo.backgroundColor = UIColor.colorWithHex(hexString: "f1f2f3")
        logo.clipsToBounds   = true
        logo.contentMode     = .scaleAspectFill
        
        logo.layer.cornerRadius = 5
        logo.layer.borderWidth  = 0.5
        logo.layer.borderColor  = UIColor.colorWithHex(hexString: "e8e8e8").cgColor
        
        return logo
    }()
    /// 品牌名称
    private lazy var nameLabel: UILabel = UILabel().then {
        
        $0.font          = UIFont(name: "PingFangSC-Semibold", size: 16)
        $0.textColor     = UIColor.colorWithHex(hexString: "444444")
        $0.numberOfLines = 0
    }
    /// 合作门店 title
    private lazy var cooperationShopTitleLabel: UILabel = UILabel.init(title: "全国合作门店：", fontSize: 14, color: UIColor.colorWithHex(hexString: "a8a8a8"))
    /// 合作门店 数量
    private lazy var cooperationShopCountLabel: UILabel = UILabel.init(title: "：", fontSize: 14, color: UIColor.colorWithHex(hexString: "666666"))
    /// 线条
    private lazy var line: UIView = {
        
        let l = UIView()
        
        l.backgroundColor = UIColor.colorWithHex(hexString: "e8e8e8")
        
        return l
    }()
    /// 合作门店按钮
    private lazy var cooperationShopButton: UILabel = {
        
        return self.createCustomLabel(title: "门店")
    }()
    /// 品牌知识按钮
    private lazy var brandKnowledgeButton: UILabel = {
        
        return self.createCustomLabel(title: "政策知识")
    }()
    /// 品牌素材按钮
    private lazy var brandMaterialButton: UILabel = {
        
        return self.createCustomLabel(title: "素材", textColor: UIColor.white, backgroundColor: UIColor.colorWithHex(hexString: "4A96F1"), isNeedBorder: false)
    }()
    
    // model
    var itemModel: DifferentDataModelTwoModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ShopVisitBaseCellProtocol
    
//    func doSomethingConfigElse() {
//
//        print("做点别的配置什么的！！！")
//    }
    
    var delegate: (SZBaseCellDelegate & SZCellControlProtocol)?
    
    func configWithData(data: Any) {
        
        itemModel = data as? DifferentDataModelTwoModel
        
        configData()
    }
}

// MARK: - UI
extension DifferentDataModelTwoCell {
    
    /// 设置UI
    private func setupUI() {
        
        selectionStyle = .none
        backgroundColor = UIColor.clear
        
        addSubview(backView)
        addSubview(logoImage)
        addSubview(nameLabel)
        addSubview(cooperationShopTitleLabel)
        addSubview(cooperationShopCountLabel)
        addSubview(line)
        addSubview(cooperationShopButton)
        addSubview(brandKnowledgeButton)
        addSubview(brandMaterialButton)
        
        layoutViews()
        
        sz_lastViewInCell = backView
        
        // 离屏渲染 - 异步绘制
        layer.drawsAsynchronously = true
        // 栅格化 - 异步绘制之后，会生成一张独立的图像，cell在屏幕滚动的时候，本质上滚动的是这张图片
        // cell 优化，要尽量减少图层的数量，相当于就只有一层
        // 停止滚动之后，可以接收监听
        layer.shouldRasterize = true
        // 使用栅格化，必须注意指定分辨率
        layer.rasterizationScale = UIScreen.main.scale
        
        addTouchEvent()
    }
    
    /// 添加约束
    private func layoutViews() {
        
        logoImage.snp.makeConstraints { (maker) in
            
            maker.left.equalTo(24)
            maker.top.equalTo(12)
            maker.size.equalTo(CGSize(width: 50, height: 50))
        }
        
        nameLabel.snp.makeConstraints { (maker) in
            
            maker.top.equalTo(self.logoImage.snp.top)
            maker.left.equalTo(self.logoImage.snp.right).offset(12)
            maker.width.equalTo(UIScreen.main.sz_screenWidth - 24 - 24 - 50 - 12)
        }
        
        cooperationShopTitleLabel.snp.makeConstraints { (maker) in
            
            maker.left.equalTo(self.nameLabel)
            maker.top.equalTo(self.nameLabel.snp.bottom).offset(8)
        }
        
        cooperationShopCountLabel.snp.makeConstraints { (maker) in
            
            maker.top.equalTo(self.cooperationShopTitleLabel)
            maker.left.equalTo(self.cooperationShopTitleLabel.snp.right)
        }
        
        line.snp.makeConstraints { (maker) in
            
            maker.left.equalTo(self.logoImage)
            maker.right.equalTo(self.nameLabel)
            maker.top.equalTo(self.cooperationShopTitleLabel.snp.bottom).offset(12)
            maker.height.equalTo(1)
        }
        
        brandMaterialButton.snp.makeConstraints { (maker) in
            
            maker.right.equalTo(self.line)
            maker.top.equalTo(self.line.snp.bottom).offset(8)
            maker.size.equalTo(CGSize(width: (UIScreen.main.sz_screenWidth - 60) / 3, height: 30))
        }
        
        brandKnowledgeButton.snp.makeConstraints { (maker) in
            
            maker.right.equalTo(self.brandMaterialButton.snp.left).offset(-6)
            maker.centerY.equalTo(self.brandMaterialButton)
            maker.size.equalTo(self.brandMaterialButton)
        }
        
        cooperationShopButton.snp.makeConstraints { (maker) in
            
            maker.right.equalTo(self.brandKnowledgeButton.snp.left).offset(-6)
            maker.centerY.equalTo(self.brandMaterialButton)
            maker.size.equalTo(self.brandMaterialButton)
        }
        
        backView.snp.makeConstraints { (maker) in
            
            maker.top.equalToSuperview()
            maker.left.equalTo(12)
            maker.right.equalTo(-12)
            maker.bottom.equalTo(self.brandMaterialButton.snp.bottom).offset(8)
        }
    }
    
    /// 添加点击事件
    private func addTouchEvent() {
        
        brandMaterialButton.sz_addTouchEvent { [weak self] (_) in
            
            guard let `self` = self else { return }
            
            self.touchedMaterial()
        }
        
        brandKnowledgeButton.sz_addTouchEvent { [weak self] (_) in
            
            guard let `self` = self else { return }
            
            self.touchedBrandKnowledge()
        }
        
        cooperationShopButton.sz_addTouchEvent { [weak self] (_) in
            
            guard let `self` = self else { return }
            
            self.touchedCooperationShop()
        }
    }
}

// MARK: - private method
extension DifferentDataModelTwoCell {
    
    /// 配置数据
    private func configData() {
        
        guard let model = itemModel else { return }
        
        if let iconUrl = model.imageUrl {
            
            logoImage.kf.setImage(with: URL(string: iconUrl))
        }
        
        // iOS 9.0 之后才支持 平方字体，之前的话，使用会crash
        let paragraph = NSMutableParagraphStyle()
        
        paragraph.lineSpacing = 3
        
        let attributes = [NSAttributedString.Key.paragraphStyle : paragraph]
        nameLabel.attributedText = NSMutableAttributedString.init(string: model.name ?? "", attributes: attributes)
        
        cooperationShopTitleLabel.text = (model.cooperationShopStr ?? "全国合作门店") + "："
        cooperationShopCountLabel.text = "\(model.cooperationShopCount)"
    }
    
    private func createCustomLabel(title: String, textColor: UIColor = UIColor.colorWithHex(hexString: "444444"), backgroundColor: UIColor = UIColor.white, isNeedBorder: Bool = true) -> UILabel {
        
        let l = UILabel.init(title: title, fontSize: 14, color: textColor)
        
        l.backgroundColor = backgroundColor
        l.textAlignment   = .center
        l.clipsToBounds   = true
        l.layer.cornerRadius = 15
        
        if isNeedBorder {
            
            l.layer.borderWidth  = 0.5
            l.layer.borderColor  = UIColor.colorWithHex(hexString: "a8a8a8").cgColor
        }
        
        return l
    }
    
    private func touchedMaterial() {
        
        if let d = delegate as? SZDifferentDataModelCellDelegate {
            
            d.tapedMaterialOnCell?(cell: self)
        }
    }
    
    private func touchedBrandKnowledge() {
        
        if let d = delegate as? SZDifferentDataModelCellDelegate {
            
            d.tapedKnowledgeOnCell?(cell: self)
        }
    }
    
    private func touchedCooperationShop() {
        
        if let d = delegate as? SZDifferentDataModelCellDelegate {
            
            d.tapedShopOnCell?(cell: self)
        }
    }
}

// MARK: ------------------------------ 分割线 ------------------------------

/// 不同数据类型 第三种 Cell
class DifferentDataModelThreeCell: UITableViewCell, SZBaseCellProtocol {
    
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
    
//    func doSomethingConfigElse() {
//
//        print("做点别的配置什么的！！！")
//    }
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
class DifferentDataModelFourCell: UITableViewCell, SZBaseCellProtocol {
    
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
    
    // MARK: - SZBaseCellProtocol
    
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
    
//    func doSomethingConfigElse() {
//        
//        print("做点别的配置什么的！！！")
//    }
}

// MARK: - UI
extension DifferentDataModelFourCell {
    
    /// 设置UI
    private func setupUI() {
        
        selectionStyle  = .none
        backgroundColor = UIColor.colorWithHex(hexString: "f7f7f7")
        
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        flowLayout.scrollDirection = .horizontal
        
        collectionView = UICollectionView.init(frame: CGRect(x: 12, y: 0, width: UIScreen.main.sz_screenWidth - 12, height: UIScreen.sz_layoutUI(originalNum: 80)), collectionViewLayout: flowLayout)
        
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
