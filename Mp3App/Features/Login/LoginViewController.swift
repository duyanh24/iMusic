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
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var viewModel: LoginViewModel!
    private let disposeBag = DisposeBag()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleAction()
    }
    
    override func prepareUI() {
        super.prepareUI()
        setupTextField()
        setupButton()
    }
    
    private func setupButton() {
        loginButton.layer.cornerRadius = 5
    }
    
    private func setupTextField() {
        usernameTextField.layer.cornerRadius = 5
        passwordTextField.layer.cornerRadius = 5
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor.lightText]
        let usernameAttributedPlaceholder = NSAttributedString(string: Strings.username, attributes: attributes)
        let passwordAttributedPlaceholder = NSAttributedString(string: Strings.password, attributes: attributes)
        usernameTextField.attributedPlaceholder = usernameAttributedPlaceholder
        passwordTextField.attributedPlaceholder = passwordAttributedPlaceholder
    }
    
    private func handleAction() {
        loginButton.rx.tap
        .subscribe(onNext: { _ in
            SceneCoordinator.shared.transition(to: Scene.tabbar)
        }).disposed(by: disposeBag)
    }
}

