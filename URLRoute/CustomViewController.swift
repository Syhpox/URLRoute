//
//  CustomViewController.swift
//  URLRoute
//
//  Created by WZH on 2017/9/20.
//  Copyright © 2017年 Zhihua. All rights reserved.
//

import UIKit

class CustomViewController: PresentionBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.animationType = .actionSheet
        // Do any additional setup after loading the view.
        let test = UIView.init(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        test.backgroundColor = .blue
        self.view.addSubview(test)
        self.mainView = test
        
        let btn = UIButton.init(type: .system)
        btn.setTitle("dismiss", for: .normal)
        btn.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        test.addSubview(btn)
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        
    }
    
    @objc func btnClick() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
