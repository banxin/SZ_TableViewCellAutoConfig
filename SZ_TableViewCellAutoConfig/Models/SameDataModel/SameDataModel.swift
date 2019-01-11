//
//  SameDataModel.swift
//  SZ_TableViewCellAutoConfig
//
//  Created by 山竹 on 2019/1/11.
//  Copyright © 2019 shanzhu. All rights reserved.
//

import Foundation

/// 相同数据结构 类型
///
/// - SameDataModelTypeOne: 类型 1
/// - SameDataModelTypeTwo: 类型 2
enum SameDataModelType: String {
    
    case one = "SameDataModelTypeOne"
    case two = "SameDataModelTypeTwo"
}

/// 相同数据结构 model
class SameDataModel: NSObject {
    
    /// 类型
    var type: SameDataModelType = .one
    /// 时间 str
    var timeStr: String?
    /// 简介
    var desc: String?
}
