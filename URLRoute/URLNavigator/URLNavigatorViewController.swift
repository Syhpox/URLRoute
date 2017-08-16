//
//  URLNavigatorViewController.swift
//  URLRoute
//
//  Created by WZH on 2017/8/14.
//  Copyright © 2017年 Zhihua. All rights reserved.
//

import UIKit

class URLNavigatorViewController: UIViewController {
    var mainView: UIView!
    var delegate: NavigatorPresentationController!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(_ mainView: UIView) {
        self.init(nibName: nil, bundle: nil)
        self.delegate = NavigatorPresentationController.init(presentedViewController: self, presenting: UIViewController.topMost)
        self.transitioningDelegate = self.delegate
        self.mainView = mainView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        mainView.center = CGPoint(x: self.view.frame.width / 2.0, y: self.view.frame.height / 2.0)
        view.addSubview(mainView)
        
//        let btn2 = UIButton.init(type: .system)
//        btn2.frame = CGRect(x: 100, y: 300, width: 200, height: 50)
//        btn2.backgroundColor = .lightGray
//        btn2.setTitle("dismiss", for: .normal)
//        btn2.setTitleColor(.black, for: .normal)
//        self.view.addSubview(btn2)
//        btn2.addTarget(self, action: #selector(btnClick2), for: .touchUpInside)
    }
    
    func btnClick2() {
//        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class NavigatorPresentationController: UIPresentationController, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    fileprivate var bgView: UIView!
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        presentedViewController.modalPresentationStyle = .custom
    }
    
    
    override func presentationTransitionWillBegin() {
        bgView = UIView.init(frame: (containerView?.bounds)!)
        bgView.backgroundColor = UIColor.init(white: 0.0, alpha: 0.5)
        containerView?.addSubview(bgView)
        bgView.alpha = 0.0
        presentingViewController.transitionCoordinator?.animate(alongsideTransition: {[weak self] (context) in
            self?.bgView.alpha = 1.0
            }, completion: { (context) in
                
        })
    }
    
    /// dismiss刚开始
    override func dismissalTransitionWillBegin() {
        presentingViewController.transitionCoordinator?.animate(alongsideTransition: {[weak self] (context) in
            self?.bgView.alpha = 0.0
            }, completion: { (context) in
        })
    }

    // MARK: UIViewControllerTransitioningDelegate
    @available(iOS 2.0, *)
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return self
    }
    
    // MARK: UIViewControllerAnimatedTransitioning
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }
    
    // This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: .from)
        let toVC = transitionContext.viewController(forKey: .to)
        
        let containView = transitionContext.containerView
        
        let fromView: UIView! = transitionContext.view(forKey: .from)
        let toView: UIView! = transitionContext.view(forKey: .to)
        
        let isPresenting = fromVC == self.presentingViewController
//        let fromViewInitFrame = transitionContext.initialFrame(for: fromVC!)
        var fromViewFinalFrame = transitionContext.finalFrame(for: fromVC!)
        var toViewInitFrame = transitionContext.initialFrame(for: toVC!)
        let toViewFinalFrame = transitionContext.finalFrame(for: toVC!)
        
        containView.addSubview(isPresenting ? toView : fromView)
        
        if isPresenting {
            toViewInitFrame.origin = CGPoint(x: containView.bounds.minX, y: containView.bounds.maxY)
            toViewInitFrame.size = toViewFinalFrame.size
            toView.frame = toViewInitFrame
        } else {
            fromViewFinalFrame = fromView.frame.offsetBy(dx: 0, dy: fromView.frame.height)
        }
        
        
//        fromView.alpha = 1.0
//        toView.alpha = 0.0
        
        let duration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: {
//            fromView.alpha = 0
//            toView.alpha = 1.0
            if isPresenting {
                toView.frame = toViewFinalFrame
            } else {
                fromView.frame = fromViewFinalFrame
            }
        }) { (finish) in
            let cancel = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!cancel)
        }
        
    }


}
















