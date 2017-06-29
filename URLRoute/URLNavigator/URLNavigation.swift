//
//  URLNavigation.swift
//  HiveConsumer
//
//  Created by WZH on 2017/6/8.
//  Copyright © 2017年 Zhihua. All rights reserved.
//

import UIKit

let Navigator = URLNavigator.default

class URLNavigator {
    /// 单例
    open static let `default` = URLNavigator()
    /// 映射数组  key : pattern
    fileprivate var mapDic: [String: URLNavigationPattern] = [:]
    /// 完成回调
    typealias URLCompleteHandler = (URLNavigatorData) -> Void

    /// 注册 key handler
    func register(_ url: String, action: URLNavigatorAction = .push, handler: @escaping ((URLNavigatorData) -> UIViewController?)) {
        var pattern = URLNavigationPattern.analysis(url, handler: handler)
        guard self.mapDic[pattern.key!] == nil else {
            print("\(pattern.key!)注册重复!!! 注册失败")
            return
        }
        pattern.navigatorAction = action
        self.mapDic[pattern.key!] = pattern
    }
    
    @discardableResult
    func show(_ url: String?, animated: Bool = true, type: URLNavigatorContext = .click, complete: URLCompleteHandler? = nil) -> Bool {
        guard url != nil && url != "" else {
            print("url 为空或者空字符串！！！push失败")
            return false
        }
        
        let urlData = URLAnalysis.analysis(url!)
        guard urlData.scheme != nil && urlData.key != nil else {
            print("url不合法 解析协议或key失败！！！push失败")
            return false
        }
        
        if let patternItem = mapDic[urlData.key!] {
            var currentVC = UIViewController.topMost
            guard currentVC != nil else {
                print("获取顶层ViewController失败！！！push失败")
                return false
            }
            
            // 使用场景
            if type == .push {
                // 推送 回到首页
                currentVC?.tabBarController?.selectedIndex = 0
                let currentVC_tab = UIViewController.topMost
                currentVC_tab?.navigationController?.popToRootViewController(animated: false)
                currentVC = UIViewController.topMost
            }
            
            guard currentVC != nil else {
                print("获取顶层ViewController失败！！！push失败")
                return false
            }

            if let hander = patternItem.handler {
                if let vc = hander(urlData) {
                    
                    switch patternItem.navigatorAction! {
                    case .push:
                        currentVC?.navigationController?.pushViewController(vc, animated: animated)
                    case .present:
                        currentVC?.present(vc, animated: animated, completion: nil)
                    case .custom:
                        print("暂时不加")
                    }
                }
            }
            
            if let clouse = complete {
                clouse(urlData)
            }
            return true
        } else {
            print("未注册的key！！！导航失败")
        }
        
        return false
    }
    
    
    
//    func present(_ url: String?, animated: Bool = true, type: URLNavigatorContext = .click)
    
    
    
    
    
}

// URLNavigator使用场景
enum URLNavigatorContext {
    case push    // 推送
    case click   // 点击
}

// URLNavigator导航行为
enum URLNavigatorAction {
    case push
    case present
    case custom
}

extension UIViewController {
    
    /// Returns the current application's top most view controller.
    open class var topMost: UIViewController? {
        var rootViewController: UIViewController?
        let currentWindows = UIApplication.shared.windows
        
        for window in currentWindows {
            if let windowRootViewController = window.rootViewController {
                rootViewController = windowRootViewController
                break
            }
        }
        
        return self.topMost(of: rootViewController)
    }
    
    /// Returns the top most view controller from given view controller's stack.
    open class func topMost(of viewController: UIViewController?) -> UIViewController? {
        // UITabBarController
        if let tabBarController = viewController as? UITabBarController,
            let selectedViewController = tabBarController.selectedViewController {
            return self.topMost(of: selectedViewController)
        }
        
        // UINavigationController
        if let navigationController = viewController as? UINavigationController,
            let visibleViewController = navigationController.visibleViewController {
            return self.topMost(of: visibleViewController)
        }
        
        // presented view controller
        if let presentedViewController = viewController?.presentedViewController {
            return self.topMost(of: presentedViewController)
        }
        
        // child view controller
        for subview in viewController?.view?.subviews ?? [] {
            if let childViewController = subview.next as? UIViewController {
                return self.topMost(of: childViewController)
            }
        }
        
        return viewController
    }
    
}




