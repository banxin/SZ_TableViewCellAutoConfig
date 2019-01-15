//
//  UITableView+SZ.swift
//  SZ_TableViewCellAutoConfig
//
//  Created by 山竹 on 2019/1/11.
//  Copyright © 2019 shanzhu. All rights reserved.
//

import UIKit

// MARK: - 高度自动计算及缓存 相关

private var kUITableViewSnapKitCellCacheHeightDictKey       = "kUITableViewSnapKitCellCacheHeightDictKey"
private var kUITableViewSnapKitCellCacheHeightReuseCellsKey = "kUITableViewSnapKitCellCacheHeightReuseCellsKey"

/*
 TableViewCell 使用 Masonry布局 自动计算行高并缓存cell的 TableView category
 */
public extension UITableView {
    
    /// 缓存 cell 行高 的 DIC（key为model的JSONString，value为自动计算好的行高）
    var sz_cacheHeightDictionary: NSMutableDictionary? {
        
        get {
            
            let dict = objc_getAssociatedObject(self, &kUITableViewSnapKitCellCacheHeightDictKey) as? NSMutableDictionary
            
            if let cache = dict { return cache }
            
            let newDict = NSMutableDictionary()
            
            objc_setAssociatedObject(self, &kUITableViewSnapKitCellCacheHeightDictKey, newDict, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            return newDict
        }
    }
    
    /// 缓存用来获取或计算行高的cell，保证性能（理论上只需要一个cell来计算行高即可，降低消耗）
    var sz_cacheCellDictionary: NSMutableDictionary? {
        
        get {
            
            let dict = objc_getAssociatedObject(self, &kUITableViewSnapKitCellCacheHeightReuseCellsKey) as? NSMutableDictionary
            
            if let cache = dict { return cache }
            
            let newDict = NSMutableDictionary()
            
            objc_setAssociatedObject(self, &kUITableViewSnapKitCellCacheHeightReuseCellsKey, newDict, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            return newDict
        }
    }
}
