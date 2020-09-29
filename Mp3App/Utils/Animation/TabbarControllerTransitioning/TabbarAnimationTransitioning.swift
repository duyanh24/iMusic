//
//  TabbarAnimationTransitioning.swift
//  Mp3App
//
//  Created by AnhLD on 9/29/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import UIKit

final class TabBarFadedAnimationTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let destination = transitionContext.view(forKey: .to)
            else {
                return
        }

        destination.alpha = 0.0
        transitionContext.containerView.addSubview(destination)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            destination.alpha = 1.0
        }, completion: {
            transitionContext.completeTransition($0)
        })
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.15
    }
}
