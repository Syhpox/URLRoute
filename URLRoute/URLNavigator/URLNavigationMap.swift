//
//  NavigationMap.swift
//  HiveConsumer
//
//  Created by WZH on 2017/6/9.
//  Copyright © 2017年 Zhihua. All rights reserved.
//

import UIKit
class URLNavigatorDelegate: NSObject {
    
}


struct URLNavigationMap {
    
    /// <scheme>://<user>:<password>@<host>:<port>/<path>;<params>?<query>#<frag>
    /// 初始化映射表  fcredirect://express_delivery?param={"type":1}
    static var delegate: URLNavigatorDelegate = URLNavigatorDelegate()

    static func initialize() {
//        Navigator.register(<#T##url: String##String#>, action: <#T##URLNavigatorAction#>, origin: <#T##URLNavigatorOrigin?#>, handler: <#T##((URLNavigatorData) -> UIViewController?)##((URLNavigatorData) -> UIViewController?)##(URLNavigatorData) -> UIViewController?#>)
        
        // web 外链
        Navigator.register("http://") { (data) in
            return WebViewController.init(data.urlString ?? "")
        }
        Navigator.register("https://") { (data) in
            return WebViewController.init(data.urlString ?? "")
        }
        
        // test 内链  默认push
        Navigator.register("testApp://test") { (data) in
            return TestViewController()
        }
        // 内链  present
        Navigator.register("testApp://test1", action: .present) { (data) in
            return TestViewController()
        }
        
        Navigator.register("testApp://test2", action: .push_pop, origin: .tabBar(2)) { (data) -> UIViewController? in
            return OneViewController()
        }
        
        // 内链
        Navigator.register("testApp://alert", action: .present) { (data) -> UIViewController? in
            let alertVC = UIAlertController.init(title: "测试内链Alert", message: "Hello World", preferredStyle: .alert)
            let ac0 = UIAlertAction.init(title: "cancel", style: .destructive, handler: nil)
            let ac1 = UIAlertAction.init(title: "ok", style: .default, handler: { (ac) in
                print(ac.title ?? "nil")
            })
            alertVC.addAction(ac0)
            alertVC.addAction(ac1)
            
            return alertVC
        }
        
        // 本地使用，不路由
        Navigator.register("testApp://urlNavigator", action: .present) { (data) -> UIViewController? in
            
            let view = NavigatorTestView.init(frame: .zero)
            view.backgroundColor = .brown
            view.frame = CGRect(x: 0, y: 100, width: 200, height: 200)
            let naVC = PresentCustomViewController.init(view, type: .alert)
            return naVC
        }

    }
}
