//
//  CustomViewController.swift
//  URLRoute
//
//  Created by WZH on 2017/9/20.
//  Copyright © 2017年 Zhihua. All rights reserved.
//

import UIKit

class CustomViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let test = UIView.init(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        test.backgroundColor = .blue
        self.view.addSubview(test)
        
        let btn = UIButton.init(type: .system)
        btn.setTitle("dismiss", for: .normal)
        btn.frame = CGRect(x: 100, y: 200, width: 60, height: 30)
        test.addSubview(btn)
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
    }
    
    @objc func btnClick() {
        self.dismiss(animated: true, completion: nil)
    }
    
    deinit {
        print(type(of: self).description() + "   deinit")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
