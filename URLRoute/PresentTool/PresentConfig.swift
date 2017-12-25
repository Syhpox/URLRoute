//
//  PresentConfig.swift
//  URLRoute
//
//  Created by WZH on 2017/12/22.
//  Copyright © 2017年 Zhihua. All rights reserved.
//  PresentConfig v2.0

import UIKit
/// required protocol
protocol PresentConfigProtocol  {
    var presentConfig: PresentConfig? {get set}
    /*
     required init(presentingVC: UIViewController) {
     super.init(nibName: nil, bundle: nil)
     presentConfig = PresentConfig.init(self, presentingVC: presentingVC)
     }
     */
    init(presentingVC: UIViewController)
    
}

/// 自定义弹出动画接口协议
protocol PresentConfigAnimationProtocol {
    /// 刚弹出  动画初始状态
    func animatedBegin()
    /// 刚弹出  动画末状态
    func animated()
    /// 弹回消失 动画末状态
    func animatedDismiss()
}

/// 动画样式
enum PresentConfigAnimation {
    case alert          // 系统Alert样式
    case actionSheet    // 系统actionSheet样式
    
    case toUp         // 下到上
    case fade           // fade 透明度
    
    case custom(PresentConfigAnimationProtocol)
}

class PresentConfig {
    /// 核心视图
    var mainView: UIView!
    
    /// main_VC 被弹出的VC
    var mainViewController: UIViewController!
    
    /// present代理
    fileprivate var delegate: PresentConfigPresentationController!
    
    /// 动画类型
    var animationType: PresentConfigAnimation = .alert
    
    /// 动画持续时间
    var duration: TimeInterval!
    
    /**
     初始化方法
     - paramater mainViewController: 被弹出的VC
     - paramater presentingVC:       弹出的VC
     - paramater type:               动画类型
     - paramater duration:           动画时间 = present时间 = dismiss时间
     
     - retrun
     */
    init(_ mainViewController: UIViewController,presentingVC: UIViewController, type: PresentConfigAnimation = .alert, duration: TimeInterval = 0.35) {
        self.mainViewController = mainViewController
        self.delegate = PresentConfigPresentationController.init(presentConfig: self, presenting: presentingVC)
        mainViewController.transitioningDelegate = delegate
        self.animationType = type
        self.duration = duration
        // Custom初始化失败
        switch type {
        case .custom(let mainView):
            if let vi = mainView as? UIView {
                self.mainView = vi
            } else {
                assertionFailure("自定义动画view非UIView类")
            }
            break
        default:
            break;
        }
    }
}


fileprivate class PresentConfigPresentationController: UIPresentationController, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    fileprivate var bgView: UIView!
    fileprivate weak var presentConfig: PresentConfig!
    
    init(presentConfig: PresentConfig, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentConfig.mainViewController, presenting: presentingViewController)
        self.presentConfig = presentConfig
        self.presentConfig.mainViewController.modalPresentationStyle = .custom
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
        self.presentingViewController.transitionCoordinator?.animate(alongsideTransition: {[weak self] (context) in
            self?.bgView.alpha = 0.0
            }, completion: {[weak self] (context) in
                // 内存释放
                self?.presentConfig.mainViewController = nil
                self?.presentConfig.delegate = nil
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
        return presentConfig.duration
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
        //        var fromViewFinalFrame = transitionContext.finalFrame(for: fromVC!)
        //        var toViewInitFrame = transitionContext.initialFrame(for: toVC!)
        let toViewFinalFrame = transitionContext.finalFrame(for: toVC!)
        
        containView.addSubview(isPresenting ? toView : fromView)
        
        let normalFrame = CGRect(origin: CGPoint(x: containView.bounds.minX, y: containView.bounds.minY), size: toViewFinalFrame.size)
        if isPresenting {
            toView.frame = normalFrame
        } else {
            fromView.frame = normalFrame
        }
        
        // 动画时间
        let duration = presentConfig.duration
        
        switch presentConfig.animationType {
        case .alert:
            if isPresenting {
                presentConfig.mainView.center = CGPoint(x: presentConfig.mainViewController.view.frame.width / 2.0, y: presentConfig.mainViewController.view.frame.height / 2.0)
                presentConfig.mainView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            }
        case .actionSheet:
            let frameHeight = presentConfig.mainViewController.view.frame.height
            let frameWidth = presentConfig.mainViewController.view.frame.width
            if isPresenting {
                presentConfig.mainView.frame = CGRect(x: (frameWidth - presentConfig.mainView.frame.width) / 2.0, y: frameHeight, width: presentConfig.mainView.frame.width, height: presentConfig.mainView.frame.height)
            } else {
                self.presentConfig.mainView.frame = CGRect(x: self.presentConfig.mainView.frame.origin.x, y: frameHeight - self.presentConfig.mainView.frame.height, width: self.presentConfig.mainView.frame.width, height: self.presentConfig.mainView.frame.height)
            }
        case .toUp:
            let changeY = isPresenting ? normalFrame.size.height + self.presentConfig.mainView.frame.size.height / 2.0 : normalFrame.size.height / 2.0
            presentConfig.mainView.center = CGPoint(x: normalFrame.size.width / 2.0, y: changeY)
        case .fade:
            (isPresenting ? toView : fromView)?.alpha = isPresenting ? 0.0 : 1.0
            
            presentConfig.mainView.center = CGPoint(x: presentConfig.mainViewController.view.frame.width / 2.0, y: presentConfig.mainViewController.view.frame.height / 2.0)
        case .custom(let animationView):
            if isPresenting {
                animationView.animatedBegin()
            } else {
                animationView.animated()
            }
        }
        
        // 动画中
        UIView.animate(withDuration: duration ?? 0.35, animations: {
            switch self.presentConfig.animationType {
            case .alert:
                (isPresenting ? toView : fromView)?.alpha = isPresenting ? 1.0 : 0.0
                if isPresenting {
                    self.presentConfig.mainView.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
                }
            case .actionSheet:
                let frameHeight = self.presentConfig.mainViewController.view.frame.height
                let frameWidth = self.presentConfig.mainViewController.view.frame.width
                if !isPresenting {
                    self.presentConfig.mainView.frame = CGRect(x: (frameWidth - self.presentConfig.mainView.frame.width) / 2.0, y: frameHeight, width: self.presentConfig.mainView.frame.width, height: self.presentConfig.mainView.frame.height)
                } else {
                    self.presentConfig.mainView.frame = CGRect(x: self.presentConfig.mainView.frame.origin.x, y: frameHeight - self.presentConfig.mainView.frame.height, width: self.presentConfig.mainView.frame.width, height: self.presentConfig.mainView.frame.height)
                }
                
            case .toUp:
                if isPresenting {
                    self.presentConfig.mainView.center = CGPoint(x: normalFrame.size.width / 2.0, y: normalFrame.size.height / 2.0)
                } else {
                    self.presentConfig.mainView.center = CGPoint(x: normalFrame.size.width / 2.0, y: normalFrame.size.height + self.presentConfig.mainView.frame.size.height / 2.0)
                }
            case .fade:
                (isPresenting ? toView : fromView)?.alpha = isPresenting ? 1.0 : 0.0
            case .custom(let animationView):
                if isPresenting {
                    animationView.animated()
                } else {
                    animationView.animatedDismiss()
                }
            }
            
        }) { (finish) in
            let cancel = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!cancel)
        }
        
    }
    
}

