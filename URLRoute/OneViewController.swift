//
//  OneViewController.swift
//  URLRoute
//
//  Created by WZH on 2017/8/12.
//  Copyright © 2017年 Zhihua. All rights reserved.
//

import UIKit

class OneViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "One"
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .gray
        
        let btn = UIButton.init(type: .system)
        btn.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
        btn.backgroundColor = .lightGray
        btn.setTitle("自定义Alert", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        self.view.addSubview(btn)
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        
    }
    
    func btnClick() {
        let vc = FourViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
//        let testVC = CustomViewController.init(presentingVC: self)
//        self.present(testVC, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
