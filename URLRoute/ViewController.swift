//
//  ViewController.swift
//  URLRoute
//
//  Created by WZH on 2017/6/22.
//  Copyright © 2017年 Zhihua. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = .gray
        
        let btn = UIButton.init(type: .system)
        btn.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
        btn.backgroundColor = .lightGray
        btn.setTitle("WebURL_https", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        self.view.addSubview(btn)
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        
        
        let btn1 = UIButton.init(type: .system)
        btn1.frame = CGRect(x: 100, y: 200, width: 200, height: 50)
        btn1.backgroundColor = .lightGray
        btn1.setTitle("app内链TestViewController", for: .normal)
        btn1.setTitleColor(.black, for: .normal)
        self.view.addSubview(btn1)
        btn1.addTarget(self, action: #selector(btnClick1), for: .touchUpInside)
        
        let btn2 = UIButton.init(type: .system)
        btn2.frame = CGRect(x: 100, y: 300, width: 200, height: 50)
        btn2.backgroundColor = .lightGray
        btn2.setTitle("app内链alertVC", for: .normal)
        btn2.setTitleColor(.black, for: .normal)
        self.view.addSubview(btn2)
        btn2.addTarget(self, action: #selector(btnClick2), for: .touchUpInside)
        
        
    }
    
    func btnClick() {
        Navigator.show("https://www.baidu.com", title: "网页")
    }
    
    func btnClick1() {
        Navigator.show("testApp://test1", title: "内链Test")
    }
    
    func btnClick2() {
        Navigator.show("testApp://alert")
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

