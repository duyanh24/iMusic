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
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    
    var viewModel: LoginViewModel!
    private let disposeBag = DisposeBag()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        hideKeyboardWhenTappedAround()
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
        let input = LoginViewModel.Input(email: emailTextField.rx.text.asObservable(),
                                         password: passwordTextField.rx.text.asObservable(),
                                         login: loginButton.rx.tap.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.isLoginEnabled.bind(to: loginButton.rx.isEnabled).disposed(by: disposeBag)
        output.isLoginEnabled.subscribe(onNext: { [weak self] (isLoginEnabled) in
            self?.loginButton.backgroundColor = isLoginEnabled ? Colors.loginButtonColor : Colors.loginButtonColor.withAlphaComponent(0.2)
            self?.loginButton.setTitleColor(isLoginEnabled ? .white : UIColor.white.withAlphaComponent(0.3), for: .normal)
        }).disposed(by: disposeBag)
        
        output.activityIndicator.bind(to: ProgressHUD.rx.isAnimating).disposed(by: disposeBag)
        
        output.loginResult
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .failure(let error):
                    self.showErrorAlert(message: error.localizedDescription, completion: nil)
                case .success:
                    SceneCoordinator.shared.transition(to: Scene.tabbar)
                }
            })
            .disposed(by: disposeBag)
        
        output.emailValidateError.bind(to: emailErrorLabel.rx.text).disposed(by: disposeBag)
        output.passwordValidateError.bind(to: passwordErrorLabel.rx.text).disposed(by: disposeBag)
    }
    
    private func setupTextField() {
        emailTextField.layer.cornerRadius = 5
        passwordTextField.layer.cornerRadius = 5
        passwordTextField.isSecureTextEntry = true
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor.lightText]
        let usernameAttributedPlaceholder = NSAttributedString(string: Strings.username, attributes: attributes)
        let passwordAttributedPlaceholder = NSAttributedString(string: Strings.password, attributes: attributes)
        emailTextField.attributedPlaceholder = usernameAttributedPlaceholder
        passwordTextField.attributedPlaceholder = passwordAttributedPlaceholder
    }
}

extension LoginViewController: UIGestureRecognizerDelegate {
    func hideKeyboardWhenTappedAround() {
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc override func dismissKeyboard() {
        view.endEditing(true)
    }
}
