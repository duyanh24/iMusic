//
//  FirebaseDatabase.swift
//  Mp3App
//
//  Created by AnhLD on 10/9/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth
import Firebase
import FirebaseFirestore

class FirebaseAccount {
    static let shared = FirebaseAccount()
    private let reference = Database.database().reference()
    private let disposeBag = DisposeBag()
    let loginResult = PublishSubject<Result<Void, Error>>()
    
    func login(email: String, password: String) -> Observable<Result<Void, Error>> {
        authencationAccount(email: email, password: password)
        return loginResult
    }
    
    private func authencationAccount(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            if let error = error {
                if let errorCode = AuthErrorCode(rawValue: error._code) {
                    self.loginResult.onNext(.failure(APIError(authErrorCode: errorCode)))
                } else {
                    self.loginResult.onNext(.failure(APIError(statusCode: nil, statusMessage: ErrorMessage.unknownError)))
                }
            } else {
                if let result = result {
                    AccountDefault.shared.saveStringData(data: result.user.uid, key: .idkey)
                    AccountDefault.shared.saveStringData(data: email, key: .emailKey)
                    AccountDefault.shared.saveStringData(data: password, key: .passwordKey)
                    self.loginResult.onNext(.success(()))
                } else {
                    self.loginResult.onNext(.failure(APIError(statusCode: nil, statusMessage: ErrorMessage.unknownError)))
                }
            }
            
        }
    }
}
