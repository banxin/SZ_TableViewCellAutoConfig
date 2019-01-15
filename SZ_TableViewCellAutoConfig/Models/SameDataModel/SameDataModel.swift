//
//  SameDataModel.swift
//  SZ_TableViewCellAutoConfig
//
//  Created by 山竹 on 2019/1/11.
//  Copyright © 2019 shanzhu. All rights reserved.
//

import Foundation

import HandyJSON

/// 相同数据结构 类型
///
/// - one: 类型 1
/// - two: 类型 2
enum SameDataModelType: String, HandyJSONEnum {
    
    case one = "SameDataModelTypeOne"
    case two = "SameDataModelTypeTwo"
}

/// 相同数据结构 model
class SameDataModel: HandyJSON {
    
    /// id
    var id: Int?
    /// 名字
    var name: String?
    /// 类型
    var type: SameDataModelType = .one
    /// 时间 str
    var timeStr: String?
    /// 简介
    var desc: String?
    
    required init() {}
}
