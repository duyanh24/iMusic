//
//  UIAlertController+Rx.swift
//  Mp3App
//
//  Created by AnhLD on 9/29/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIAlertController {
    var title: Binder<String> {
        return Binder(base) { alertController, title in
            alertController.title = title
        }
    }
    
    var message: Binder<String> {
        return Binder(base) { alertController, message in
            alertController.message = message
        }
    }
}
