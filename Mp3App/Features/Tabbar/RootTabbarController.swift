//
//  RootTabbarController.swift
//  Mp3App
//
//  Created by AnhLD on 9/29/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import UIKit
import Reusable

class RootTabbarController: UITabBarController, StoryboardBased {
    private var tabbarY: CGFloat!
    private let miniPlayerHeight: CGFloat = 52
    var playerView: PlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayerView()
        setupPanGesture()
        tabBar.isTranslucent = false
    }
    
    private func setupPlayerView() {
        playerView = PlayerView(frame: CGRect(x: 0,
                                              y: UIScreen.main.bounds.height - tabBar.frame.height - miniPlayerHeight,
                                              width: UIScreen.main.bounds.width,
                                              height: UIScreen.main.bounds.height + miniPlayerHeight))
        view.addSubview(playerView)
        view.bringSubviewToFront(tabBar)
        tabbarY = tabBar.frame.origin.y
    }
    
    private func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        playerView.addGestureRecognizer(panGesture)
        panGesture.maximumNumberOfTouches = 1
        panGesture.delegate = self
    }
    
    @objc func panGestureRecognizerAction(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let contentHeight = UIScreen.main.bounds.height - tabBar.frame.height - miniPlayerHeight
        switch gesture.state {
        case .began:
            playerView.isScrollEnabled(value: false)
        case .changed:
            let playerViewY = playerView.frame.origin.y
            if playerViewY <= contentHeight {
                if playerViewY + translation.y < 0 - miniPlayerHeight {
                    playerView.frame.origin.y = view.bounds.origin.y - miniPlayerHeight
                    tabBar.frame.origin.y = tabbarY + tabBar.frame.height
                } else if playerViewY + translation.y > contentHeight {
                    playerView.frame.origin.y = contentHeight
                    tabBar.frame.origin.y = tabbarY
                } else {
                    playerView.frame.origin.y += translation.y
                    tabBar.frame.origin.y -= translation.y * (tabBar.frame.height/contentHeight)
                }
                selectedViewController?.view.alpha = playerViewY / contentHeight
                gesture.setTranslation(.zero, in: view)
            }
        case .ended:
            let velocity = gesture.velocity(in: view)
            if velocity.y > 0 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.playerView.frame.origin.y = self.tabbarY - self.miniPlayerHeight
                    self.selectedViewController?.view.alpha = 1
                    self.tabBar.frame.origin.y = self.tabbarY
                })
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.playerView.frame.origin.y = 0 - self.miniPlayerHeight
                    self.selectedViewController?.view.alpha = 0
                    self.tabBar.frame.origin.y = self.tabbarY + self.tabBar.frame.height
                })
            }
            playerView.isScrollEnabled(value: true)
        default:
            break
        }
    }
}

extension RootTabbarController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let gesture = gestureRecognizer as? UIPanGestureRecognizer else {
            return true
        }
        let velocity = gesture.velocity(in: playerView)
        return abs(velocity.x) < abs(velocity.y)
    }
}
