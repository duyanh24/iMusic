//
//  UINavigationController+Extension.swift
//  Mp3App
//
//  Created by AnhLD on 9/29/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    func checkCurrentViewController<T: UIViewController>(type: T.Type) -> T? {
        if let visibleViewController = visibleViewController as? T {
            return visibleViewController
        } else {
            return nil
        }
    }
}
