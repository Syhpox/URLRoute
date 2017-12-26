//
//  FourViewController.swift
//  URLRoute
//
//  Created by WZH on 2017/8/16.
//  Copyright © 2017年 Zhihua. All rights reserved.
//

import UIKit

class FourViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Four"
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .gray
        
        let btn = UIButton.init(type: .system)
        btn.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
        btn.backgroundColor = .lightGray
        btn.setTitle("Present CustomVC", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        self.view.addSubview(btn)
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        
    }
    func btnClick() {
        
        let testVC = CustomViewController.init(presentingVC: self)
        self.present(testVC, animated: true) {
            print(testVC.presentConfig)
        }
//        self.present(testVC, animated: true, completion: nil)
    }
    
    deinit {
        print(type(of: self).description() + "释放deinit")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
