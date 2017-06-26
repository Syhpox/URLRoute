//
//  WebViewController.swift
//  URLRoute
//
//  Created by WZH on 2017/6/22.
//  Copyright © 2017年 Zhihua. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    var urlString: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        guard let url = URL(string: self.urlString ?? "") else {
            return
        }
        
        let webView = UIWebView()
        webView.frame = self.view.frame
        self.view.addSubview(webView)
        
        webView.loadRequest(URLRequest.init(url: url))
        
    }

    init(_ urlString: String) {
        super.init(nibName: nil, bundle: nil)
        self.urlString = urlString
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
