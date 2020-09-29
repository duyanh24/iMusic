//
//  FadePushAnimator.swift
//  Mp3App
//
//  Created by AnhLD on 9/29/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import UIKit

class FadePushAnimator: CustomAnimator {
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toViewController = transitionContext.viewController(forKey: .to)
            else {
                return
        }
        transitionContext.containerView.addSubview(toViewController.view)
        toViewController.view.alpha = 0
        toViewController.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        let duration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: {
            toViewController.view.alpha = 1
            toViewController.view.transform = .identity
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
