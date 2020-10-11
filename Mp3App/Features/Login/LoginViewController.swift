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
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    var viewModel: LoginViewModel!
    private let disposeBag = DisposeBag()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    override func prepareUI() {
        super.prepareUI()
        setupTextField()
        setupButton()
    }
    
    private func setupButton() {
        loginButton.layer.cornerRadius = 5
    }
    
    private func bindViewModel() {
        let input = LoginViewModel.Input(email: usernameTextField.rx.text.asObservable(),
                                         password: passwordTextField.rx.text.asObservable(),
                                         login: loginButton.rx.tap.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.loginSuccess.subscribe(
            onNext: { (userId) in
                // save userId to UserDefault
                
                // transition screen
                SceneCoordinator.shared.transition(to: Scene.tabbar)
            },
            onError: { (error) in
                print(error)
            }
        ).disposed(by: disposeBag)
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
}
