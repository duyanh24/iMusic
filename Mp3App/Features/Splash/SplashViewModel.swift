//
//  SplashViewModel.swift
//  Mp3App
//
//  Created by AnhLD on 9/29/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SplashViewModel: ServicesViewModel {
    var services: SplashServices!
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let email = AccountDefault.shared.retrieveStringData(key: .emailKey)
        let password = AccountDefault.shared.retrieveStringData(key: .passwordKey)
        let loginResult = services.authencationService.login(email: email, password: password)
        return Output(loginResult: loginResult)
    }
}

extension SplashViewModel {
    struct Input {}
    
    struct Output {
        var loginResult: Observable<Result<Void, Error>>
    }
}
