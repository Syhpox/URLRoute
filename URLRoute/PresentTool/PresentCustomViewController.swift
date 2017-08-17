//
//  URLNavigatorViewController.swift
//  URLRoute
//
//  Created by WZH on 2017/8/14.
//  Copyright © 2017年 Zhihua. All rights reserved.
//

import UIKit
enum PresentCustomViewControllerAnimation: Int {
    case system // 系统Alert样式
    case mode_0 // 下到上动画
    case mode_1 // fade 透明度
}

class PresentCustomViewController: UIViewController {
    /// 核心视图
    fileprivate var mainView: UIView!
    
    /// present代理
    fileprivate var delegate: PresentCustomPresentationController!
    
    /// 动画类型
    var animateType: PresentCustomViewControllerAnimation = .system
    
    /// 动画持续时间
    var duration: TimeInterval!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(_ mainView: UIView, type: PresentCustomViewControllerAnimation = .system, duration: TimeInterval = 0.35) {
        self.init(nibName: nil, bundle: nil)
        self.delegate = PresentCustomPresentationController.init(presentedVC: self, presenting: UIViewController.topMost)
        self.transitioningDelegate = self.delegate
        self.mainView = mainView
        self.animateType = type
        self.duration = duration
        
        mainView.center = CGPoint(x: self.view.frame.width / 2.0, y: self.view.frame.height / 2.0)
        view.addSubview(mainView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func present() {
        UIViewController.topMost?.present(self, animated: true, completion: nil)
    }
}

fileprivate class PresentCustomPresentationController: UIPresentationController, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    fileprivate var bgView: UIView!
    fileprivate var presentedVC: PresentCustomViewController!
    
    private override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        presentedViewController.modalPresentationStyle = .custom
    }
    
    convenience init(presentedVC: PresentCustomViewController, presenting presentingVC: UIViewController?) {
        self.init(presentedViewController: presentedVC, presenting: presentingVC)
        self.presentedVC = presentedVC
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
        // 动画时间
        return presentedVC.duration
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
        
        // 动画时间
        let duration = presentedVC.duration

        switch presentedVC.animateType {
        case .system:
            if isPresenting {
                toView.frame = toViewFinalFrame
                toView.alpha = 0.0
            } else {
                fromView.frame = fromViewFinalFrame
                fromView.alpha = 1.0
            }
            presentedVC.mainView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        case .mode_0: break
        case .mode_1:
            if isPresenting {
                toView.frame = toViewFinalFrame
                toView.alpha = 0.0
            } else {
                fromView.frame = fromViewFinalFrame
                fromView.alpha = 1.0
            }

        }
        
        UIView.animate(withDuration: duration ?? 0.35, animations: {
            switch self.presentedVC.animateType {
            case .system:
                self.presentedVC.mainView.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
                (isPresenting ? toView : fromView)?.alpha = isPresenting ? 1.0 : 0.0
            case .mode_0:
                if isPresenting {
                    toView.frame = toViewFinalFrame
                } else {
                    fromView.frame = fromViewFinalFrame
                }
            case .mode_1:
                (isPresenting ? toView : fromView)?.alpha = isPresenting ? 1.0 : 0.0
            }

        }) { (finish) in
            let cancel = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!cancel)
        }
        
    }


}
















