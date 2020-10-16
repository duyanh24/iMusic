//
//  LoginViewModel.swift
//  Mp3App
//
//  Created by AnhLD on 9/29/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel: ServicesViewModel {
    var services: LoginServices!
    
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        
        let isLoginEnabled = Observable.combineLatest(input.email, input.password)
            .map { email, password -> Bool in
                guard let email = email, let password = password
                    else { return false }
                
                return InputValidateHelper.validate(type: .email, input: email) && InputValidateHelper.validate(type: .password, input: password)
        }
        
        let emailValidateError = input.email.skip(1).map {
            InputValidateHelper.validate(type: .email, input: $0)
        }
        
        let passwordValidateError = input.password.skip(1).map {
            InputValidateHelper.validate(type: .password, input: $0)
        }
        
        let loginResult =  input.login.withLatestFrom(Observable.combineLatest(input.email, input.password))
            .flatMapLatest({ [weak self] email, password -> Observable<Result<Void, Error>> in
                guard let self = self, let email = email, let password = password else {
                    return .empty()
                }
               // return .empty()
                return self.services.authencationService.login(email: email, password: password).trackActivity(activityIndicator)
            })
        return Output(loginResult: loginResult, activityIndicator: activityIndicator.asObservable(), isLoginEnabled: isLoginEnabled, emailValidateError: emailValidateError, passwordValidateError: passwordValidateError)
    }
}

extension LoginViewModel {
    struct Input {
        var email: Observable<String?>
        var password: Observable<String?>
        var login: Observable<Void>
    }
    
    struct Output {
        var loginResult: Observable<Result<Void, Error>>
        var activityIndicator: Observable<Bool>
        var isLoginEnabled: Observable<Bool>
        var emailValidateError: Observable<String>
        var passwordValidateError: Observable<String>
    }
}
