//
//  NavigationMap.swift
//  HiveConsumer
//
//  Created by WZH on 2017/6/9.
//  Copyright © 2017年 Zhihua. All rights reserved.
//

import UIKit

struct URLNavigationMap {
    
    /// 初始化映射表  fcredirect://express_delivery?param={"type":1}
    static func initialize() {
        
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


    }
}
