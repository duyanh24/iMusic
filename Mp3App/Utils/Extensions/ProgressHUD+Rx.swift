//
//  ProgressHUD+Rx.swift
//  Mp3App
//
//  Created by AnhLD on 10/12/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: ProgressHUD {
    static var isAnimating: Binder<Bool> {
        return Binder(UIApplication.shared) { _, isVisible in
            isVisible ? ProgressHUD.shared.show() : ProgressHUD.shared.hide()
        }
    }
}
