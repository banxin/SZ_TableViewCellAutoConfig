//
//  DifferentDataModel.swift
//  SZ_TableViewCellAutoConfig
//
//  Created by 山竹 on 2019/1/11.
//  Copyright © 2019 shanzhu. All rights reserved.
//

import UIKit

import HandyJSON

/// 不同数据结构 类型
///
/// - one:   类型 1
/// - two:   类型 2
/// - three: 类型 3
/// - four:  类型 4
enum DifferentDataModelType: String {
    
    case one   = "DifferentDataModelTypeOne"
    case two   = "DifferentDataModelTypeTwo"
    case three = "DifferentDataModelTypeThree"
    case four  = "DifferentDataModelTypeFour"
}

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

/// 不同数据类型 第一种类型 model
class DifferentDataModelOneModel: DifferentDataModelBaseModel {
    
    /// 时间
    var date: String?
    /// 星期
    var week: String?
    /// 天气图片
    var icon: String?
    /// 温度
    var temperature: String?
    /// 湿度
    var humidity: String?
    
    // MARK: - SZCellModelExtentionProtocol
    override func modelExtentionItemType() -> String {
        
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

/// 不同数据类型 第三种类型 model
class DifferentDataModelThreeModel: DifferentDataModelBaseModel {
    
    /// id
    var id: Int?
    /// 名字
    var name: String?
    /// 简介
    var desc: String?
    
    // MARK: - SZCellModelExtentionProtocol
    override func modelExtentionItemType() -> String {
        
        return DifferentDataModelType.three.rawValue
    }
}

/// 不同数据类型 第四种类型 item model
class DifferentDataModelFourItemModel: HandyJSON {
    
    // 图片 链接
    var imgUrl: String?
    
    required init() {}
}

/// 不同数据类型 第四种类型 model
class DifferentDataModelFourModel: DifferentDataModelBaseModel {
    
    // 资源位 itemList
    var items: [DifferentDataModelFourItemModel]?

    // MARK: - SZCellModelExtentionProtocol
    override func modelExtentionItemType() -> String {
        
        return DifferentDataModelType.four.rawValue
    }
}

/// 不同数据类型 model
class DifferentDataModel: NSObject {
    
    /// 数据 array
    var datas: [Any]?
}
