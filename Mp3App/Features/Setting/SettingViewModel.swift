//
//  SettingViewModel.swift
//  Mp3App
//
//  Created by AnhLD on 9/29/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SettingViewModel: ServicesViewModel {
    var services: SettingServices!
    private let checkLogin = BehaviorSubject<Bool>(value: false)
    
    func transform(input: Input) -> Output {
        let logoutSuccess = input.logout
            .do(onNext: { [weak self] _ in
                self?.services.authencationService.logout()
                TrackPlayer.shared.resetData()
            })
            .mapToVoid()
        
        let email = AccountDefault.shared.retrieveStringData(key: .emailKey)
        email.isEmpty ? checkLogin.onNext(false) : checkLogin.onNext(true)
        
        return Output(logoutSuccess: logoutSuccess,
                      email: .just(AccountDefault.shared.retrieveStringData(key: .emailKey)),
                      checkLogin: checkLogin)
    }
}

extension SettingViewModel {
    struct Input {
        var logout: Observable<Void>
    }
    
    struct Output {
        var logoutSuccess: Observable<Void>
        var email: Observable<String>
        var checkLogin: Observable<Bool>
    }
}
