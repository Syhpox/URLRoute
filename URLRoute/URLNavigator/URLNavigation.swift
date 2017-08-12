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
    func register(_ url: String, action: URLNavigatorAction = .push_pop, origin: URLNavigatorOrigin? = nil, handler: @escaping ((URLNavigatorData) -> UIViewController?)) {
        var pattern = URLNavigationPattern.analysis(url, handler: handler)
        assert(self.mapDic[pattern.key!] == nil, "\(pattern.key!)注册重复!!! 注册失败")
        pattern.navigatorAction = action
        pattern.navigatorOrigin = origin
        self.mapDic[pattern.key!] = pattern
    }
    
    @discardableResult
    func show(_ url: String?, type: URLNavigatorContext = .local, origin: URLNavigatorOrigin? = nil, action: URLNavigatorAction? = nil,title: String? = nil, localDic: [String: Any] = [:], animated: Bool = true, complete: URLCompleteHandler? = nil) -> Bool {
        // url 空判断
        guard url != nil && url != "" else {
            NavigatorError.emptyUrl.log()
            return false
        }
        // 解析url
        var urlData = URLAnalysis.analysis(url!)
        guard urlData.scheme != nil && urlData.key != nil else {
            NavigatorError.errorUrl.log()
            return false
        }
        // 获取本地注册的路由pattern
        if let patternItem = mapDic[urlData.key!] {
            var currentVC = UIViewController.topMost
            guard currentVC != nil else {
                NavigatorError.emptyVC.log()
                return false
            }
            
            // 起点
            if let available_origin = origin ?? patternItem.navigatorOrigin {
                switch available_origin {
                case .tabBar(let index):
                    if (currentVC?.tabBarController?.viewControllers?.count)! >= index + 1 {
                        currentVC?.tabBarController?.selectedIndex = index
                    } else {
                        NavigatorError.errorTabBar.log()
                    }
                }
            }
            
            // 使用场景
            switch type {
            case .local:
                currentVC = UIViewController.topMost
            case .global:
                let currentVC_tab = UIViewController.topMost
                currentVC_tab?.navigationController?.popToRootViewController(animated: false)
                currentVC = UIViewController.topMost
            }
            
            guard currentVC != nil else {
                NavigatorError.emptyVC.log()
                return false
            }
            
            if let hander = patternItem.handler {
                // vc title 统一处理
                urlData.localDic = localDic;
                if title != nil {
                    urlData.localDic["vc_title"] = title;
                }
                if let vc = hander(urlData) {
                    if let dicTitle = urlData.localDic["vc_title"] as? String {
                        vc.title = dicTitle
                    }
                    // 跳转方式 导航行为
                    let available_action = action ?? patternItem.navigatorAction
                    switch available_action! {
                    case .push_pop:
                        // 自动跳转  1.目标第一个 pop  2.非第一个 先popToRoot 再push
                        if (currentVC?.navigationController?.viewControllers.first?.isKind(of: vc.classForCoder))! {
                            currentVC?.navigationController?.popToRootViewController(animated: animated)
                        } else {
                            currentVC?.navigationController?.popToRootViewController(animated: false)
                            UIViewController.topMost?.navigationController?.pushViewController(vc, animated: animated)
                        }
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
            NavigatorError.errorKey.log()
        }
        
        return false
    }
}

enum NavigatorError: String {
    case emptyUrl = "[Navigator Error]: url 为空或者空字符串"
    case errorUrl = "[Navigator Error]: url不合法 解析协议或key失败"
    case emptyVC  = "[Navigator Error]: 获取顶层ViewController失败"
    case errorKey = "[Navigator Error]: 未注册的key"
    case errorTabBar = "[Navigator Error]: tabBar设置Index越界"
    func log() {
        print(self.rawValue)
    }
}

// URLNavigator使用场景  调用时申明
enum URLNavigatorContext {
    case local                              // 本地环境 以当前位置 进行转场              app当前所在vc已知 (本地固定代码位置）
    case global                             // 全局环境 一般用于推送,任意初始位置转场      app当前所在vc未知 (比如点击推送)
}

// URLNavigator导航时起点  注册时,调用时申明 其中优先级 调用时 > 注册时
enum URLNavigatorOrigin {
    case tabBar(Int) // 先选择TabbarIndex 1.目标第一个 pop  2.非第一个 先popToRoot 再push    不做：2.中间的 初始化新的再pop 3.最后一个 push新的  删除旧的  4.不存在 popToRoot 再push
}

// URLNavigator导航行为  注册时,调用时申明 其中优先级 调用时 > 注册时
enum URLNavigatorAction {
    case push_pop // 自动push pop(规则：1.目的vc在当前UINavigatorController中首位，popToRoot 2.非1条件，先popToRoot，再push目的vc)
    case push     // 直接push  用于本地
    case present  //
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




