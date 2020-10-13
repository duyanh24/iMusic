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
        
        let loginEnable = Observable.combineLatest(input.email, input.password)
            .map { [weak self] (email, password) -> Bool in
                guard let self = self, let email = email, let password = password
                    else { return false }
                return self.validateEmail(email: email) && self.validatePassword(password: password)
        }
        
        let loginSuccess =  input.login.withLatestFrom(Observable.combineLatest(input.email, input.password))
            .flatMapLatest({ [weak self] email, password -> Observable<Result<Void, Error>> in
                guard let self = self, let email = email, let password = password else {
                    return .empty()
                }
                return self.services.authencationService.login(email: email, password: password).trackActivity(activityIndicator)
            })
        return Output(loginResult: loginSuccess, activityIndicator: activityIndicator.asObservable(), loginEnable: loginEnable)
    }
    
    func validateEmail(email: String) -> Bool {
        return email.count > 6
    }
    
    func validatePassword(password: String) -> Bool {
        return password.count > 6
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
        var loginEnable: Observable<Bool>
    }
}
