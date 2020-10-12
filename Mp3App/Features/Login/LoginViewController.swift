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
        let loginTrigger = loginButton.rx.tap.withLatestFrom(Observable.combineLatest(usernameTextField.rx.text, passwordTextField.rx.text))
        let input = LoginViewModel.Input(login: loginTrigger)
        
        let output = viewModel.transform(input: input)
        
        output.activityIndicator.bind(to: ProgressHUD.rx.isAnimating).disposed(by: disposeBag)
        
        output.loginSuccess
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .failure(let error):
                    self.errorLabel.text = error.localizedDescription
                case .success(let id):
                    print(id)
                    SceneCoordinator.shared.transition(to: Scene.tabbar)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupTextField() {
        usernameTextField.layer.cornerRadius = 5
        passwordTextField.layer.cornerRadius = 5
        passwordTextField.isSecureTextEntry = true
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor.lightText]
        let usernameAttributedPlaceholder = NSAttributedString(string: Strings.username, attributes: attributes)
        let passwordAttributedPlaceholder = NSAttributedString(string: Strings.password, attributes: attributes)
        usernameTextField.attributedPlaceholder = usernameAttributedPlaceholder
        passwordTextField.attributedPlaceholder = passwordAttributedPlaceholder
    }
}
