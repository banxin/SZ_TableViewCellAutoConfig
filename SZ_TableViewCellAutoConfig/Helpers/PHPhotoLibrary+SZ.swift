//
//  PHPhotoLibrary+SZ.swift
//  SZ_RxProDemo
//
//  Created by 山竹 on 2018/10/17.
//  Copyright © 2018年 SZ. All rights reserved.
//

import Foundation
import Photos

import RxSwift

// MARK: - PHPhotoLibrary 扩展
extension PHPhotoLibrary {
    
    /// 是否有相册访问权，如果没有，则请求
    static var isAuthorized: Observable<Bool> {
        
        return Observable.create({ (observer) -> Disposable in
            
            DispatchQueue.main.async {
                
                if authorizationStatus() == .authorized {
                    
                    observer.onNext(true)
                    observer.onCompleted()
                    
                } else {
                    
                    observer.onNext(false)
                    
                    requestAuthorization({ (status) in
                        
                        observer.onNext(status == .authorized)
                        observer.onCompleted()
                    })
                }
            }
            
            return Disposables.create()
        })
    }
}
