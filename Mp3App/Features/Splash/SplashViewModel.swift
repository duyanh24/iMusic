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
        let password = Keychain.shared.getData(for: email)
        
        let loginResult = services.authencationService.login(email: email, password: password ?? "")
        
        let clearDataAccount = input.checkLogin.do(onNext: { isLogedIn in
            if !isLogedIn {
                AccountDefault.shared.clearUserData()
                Keychain.shared.clearData()
            }
        }).mapToVoid()
        
        return Output(loginResult: loginResult, clearDataAccount: clearDataAccount)
    }
}

extension SplashViewModel {
    struct Input {
        var checkLogin: Observable<Bool>
    }
    
    struct Output {
        var loginResult: Observable<Result<Void, Error>>
        var clearDataAccount: Observable<Void>
    }
}
