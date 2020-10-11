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
    private let errorTracker = ErrorTracker()
    
    func transform(input: Input) -> Output {
        let loginSuccess: Observable<String> =  input.login
            .withLatestFrom(Observable.combineLatest(input.email, input.password))
            .flatMap({ [weak self] email, password -> Observable<String> in
                guard let self = self, let email = email, let password = password else { return .empty() }
                return self.services.authencationService.login(email: email, password: password)
                    .trackError(self.errorTracker)
            })
        return Output(loginSuccess: loginSuccess, error: errorTracker.asObservable())
    }
}

extension LoginViewModel {
    struct Input {
        var email: Observable<String?>
        var password: Observable<String?>
        var login: Observable<Void>
    }
    
    struct Output {
        var loginSuccess: Observable<String>
        var error: Observable<Error>
    }
}
