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
            .map { [weak self] (email, password) -> Bool in
                guard let self = self, let email = email, let password = password
                    else { return false }
                return self.validateEmail(email: email) && self.validatePassword(password: password)
        }
        
        let loginResult =  input.login.withLatestFrom(Observable.combineLatest(input.email, input.password))
            .flatMapLatest({ [weak self] email, password -> Observable<Result<Void, Error>> in
                guard let self = self, let email = email, let password = password else {
                    return .empty()
                }
                if self.isValidEmail(email: email) {
                    return self.services.authencationService.login(email: email, password: password).trackActivity(activityIndicator)
                } else {
                    return Observable.create { observer -> Disposable in
                        observer.onNext(.failure(APIError(statusCode: nil, statusMessage: ErrorMessage.invalidEmail)))
                        observer.onCompleted()
                        return Disposables.create()
                    }
                }
            })
        return Output(loginResult: loginResult, activityIndicator: activityIndicator.asObservable(), isLoginEnabled: isLoginEnabled)
    }
    
    private func validateEmail(email: String) -> Bool {
        return email.count > 6
    }
    
    private func validatePassword(password: String) -> Bool {
        return password.count > 6
    }
    
    private func isValidEmail(email: String) -> Bool {
        let regularExpressionForEmail = Strings.regularExpressionForEmail
        return NSPredicate(format: Strings.emailFormat, regularExpressionForEmail).evaluate(with: email)
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
    }
}
