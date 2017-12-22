//
//  SYHPresentProtocol.swift
//  URLRoute
//
//  Created by WZH on 2017/12/20.
//  Copyright © 2017年 Zhihua. All rights reserved.
//

import UIKit

protocol SYHPresentProtocol {
    /// 核心视图
    var mainCView: UIView {get set}
//
//    var presentingVC: T
//    /// present代理
//    var delegate: PresentCustomPresentationController {get set}
//
//    /// 动画类型
//    var animationType: PresentCustomViewControllerAnimation {get set}
//
//    /// 动画持续时间
//    var duration: TimeInterval{get set}
//
//    /// 结束block
//    var completeBlc:(() -> Void) {get set}


}
/*
extension SYHPresentProtocol {
    
    /// present代理
    var delegate: PresentCustomPresentationController
    
    /// 动画类型
    var animationType: PresentCustomViewControllerAnimation = .alert
    
    /// 动画持续时间
    var duration: TimeInterval!
    
    /// 结束block
    var completeBlc:(() -> Void)?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init(presentingVC: UIViewController, type: PresentCustomViewControllerAnimation = .alert, duration: TimeInterval = 0.35) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = PresentCustomPresentationController.init(presentedVC: self, presenting: presentingVC)
        self.transitioningDelegate = self.delegate
        self.animationType = type
        self.duration = duration
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.delegate = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag) {
            if completion != nil {
                completion!()
            }
            if let blc = self.completeBlc {
                blc()
            }
        }
    }

}
*/
