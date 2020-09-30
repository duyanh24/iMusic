//
//  SceneCoordinatorType.swift
//  Mp3App
//
//  Created by AnhLD on 9/29/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import UIKit
import RxSwift

protocol SceneCoordinatorType {
    init(window: UIWindow)
    
    @discardableResult func transition(to scene: TargetScene) -> Observable<Void>
    func pop(animated: Bool, toRoot: Bool)
}
