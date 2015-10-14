//
//  ZoomingIconTransition.swift
//  ZoomingIcons
//
//  Created by Derrick Park on 2015-10-01.
//  Copyright © 2015 dspAPP. All rights reserved.
//

import UIKit

private let kZoomingIconTransitionDuration: NSTimeInterval = 1

class ZoomingIconTransition: NSObject, UIViewControllerAnimatedTransitioning, UINavigationControllerDelegate {

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        
        return kZoomingIconTransitionDuration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let duration = transitionDuration(transitionContext)
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let containerView = transitionContext.containerView()
  
        // setup animation
        containerView!.addSubview(fromViewController.view)
        containerView!.addSubview(toViewController.view)
        toViewController.view.alpha = 0
        
        // perform animation
        
        UIView.animateWithDuration(duration, animations: { () -> Void in
            
            toViewController.view.alpha = 1
            }) { (done) -> Void in
                // completion block (have to let this know that animation is done in order to be able to use button.
                // because the containerView is covering all the subviews
                transitionContext.completeTransition(true)
        }
        
    
    }
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return self
        
    }
    
}
