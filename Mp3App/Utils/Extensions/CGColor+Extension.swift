//
//  CGColor+Extension.swift
//  Mp3App
//
//  Created by AnhLD on 9/29/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import UIKit

class Colors {
    var gradientLayer = CAGradientLayer()
    
    init() {
        let colorTop = UIColor.black
        let colorBottom = UIColor.white
        self.gradientLayer.colors = [colorTop, colorBottom]
        self.gradientLayer.locations = [0.0, 1.0]
    }
}
