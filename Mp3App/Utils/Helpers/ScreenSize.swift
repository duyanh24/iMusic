//
//  ScreenSize.swift
//  Mp3App
//
//  Created by Apple on 10/7/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import UIKit

class ScreenSize {
    static func calculatorStatusBarHeight() -> CGFloat {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.currentWindow
            return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }
}
