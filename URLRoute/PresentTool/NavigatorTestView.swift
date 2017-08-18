//
//  NavigatorTestView.swift
//  URLRoute
//
//  Created by WZH on 2017/8/16.
//  Copyright © 2017年 Zhihua. All rights reserved.
//  仅用于测试

import UIKit

class NavigatorTestView: PresentCustomView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.translatesAutoresizingMaskIntoConstraints = false
        
        let btn2 = UIButton.init(type: .system)
        btn2.translatesAutoresizingMaskIntoConstraints = false
//        btn2.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        btn2.backgroundColor = .lightGray
        btn2.setTitle("dismiss", for: .normal)
        btn2.setTitleColor(.black, for: .normal)
        self.addSubview(btn2)
        btn2.addTarget(self, action: #selector(btnClick2), for: .touchUpInside)
        let h = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[btn2(100)]", options: NSLayoutFormatOptions.alignmentMask, metrics: nil, views: ["btn2":btn2])
        let v = NSLayoutConstraint.constraints(withVisualFormat: "V:|-100-[btn2(50)]", options: NSLayoutFormatOptions.alignmentMask, metrics: nil, views: ["btn2":btn2])
        self.addConstraints(h)
        self.addConstraints(v)
    }
    
    func btnClick2() {
        UIViewController.topMost?.dismiss(animated: true, completion: nil)
    }
    
    override func animatedBegin() {
        self.frame = CGRect(x: 0, y: 200, width: 200, height: 200)
    }
    
    override func animated() {
        self.frame = CGRect(x: 0, y: 400, width: 200, height: 200)
    }
    
    override func animatedDismiss() {
        self.frame = CGRect(x: 100, y: 400, width: 200, height: 200)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
