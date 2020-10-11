//
//  AuthencationService.swift
//  Mp3App
//
//  Created by Apple on 10/11/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import RxSwift

protocol HasAuthencationService {
    var authencationService: AuthencationService { get }
}

struct AuthencationService {
    func login(email: String, password: String) -> Observable<String> {
        return FirebaseAccount.shared.login(email: email, password: password)
    }
}
