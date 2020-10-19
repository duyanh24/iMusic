//
//  UIViewController+Extension.swift
//  RxSwiftCoordinator
//
//  Created by thanh tien on 9/15/20.
//  Copyright © 2020 kennyS. All rights reserved.
//

import Foundation
import UIKit

extension UIGestureRecognizerDelegate where Self: UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
}

extension UIViewController {
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIViewController {
    func getTabbarHeight() -> CGFloat {
        if let controller = self.tabBarController {
            if #available(iOS 11, *), let keyWindow = UIApplication.shared.currentWindow {
                return controller.tabBar.frame.height - keyWindow.safeAreaInsets.bottom
            } else {
                return controller.tabBar.frame.height
            }
        }
        if let navController = self.navigationController, let tabbarController = navController.tabBarController {
            if #available(iOS 11, *), let keyWindow = UIApplication.shared.currentWindow {
                return tabbarController.tabBar.frame.height - keyWindow.safeAreaInsets.bottom
            } else {
                return tabbarController.tabBar.frame.height
            }
        }
        return 0
    }
}

extension UIViewController {
    enum SelectCase {
        case confirm
        case cancel
    }
    
    func showErrorAlert(title: String? = nil, message: String, actionTitle: String = Strings.OK) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showErrorAlert(title: String? = nil, message: String, actionTitle: String = Strings.OK, completion: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .cancel, handler: { _ in
            guard let completion = completion else {
                return
            }
            completion()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func showConfirmMessage(title: String, message: String, confirmTitle: String = Strings.yes, cancelTitle: String = Strings.no, completion: @escaping(SelectCase) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: confirmTitle,
                                      style: .default,
                                      handler: { _ in completion(.confirm) }))
        alert.addAction(UIAlertAction(title: cancelTitle,
                                      style: .cancel,
                                      handler: { _ in completion(.cancel) }))
        present(alert, animated: true, completion: nil)
    }
}

extension UIViewController {
    func prepareView() {
        _ = view
    }
}

extension UIViewController {
    func addChildControllerToSubview(viewController: UIViewController, to subview: UIView) {
        addChild(viewController)
        viewController.view.frame = subview.bounds
        subview.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
}

extension UIViewController: UIAdaptivePresentationControllerDelegate {
    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        if let presentingViewController = presentingViewController {
            SceneCoordinator.shared.setCurrentViewController(viewController: presentingViewController)
        } else {
            SceneCoordinator.shared.setCurrentViewController(viewController: self)
        }
    }
}
