//
//  UIBarButtonItem+Rx.swift
//  Mp3App
//
//  Created by AnhLD on 9/29/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIBarButtonItem {
    var image: Binder<UIImage> {
        return Binder(base) { button, image in
            button.image = image
        }
    }
}
