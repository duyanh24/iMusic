//
//  LoginViewController.swift
//  Mp3App
//
//  Created by AnhLD on 9/29/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import UIKit
import Reusable
import RxSwift
import RxCocoa

class LoginViewController: BaseViewController, StoryboardBased, ViewModelBased {
    @IBOutlet weak var loginButton: UIButton!
    
    var viewModel: LoginViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleAction()
    }
    
    private func handleAction() {
        loginButton.rx.tap
        .subscribe(onNext: { _ in
            SceneCoordinator.shared.transition(to: Scene.tabbar)
        }).disposed(by: disposeBag)
    }
}
