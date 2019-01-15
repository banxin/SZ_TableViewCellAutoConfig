//
//  DifferentDataModel.swift
//  SZ_TableViewCellAutoConfig
//
//  Created by 山竹 on 2019/1/11.
//  Copyright © 2019 shanzhu. All rights reserved.
//

import UIKit

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

/// 不同数据类型 base base
class DifferentDataModelTypeBaseBase: NSObject {
    
    /// 类型
    var type: DifferentDataModelType = .one
}

/// 不同数据类型 base
class DifferentDataModelTypeBase: NSObject {
    
    /// 标题
    var title: String?
    /// 内容
    var content: String?
}

/// 不同数据类型 第一种类型 model
class DifferentDataModelTypeOne: DifferentDataModelTypeBase {
    
    /// 时间
    var timeStr: String?
}

/// 不同数据类型 第二种类型 model
class DifferentDataModelTypeTwo: DifferentDataModelTypeBase {
    
    /// 图片颜色 str
    var imageColor: String?
}

/// 不同数据类型 第三种类型 item model
class DifferentDataModelTypeThreeItem: NSObject {
    
    /// 标题
    var title: String?
}

/// 不同数据类型 第三种类型 model
class DifferentDataModelTypeThree: DifferentDataModelTypeBaseBase {
    
    /// 数据 array
    var items: [DifferentDataModelTypeThreeItem]?
}

/// 不同数据类型 第四种类型 model
// TODO: -（暂时先不启用，用来测试，同一个cell支持不同的数据结构）
class DifferentDataModelTypeFour: NSObject {
    
    
}

/// 不同数据类型 model
class DifferentDataModel: NSObject {
    
    /// 数据 array
    var datas: [Any]?
}
