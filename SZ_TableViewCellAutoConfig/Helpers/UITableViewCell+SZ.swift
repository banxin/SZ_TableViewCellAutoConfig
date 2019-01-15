//
//  UITableViewCell+SZ.swift
//  SZ_TableViewCellAutoConfig
//
//  Created by 山竹 on 2019/1/11.
//  Copyright © 2019 shanzhu. All rights reserved.
//

import UIKit

// MARK: - 高度自动计算及缓存 相关

/// 未指定 state key，则使用默认 key
private let kSnapKitCellCacheStateDefaultKey   = "kSnapKitCellCacheStateDefaultKey"
/// 最靠近底部的view
private var kLastViewInCellKey                 = "kLastViewInCellKey"
/// 偏移量的 key
private var kBottomOffsetFromLastViewInCellKey = "kBottomOffsetFromLastViewInCellKey"

/**
 TableViewCell 使用 Masonry布局 自动计算 cell 行高 category
 
 -- UI布局必须放在UITableViewCell的初始化方法中：- initWithStyle:reuseIdentifier:
 */
public extension UITableViewCell {
    
    // 可选设置的属性，表示cell的高度需要从指定的lastViewInCell需要偏移多少，默认为0，小于0也为0
    @objc var sz_bottomOffsetFromLastViewInCell: CGFloat {
        
        get {
            
            if let number = objc_getAssociatedObject(self, &kBottomOffsetFromLastViewInCellKey) as? NSNumber {
                
                return CGFloat(number.floatValue)
            }
            
            return 0.0
        }
        
        set {
            
            objc_setAssociatedObject(self, &kBottomOffsetFromLastViewInCellKey, NSNumber(value: Float(newValue)), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 所指定的距离cell底部较近的参考视图，必须指定，若不指定则会assert失败
    public var sz_lastViewInCell: UIView? {
        
        get {
            
            let lastView = objc_getAssociatedObject(self, &kLastViewInCellKey)
            
            return lastView as? UIView
        }
        
        set {
            
            objc_setAssociatedObject(self, &kLastViewInCellKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 带缓存功能，自动计算行高
    ///
    /// - Parameters:
    ///   - tableView: 目标tableview
    ///   - config:    计算行高配置回调
    ///   - cache:     缓存参数（key，唯一指定key【可以是model的id，或者model的JSONString】，stateKey，行高状态【可选】，shouldUpdate，【可选，默认false，是否要更新指定stateKey中缓存高度，若为true, 不管有没有缓存，都会重新计算）
    /// - Returns: 行高
    public class func sz_cellHeight(forTableView tableView: UITableView,
                                     config: ((_ cell: UITableViewCell) -> Void)?,
                                     updateCacheIfNeeded cache: (() -> (key: String, stateKey: String?, shouldUpdate: Bool?))?) -> CGFloat {
        
        if let cacheBlock = cache {
            
            let keyGroup     = cacheBlock()
            let key          = keyGroup.key
            let stateKey     = keyGroup.stateKey ?? kSnapKitCellCacheStateDefaultKey
            let shouldUpdate = keyGroup.shouldUpdate ?? false
            
            if shouldUpdate == false {
                
                if let cacheDict = tableView.sz_cacheHeightDictionary,
                    let stateDict = cacheDict[key] as? NSMutableDictionary, // 状态高度缓存
                    let height = stateDict[stateKey] as? NSNumber {
                    
                    if height.intValue != 0 {
                        return CGFloat(height.floatValue)
                    }
                }
            }
        }
        
        let className = self.description()
        var cell = tableView.sz_cacheCellDictionary?.object(forKey: className) as? UITableViewCell
        
        if cell == nil {
            
            cell = self.init(style: .default, reuseIdentifier: nil)
            tableView.sz_cacheCellDictionary?.setObject(cell!, forKey: className as NSCopying)
        }
        
        if let block = config { block(cell!) }
        
        return cell!.sz_calculateCellHeight(forTableView: tableView, updateCacheIfNeeded: cache)
    }
    
    /// 获取缓存高度并缓存
    ///
    /// - Parameters:
    ///   - tableView: 目标tableview
    ///   - cache:     缓存参数
    /// - Returns: 高度
    private func sz_calculateCellHeight(forTableView tableView: UITableView,
                                         updateCacheIfNeeded cache: (() -> (key: String, stateKey: String?, shouldUpdate: Bool?))?) -> CGFloat {
        
        assert(self.sz_lastViewInCell != nil, "sz_lastViewInCell property can't be nil")
        
        layoutIfNeeded()
        
        var height = self.sz_lastViewInCell!.frame.origin.y + self.sz_lastViewInCell!.frame.size.height
        
        height += self.sz_bottomOffsetFromLastViewInCell
        
        if let cacheBlock = cache {
            
            let keyGroup = cacheBlock()
            let key      = keyGroup.key
            let stateKey = keyGroup.stateKey ?? kSnapKitCellCacheStateDefaultKey
            
            if let cacheDict = tableView.sz_cacheHeightDictionary {
                
                // 状态高度缓存
                let stateDict = cacheDict[key] as? NSMutableDictionary
                
                if stateDict != nil {
                    
                    stateDict?[stateKey] = NSNumber(value: Float(height))
                    
                } else {
                    
                    cacheDict[key] = NSMutableDictionary(object: NSNumber(value: Float(height)), forKey: stateKey as NSCopying)
                }
            }
        }
        
        return height
    }
}
