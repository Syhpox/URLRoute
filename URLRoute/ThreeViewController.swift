//
//  ThreeViewController.swift
//  URLRoute
//
//  Created by WZH on 2017/8/12.
//  Copyright © 2017年 Zhihua. All rights reserved.
//

import UIKit

class ThreeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Three"

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .gray
        
        let btn = UIButton.init(type: .system)
        btn.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
        btn.backgroundColor = .lightGray
        btn.setTitle("present VC", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        self.view.addSubview(btn)
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)

    }
    func btnClick() {
        Navigator.show("testApp://test1", title: "内链Test")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
