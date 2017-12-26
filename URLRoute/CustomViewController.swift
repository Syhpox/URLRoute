//
//  CustomViewController.swift
//  URLRoute
//
//  Created by WZH on 2017/9/20.
//  Copyright © 2017年 Zhihua. All rights reserved.
//

import UIKit

class CustomViewController: UIViewController, PresentConfigProtocol {
    var presentConfig: PresentConfig!
    
    required init(presentingVC: UIViewController) {
        super.init(nibName: nil, bundle: nil)
        presentConfig = PresentConfig.init(self, presentingVC: presentingVC)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presentConfig.animationType = .alert
        presentConfig.duration = 0.35
        
        let test = UIView.init(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        test.backgroundColor = .blue
        self.view.addSubview(test)
        presentConfig.mainView = test
        
        let btn = UIButton.init(type: .system)
        btn.setTitle("dismiss", for: .normal)
        btn.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
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
