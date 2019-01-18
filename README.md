# 自动cell配置

## 能解决什么

当一个table存在多种类型的cell，判断逻辑势必会非常繁杂

```
1. 所有cell都有部分内容相同，使用的数据结构一致
2. cell样式完全不同，使用的数据结构也不一样
3. 多种cell，但其中某个cell，需要根据不同的数据结构，展示不一样的样式（暂时还没有实际场景，但是可以支持）
```

除了第3种，场景很少，1和2还是比较常见的，第2种有的时候会为了方便网络请求，强行把两个不同的数据结构合并成一个数据结构，导致数据结构非常臃肿。这几类情况，无论是tabview的配置还是cell的展示，按常规套路进行配置的话，判断逻辑都会非常复杂。这里提供一个自动配置的方案，仅供参考，欢迎一起探讨，有更好的实现方式请多指教，多谢。

## 实现原理拆解

先说说主要的思路，思路来源于现在Leader @文优 实现的某APP的搜索功能的源码，然后适当做了一些改进，既能实现很复杂的配置，也能实现一些说复杂又不复杂但代码会写的非常恶心的tableView。


#### 一、CellBuilder - Cell 创建者

首先，看Builder必须要遵守的protocol：

```Swift
/// cell 创建 protocol
protocol SZCellBuilderProtocol {
    
    // dataSource
    var dataSource: SZCellBuilderDataSource? {get set}
    
    /// cell 数据类型（classString 或者 某个指定的key）
    ///
    /// - Returns: 类型
    func supportDataType() -> String
    
    /// cell 高度
    ///
    /// - Parameter model: cell model
    /// - Returns: cell 高度
    func cellHeightWithModel(model: Any) -> CGFloat
    
    /// cell 注册ID
    ///
    /// - Returns: 注册ID
    func cellReuseId() -> String
    
    /// cell class
    ///
    /// - Returns: class
    func cellClass() -> AnyClass
}
```

CellBuilder，cell的创建者，不同类型的cell都有对应的builder且都必须实现该protocol，实现该protocol我们获取了几个Cell渲染的必须值：

    1. cell的数据类型，渲染cell必须的model；
    2. cell 高度，渲染cell必须的cell高度；
    3. cell 注册ID，cell重用的标识；
    4. cell 的类型，需要渲染哪个cell；
    5. dataSource，这个是个可选值，目前dataSource只定义了一个方法，就是获取当前的tableView，我们可能需要在Builder中使用tableView，其他的方式不好传入。（eg：DEMO缓存cell高度时需要使用tableView）

我们看一下这个dataSource：

```Swift
    /// cell 创建 dataSource
@objc protocol SZCellBuilderDataSource {
    
    /// 获取cell的tableView （可能需要用到table，例：自动缓存行高时）
    @objc optional func tableViewForCellBuilder() -> UITableView
}
```

我们来看一个具体的Builder的实现：

```Swift
/// 第一种类型 cell builder
class SZEncapsulationTypeOneCellBuilder: SZCellBuilderProtocol {
    
    var dataSource: SZCellBuilderDataSource?
    
    func supportDataType() -> String {
        
        return DifferentDataModelType.one.rawValue
    }
    
    func cellHeightWithModel(model: Any) -> CGFloat {
        
        return 104
    }
    
    func cellReuseId() -> String {
        
        return "SZEncapsulationTypeOneCellReuseId"
    }
    
    func cellClass() -> AnyClass {
        
        return DifferentDataModelOneCell.self
    }
}
```

#### 二、CellControl - Cell的事件管理者

首先说说CellControl是干什么用的，CellControl需要做的事情有就是处理cell上的各种操作（自身的点击事件和Cell上元素的点击事件）。

这里，control需要实现一个protocol和一个delegate，一个是对于cell级别的控制protocol和针对cell内事件的base cell 代理，CellControlProtocol需要获取到当前的tableview，当前cell的数据model，响应多个类型cell所对应的数据类型的 唯一标识，viewController（需要的话，由于一些操作是需要知道当前VC的），还有处理cell的点击事件；base cell 代理，则是处理cell上元素的一些操作，主要是各种的点击事件。

先来看看定义好的 protocol：

```Swift
/// cell 控制 protocol
@objc protocol SZCellControlProtocol {
    
    /// dataSource
    var dataSource: SZCellControlDataSource? {get set}
    
    /// 响应多种类型的cell
    ///
    /// - Returns: 响应多个类型cell所对应的数据类型的 classString
    func supportDataTypes() -> [String]
}
```

上述 protocol中的dataSource：

```Swift
/// cell 控制 DataSource
@objc protocol SZCellControlDataSource {
    
    // MARK: - 可选扩展
    
    /// 配置cell的数据模型（需要拿到数据做一些事情）
    ///
    /// - Parameter indexPath: indexPath
    /// - Returns: 数据模型
    @objc optional func dataModelForCell(indexPath: NSIndexPath) -> Any?
    
    /// 获取cell的tableView（可能需要用到table，例：刷新cell的某一cell 或 某一个 section）
    ///
    /// - Returns: tableView
    @objc optional func tableViewForCellControl() -> UITableView
    
    /// 获取cell的当前 VC （可能需要用到vc，例：执行跳转）
    ///
    /// - Returns: 当前 VC
    @objc optional func currentViewControllerForCell() -> UIViewController
}
```

在看看另外的需要实现的 delegate：

```Swift
/// base cell 代理 (自定义的 delegate 继承 base)
@objc protocol SZBaseCellDelegate {
    
    // MARK: - 可选扩展
    
    /// 选择了某个item
    ///
    /// - Parameter indexPath: indexPath tableView indexPath
    @objc optional func didSelectedItemAtIndexPath(indexPath: IndexPath)
}
```

基类的代理，只定义了一个可选的 cell 点击事件方法，如需要更多的时间处理，继承该 SZBaseCellDelegate 就可以了。

eg：

```Swift
/// 封装 cell 代理
@objc protocol SZEncapsulationCellDelegate: SZBaseCellDelegate {
    
    // MARK: - optional
    
    /// 点击了Cell上的名称
    ///
    /// - Parameter cell: 对应的cell
    @objc optional func tapedNameOnCell(cell: UITableViewCell)
    
    /// 点击了Cell上的图片item
    ///
    /// - Parameter cell: 对应的cell
    @objc optional func tapedImageItemOnCell(cell: UITableViewCell)
    
    /// 点击了Cell上的天气图标
    ///
    /// - Parameter cell: 对应的cell
    @objc optional func tapedWeatherIconOnCell(cell: UITableViewCell)
    
    /// 点击了Cell上的门店
    ///
    /// - Parameter cell: 对应的cell
    @objc optional func tapedShopOnCell(cell: UITableViewCell)
    
    /// 点击了Cell上的知识
    ///
    /// - Parameter cell: 对应的cell
    @objc optional func tapedKnowledgeOnCell(cell: UITableViewCell)
    
    /// 点击了Cell上的素材
    ///
    /// - Parameter cell: 对应的cell
    @objc optional func tapedMaterialOnCell(cell: UITableViewCell)
}
```

__Tips：目前暂时没有支持SZCellControlProtocol的继承。__


我可与看一个具体的实现类：

```Swift
/// 封装 事件处理基类
class SZEncapsulationBaseActionControl: NSObject, SZCellControlProtocol, SZDifferentDataModelCellDelegate {
    
    // MARK: - SZCellControlProtocol
    
    var dataSource: SZCellControlDataSource?
    
    func supportDataTypes() -> [String] {
        
        return [DifferentDataModelType.one.rawValue,
                DifferentDataModelType.two.rawValue,
                DifferentDataModelType.three.rawValue,
                DifferentDataModelType.four.rawValue]
    }
    
    /*
     需要给子类重写，所以不放在 extension
     */
    
    // MARK: - SZDifferentDataModelCellDelegate
    
    func didSelectedItemAtIndexPath(indexPath: IndexPath) {
        
        print("点击了 cell")
    }
}
```

有些属性和方法是每个cell都需要使用的，所以可以写一个基类。

然后看子类的实现，重写只属于自己的属性，并且加上只有自己才有的代理事件：

```Swift
/// 封装类型二 事件处理
class SZEncapsulationTypeTwoActionControl: SZEncapsulationBaseActionControl {
    
    override func supportDataTypes() -> [String] {
        
        return [DifferentDataModelType.two.rawValue]
    }
    
    // MARK: - SZDifferentDataModelCellDelegate
    
    func tapedShopOnCell(cell: UITableViewCell) {
        
        print("点击了 门店")
    }
    
    func tapedMaterialOnCell(cell: UITableViewCell) {
        
        print("点击了 素材")
    }
    
    func tapedKnowledgeOnCell(cell: UITableViewCell) {
        
        print("点击了 知识")
    }
}
```

#### 三、SZCellModelExtentionProtocol - Cell的数据类型管理者（也是分发的管理者）

先看这个Protocol的定义：

```Swift
/// 模型转换 protocol
protocol SZCellModelExtentionProtocol {
    
    /// 需要转换的model 的 key
    ///
    /// - Returns: key
    func modelExtentionItemType() -> String
}
```

每个cell对应的model，需要实现该protocol，在模型转换和cell渲染分发时，需要使用。模型转换，目前使用的HandyJSON，是不支持一个数组中不同的数据模型一次性转换的，所以需要做循环遍历，单个转换，eg：

```Swift
/// 转换
    ///
    /// - Parameter originAry: 原始的dic ary
    private func convert(originAry: [[String: Any]]) -> [Any] {
        
        var showAry = [Any]()
        
        /*
         data 中存在 不同的数据类型，故而手动转换，
         同时也存在一个过滤的操作，如果不是指定的 type ，则忽略
         */
        for itemDic in originAry {
            
            guard let itemType = itemDic["type"] as? String,
                let cls = cellModelExtensionFactory.getModelWithDataType(itemType: itemType) as? HandyJSON,
                let model = type(of: cls).deserialize(from: itemDic) else {
                    
                    continue
            }
            
            showAry.append(model)
        }
        
        return showAry
    }
```

分发的话，后续会讲到。

这里支持四种不同的cell类型：

```Swift
enum DifferentDataModelType: String {
    
    case one   = "DifferentDataModelTypeOne"
    case two   = "DifferentDataModelTypeTwo"
    case three = "DifferentDataModelTypeThree"
    case four  = "DifferentDataModelTypeFour"
}
```

看一个具体model实现：

```Swift
/// 不同数据类型 base
class DifferentDataModelBaseModel: HandyJSON, SZCellModelExtentionProtocol {
    
    /// 类型
    var type: DifferentDataModelType = .one
    
    required init() {}
    
    // MARK: - SZCellModelExtentionProtocol
    
    func modelExtentionItemType() -> String {
        
        return DifferentDataModelType.one.rawValue
    }
}

/// 不同数据类型 第二种类型 model
class DifferentDataModelTwoModel: DifferentDataModelBaseModel {
    
    // id
    var id: Int?
    /// 图片名称
    var imageUrl: String?
    /// 名字
    var name: String?
    /// 合作门店类型名
    var cooperationShopStr: String?
    /// 合作门店数
    var cooperationShopCount: Int = 0
    
    // MARK: - SZCellModelExtentionProtocol
    override func modelExtentionItemType() -> String {
        
        return DifferentDataModelType.two.rawValue
    }
}

```

#### 四、如何串联起来：

首先，需要初始化Builder和Control的工厂类，把每个cell的对应Builder和Control的实现类注册进工厂：

```Swift
/// 初始化 cell builder 工厂
    private func initCellBuilderFactory() {
        
        if let builders = dataSource?.cellBuildersForAutoConfig() {
            
            for builder in builders {
                
                if let b = builder as? SZCellBuilderProtocol {
                    
                    cellBuildFactory.registerCellBuilder(cellBuilder: b)
                }
            }
        }
    }
    
    /// 初始化 cell control 工厂
    private func initCellControlFactory() {
        
        if let controls  = dataSource?.cellControlsForAutoConfig() {
            
            for control in controls {
                
                if let c = control as? (SZCellControlProtocol & SZBaseCellDelegate) {
                    
                    cellControlFactory.registerCellControl(cellController: c)
                }
            }
        }
    }
```

其次，UITableViewDataSource 和 UITableViewDelegate的渲染cell和cell点击事件中进行分发

获取cell和cell高度：

```Swift
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 保护代码，防止切换过快，导致的数组越界
        if showArray.count > 0 && indexPath.section < showArray.count {
            
            let item = showArray[indexPath.section]
            
            // 根据数据类型，获取对应的cell
            if let itemTypePtl = item as? SZCellModelExtentionProtocol,
                let cellBuilder = cellBuildFactory.getCellBuilderWithRegisterKey(registerKey: itemTypePtl.modelExtentionItemType()),
                var cell = tableView.dequeueReusableCell(withIdentifier: cellBuilder.cellReuseId()) as? SZBaseCellProtocol,
                let cellControlDelegate = cellControlFactory.getCellControlWithDataTypeRegisterKey(registerKey: itemTypePtl.modelExtentionItemType()) {
                
                cell.delegate = cellControlDelegate
                
                cell.configWithData(data: item)
                
                // 测试代码
                // TODO: 没有定义在基类的配置，即自定义配置有问题
//                cell.doSomethingConfigElse()
                
                return cell as? UITableViewCell ?? UITableViewCell()
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // 保护代码，防止切换过快，导致的数组越界
        if showArray.count > 0 && indexPath.section < showArray.count {
            
            let item = showArray[indexPath.section]
            
            // 根据数据类型，获取对应的cell
            if let itemTypePtl = item as? SZCellModelExtentionProtocol,
                let cellBuilder = cellBuildFactory.getCellBuilderWithRegisterKey(registerKey: itemTypePtl.modelExtentionItemType()) {
                
                return cellBuilder.cellHeightWithModel(model: item)
            }
        }
        
        return 0
    }
```

cell的点击事件：

```Swift
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 保护代码，防止切换过快，导致的数组越界
        if showArray.count > 0 && indexPath.section < showArray.count {
            
            let item = showArray[indexPath.section]
            
            // 根据数据类型，获取对应的cell
            if let itemTypePtl = item as? SZCellModelExtentionProtocol,
                let cellControlDelegate = cellControlFactory.getCellControlWithDataTypeRegisterKey(registerKey: itemTypePtl.modelExtentionItemType()) {
                
                cellControlDelegate.didSelectedItemAtIndexPath?(indexPath: indexPath)
            }
        }
    }
```

__Tips：这里获取Builder和Control时，使用的就是对应的model实现上述模型转换的Protocol而获取到的唯一标识。。__

具体的实现详见 DEMO：

    1. SameDataModelListViewController，该类是相同数据模型不同cell的拆解实现类；
    2. DifferentDataModelListViewController，该类是不同数据模型不同cell的拆解实现类；
    3. EncapsulationListViewController，该类是自动配置cell封装后的使用类。


#### 五、如何使用：

每个需要配置的cell均需要实现SZBaseCellProtocol：

```Swift
/// 不同数据类型 第一种 Cell
class DifferentDataModelOneCell: UITableViewCell, SZBaseCellProtocol {
    
    // MARK: - ShopVisitBaseCellProtocol
    
    var delegate: (SZBaseCellDelegate & SZCellControlProtocol)?
    
    func configWithData(data: Any) {
        
        itemModel = data as? DifferentDataModelOneModel
        
        configData()
    }
}
```

目前自动配置的table支持的自定义属性不多，如果有更多需要，@本人或自行自定义。

```Swift
/// 背景颜色
    var sz_backgroundColor: UIColor = UIColor.colorWithHex(hexString: "f5f5f5") {
        
        didSet {
            
            self.tableView.backgroundColor = sz_backgroundColor
        }
    }
    /// section header 高度
    var sectionHeaderHeight: CGFloat = 12
    /// section footer 高度（tableView的bug，设置0的话，不生效）
    var sectionFooterHeight: CGFloat = 0.01
    /// 是否需要首个section header
    var isNeedFirstSectionHeader: Bool = true
    /// 是否需要最后一个section footer
    var isNeedLastSectionFooter: Bool  = true
```

dataSource的定义，Builder和Control必须实现，其他根据需要可选：

```Swift
/// 自动配置 cell view dataSource
@objc protocol SZAutoCofigCellTableViewDataSource {
    
    /// 获取自动配置的 cellBuilders
    ///
    /// - Returns: cellBuilders
    @objc func cellBuildersForAutoConfig() -> [Any]
    
    /// 获取自动配置的 cellControls
    ///
    /// - Returns: cellBuilders
    @objc func cellControlsForAutoConfig() -> [Any]
    
    /// 获取table的 tableHaderView
    ///
    /// - Returns: tableHaderView
    @objc optional func tableHeaderViewForAutoConfig() -> UIView
    
    /// 获取table的 tableFooterView
    ///
    /// - Returns: tableFooterView
    @objc optional func tableFooterViewForAutoConfig() -> UIView
    
    /// 获取table的 refreshHeader
    ///
    /// - Returns: refreshHeader
    @objc optional func refreshHeaderForAutoConfig() -> MJRefreshHeader
    
    /// 获取table的 refreshFooter
    ///
    /// - Returns: refreshFooter
    @objc optional func refreshFooterForAutoConfig() -> MJRefreshFooter
}
```

delegate的定义，其中方法均是可选的：

```Swift
/// 自动配置 cell view delegate
@objc protocol SZAutoCofigCellTableViewDelegate {
    
    /// 列表滚动
    @objc optional func sz_autoCofigScrollViewDidScroll()
    
    /// 重新加载数据
    ///
    /// - Parameter isRefresh: 是否是刷新
    @objc optional func sz_reloadData(isRefresh: Bool)
}
```

将自动配置的table定义好：

```Swift
/// cell自动配置view
private var autoConfigView: SZAutoCofigCellTableView = SZAutoCofigCellTableView()
```

并实现自动配置的table的 dataSource 和 delegate，Builder和Control的实现类，参考DEMO实现就OK：

```Swift
// MARK: - SZAutoCofigCellTableViewDataSource
extension EncapsulationListViewController: SZAutoCofigCellTableViewDataSource {
    
    func cellBuildersForAutoConfig() -> [Any] {
        
        /// 需要支持的 cellBuilders
        let supportBuilders: [SZCellBuilderProtocol] = [SZEncapsulationTypeOneCellBuilder(),
                                                        SZEncapsulationTypeTwoCellBuilder(),
                                                        SZEncapsulationTypeThreeCellBuilder(),
                                                        SZEncapsulationTypeFourCellBuilder()]
        
        // 设置 dataSource
        for var builder in supportBuilders {
            
            builder.dataSource = self
        }
        
        return supportBuilders
    }
    
    func cellControlsForAutoConfig() -> [Any] {
        
        /// 需要支持的 cellControls
        let supportControls: [SZCellControlProtocol] = [SZEncapsulationTypeOneActionControl(),
                                                        SZEncapsulationTypeTwoActionControl(),
                                                        SZEncapsulationTypeThreeActionControl(),
                                                        SZEncapsulationTypeFourActionControl()]
        
        // 设置 dataSource
        for control in supportControls {
            
            control.dataSource = self
        }
        
        return supportControls
    }
    
    /*
     可选方法的测试
     */
    
//    func tableFooterViewForAutoConfig() -> UIView {
//
//        return UIView().then {
//
//            $0.frame           = CGRect(x: 0,
//                                        y: 0,
//                                        width: UIScreen.main.sz_screenWidth,
//                                        height: 30)
//            $0.backgroundColor = UIColor.red
//        }
//    }
//
//    func tableHeaderViewForAutoConfig() -> UIView {
//
//        return UIView().then {
//
//            $0.frame           = CGRect(x: 0,
//                                        y: 0,
//                                        width: UIScreen.main.sz_screenWidth,
//                                        height: 30)
//            $0.backgroundColor = UIColor.blue
//        }
//    }
    
    func refreshHeaderForAutoConfig() -> MJRefreshHeader {
        
        return MJRefreshNormalHeader()
    }
    
    func refreshFooterForAutoConfig() -> MJRefreshFooter {
        
        return MJRefreshAutoStateFooter()
    }
}
```

具体的使用参考 EncapsulationListViewController 的实现。

