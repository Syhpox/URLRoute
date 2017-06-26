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
        
        Navigator.register("testApp://test1", action: .present) { (data) in
            return TestViewController()
        }
        
        // test 内链
        Navigator.register("testApp://test") { (data) in
            return TestViewController()
        }


    }
}
