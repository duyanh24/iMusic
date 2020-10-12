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
        let activityIndicator = ActivityIndicator()
        
        let loginSuccess =  input.login
            .flatMapLatest({ [weak self] email, password -> Observable<Result<String, Error>> in
                guard let self = self, let email = email, let password = password else {
                    return .empty()
                }
                return self.services.authencationService.login(email: email, password: password).trackActivity(activityIndicator)
            })
        return Output(loginSuccess: loginSuccess, error: errorTracker.asObservable(), activityIndicator: activityIndicator.asObservable())
    }
}

extension LoginViewModel {
    struct Input {
        var login: Observable<(String?, String?)>
    }
    
    struct Output {
        var loginSuccess: Observable<Result<String, Error>>
        var error: Observable<Error>
        var activityIndicator: Observable<Bool>
    }
}
