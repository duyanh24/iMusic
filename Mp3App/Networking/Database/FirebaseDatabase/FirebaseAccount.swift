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
            if !self.checkValidateEmail(email: email) {
                self.loginResult.onNext(.failure(APIError(status_code: nil, status_message: ErrorMessage.validateEmailError)))
            } else if !self.checkValidateEmail(password: password) {
                self.loginResult.onNext(.failure(APIError(status_code: nil, status_message: ErrorMessage.validatePasswordError)))
            } else {
                if let error = error {
                    if let errorCode = AuthErrorCode(rawValue: error._code) {
                        switch errorCode.rawValue {
                        case AuthencationStatusCode.FIRAuthErrorCodeWrongPassword.rawValue:
                            self.loginResult.onNext(.failure(APIError(status_code: AuthencationStatusCode.FIRAuthErrorCodeWrongPassword.rawValue, status_message: ErrorMessage.wrongPassword)))
                        case AuthencationStatusCode.FIRAuthErrorCodeInvalidEmail.rawValue:
                            self.loginResult.onNext(.failure(APIError(status_code: AuthencationStatusCode.FIRAuthErrorCodeInvalidEmail.rawValue, status_message: ErrorMessage.invalidEmail)))
                        case AuthencationStatusCode.FIRAuthErrorCodeUserNotFound.rawValue:
                            self.loginResult.onNext(.failure(APIError(status_code: AuthencationStatusCode.FIRAuthErrorCodeUserNotFound.rawValue, status_message: ErrorMessage.wrongEmail)))
                        default:
                            self.loginResult.onNext(.failure(APIError(status_code: nil, status_message: ErrorMessage.unknownError)))
                        }
                    } else {
                        self.loginResult.onNext(.failure(APIError(status_code: nil, status_message: ErrorMessage.unknownError)))
                    }
                } else {
                    if let result = result {
                        AccountDefault.shared.saveStringData(data: result.user.uid, key: .idkey)
                        AccountDefault.shared.saveStringData(data: email, key: .emailKey)
                        AccountDefault.shared.saveStringData(data: password, key: .passwordKey)
                        self.loginResult.onNext(.success(()))
                    } else {
                        self.loginResult.onNext(.failure(APIError(status_code: nil, status_message: ErrorMessage.unknownError)))
                    }
                }
            }
        }
    }
    
    private func checkValidateEmail(email: String) -> Bool {
        return email.count > 6
    }
    
    private func checkValidateEmail(password: String) -> Bool {
        return password.count > 6
    }
}
