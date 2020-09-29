//
//  UIStackView+Extension.swift
//  Mp3App
//
//  Created by AnhLD on 9/29/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import UIKit

extension UIStackView {
    func removeAllArrangedSubviews() {
        while arrangedSubviews.count > 0 {
            arrangedSubviews.first?.removeFromSuperview()
        }
    }
}
