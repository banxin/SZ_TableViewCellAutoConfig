//
//  TableViewCellAutoConfigUtil.swift
//  SZ_TableViewCellAutoConfig
//
//  Created by 山竹 on 2019/1/11.
//  Copyright © 2019 shanzhu. All rights reserved.
//

import Foundation

/// 工具类
class TableViewCellAutoConfigUtil {
    
}

// MARK: - static method
extension TableViewCellAutoConfigUtil {
    
    /// 获取本地mock数据
    ///
    /// - Parameter fileName: JSON文件的名称
    /// - Returns: mock数据
    static func fetchLoacalMockData(fileName: String) -> [String: Any]? {
        
        if let path = Bundle.main.path(forResource: fileName, ofType: "json"),
            let data = NSData.init(contentsOfFile: path) as Data?,
        let dic = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
            
            return dic
        }
        
        return nil
    }
}
