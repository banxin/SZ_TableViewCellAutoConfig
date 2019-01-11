//
//  HUD+SZ.swift
//  SZ_RxProDemo
//
//  Created by 山竹 on 2018/11/19.
//  Copyright © 2018年 SZ. All rights reserved.
//

import RxSwift

import SVProgressHUD

public enum HUDShowStatus {
    
    case nextOrSuccess
    case subscribed
}

public extension ObservableType {
    
    func showHUD(when type:  HUDShowStatus,
                 with message: String? = nil,
                 userInteractionEnabled isEnabled: Bool = true) -> Observable<E> {
        return self.do(onNext: { _ in
            if type == .nextOrSuccess {
                HUD.show(with: message, userInteractionEnabled: isEnabled)
            }
        }, onSubscribed: {
            if type == .subscribed {
                HUD.show(with: message, userInteractionEnabled: isEnabled)
            }
        })
    }
    
    func showErrorHUD(with message: String? = nil) -> Observable<E> {
        return self.do(onError: { error in
            if let message = message {
                HUD.showError(with: message)
            } else if !error.localizedDescription.isEmpty {
                HUD.showError(with: error.localizedDescription)
            } else {
                HUD.dismiss()
            }
        })
    }
}

@objc public protocol ApplicationDidFinishLaunchingProcessProtocol {
    
    @objc static func didFinishLaunchingProcess(launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
}

public class HUD: ApplicationDidFinishLaunchingProcessProtocol {
    
    private init() {}
    
    public static func didFinishLaunchingProcess(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setMinimumDismissTimeInterval(2)
    }
}

public extension HUD {
    class func show(with message: String? = nil, userInteractionEnabled isEnabled: Bool = true) {
        SVProgressHUD.userInteractionEnabled(isEnabled)
        if let message = message {
            SVProgressHUD.show(withStatus: message)
        } else {
            SVProgressHUD.show()
        }
    }
    
    class func showSuccess(with message: String? = nil) {
        SVProgressHUD.userInteractionEnabled(true)
        SVProgressHUD.showSuccess(withStatus: message)
    }
    
    class func showError(with message: String? = nil) {
        SVProgressHUD.userInteractionEnabled(true)
        SVProgressHUD.showError(withStatus: message)
    }
    
    class func showInfo(with message: String? = nil) {
        SVProgressHUD.userInteractionEnabled(true)
        SVProgressHUD.showInfo(withStatus: message)
    }
    
    class func dismiss() {
        SVProgressHUD.userInteractionEnabled(true)
        SVProgressHUD.dismiss()
    }
}

private extension SVProgressHUD {
    class func userInteractionEnabled(_ isEnabled: Bool) {
        if isEnabled {
            SVProgressHUD.setDefaultMaskType(.none)
        } else {
            SVProgressHUD.setDefaultMaskType(.clear)
        }
    }
}

