//
//  CustomAnimator.swift
//  Mp3App
//
//  Created by AnhLD on 9/29/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import UIKit

class CustomAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    enum TransitionType {
        case navigation
        case modal
    }
    
    let type: TransitionType
    let duration: TimeInterval
    
    init(type: TransitionType, duration: TimeInterval = 0.2) {
        self.type = type
        self.duration = duration
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        fatalError("You have to implement this method for yourself!")
    }
}
