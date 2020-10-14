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
    private let loginResult = PublishSubject<Result<Void, Error>>()
    
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
    
    func getAllPlaylist() -> Observable<[String]> {
        return Observable.create { [weak self] observer -> Disposable in
            let userId = AccountDefault.shared.retrieveStringData(key: .idkey)
            
            if userId.isEmpty {
                observer.onError(APIError(statusCode: nil, statusMessage: ErrorMessage.notFound))
            } else {
                observer.onNext(["playlist1","playlist2","playlist3"])
                self?.reference.child(FirebaseProperty.users.rawValue).child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    if let playlist = value?.allKeys as? [String] {
                        observer.onNext(playlist)
                    } else {
                        observer.onError(APIError(statusCode: nil, statusMessage: ErrorMessage.unknownError))
                    }
                }) { (error) in
                    observer.onError(APIError(statusCode: nil, statusMessage: error.localizedDescription))
                }
            }
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func getAlbumsFromPlaylist(playlist: String) -> Observable<[String]> {
        return Observable.create { [weak self] observer -> Disposable in
            let userId = AccountDefault.shared.retrieveStringData(key: .idkey)
            if userId.isEmpty {
                observer.onError(APIError(statusCode: nil, statusMessage: ErrorMessage.notFound))
            } else {
                observer.onNext(["album1","album2","album3"])
                self?.reference.child(FirebaseProperty.users.rawValue).child(userId).child(playlist).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    if let albums = value?.allKeys as? [String] {
                        observer.onNext(albums)
                    } else {
                        observer.onError(APIError(statusCode: nil, statusMessage: ErrorMessage.unknownError))
                    }
                }) { (error) in
                    observer.onError(APIError(statusCode: nil, statusMessage: error.localizedDescription))
                }
            }
            observer.onCompleted()
            return Disposables.create()
        }
    }
//    func getPlaylist() {
//        let ref = Database.database().reference()
//
//        ref.child("users").child("SeXtpR45eNa3RZIkzuJTNRfuV5n2").observeSingleEvent(of: .value, with: { (snapshot) in
//          // Get user value
//          let value = snapshot.value as? NSDictionary
//            let playlist = value?.allKeys
//            print(playlist as! [String])
//          // ...
//          }) { (error) in
//            print(error.localizedDescription)
//        }
//    }
//
//    func createPlaylist() {
//        let ref = Database.database().reference()
//                let songArray = ["Us and Them", "Get Back", "Children of the Sun"]
//                ref.child("users").child("SeXtpR45eNa3RZIkzuJTNRfuV5n2").child("playlist3").setValue(songArray)
//        //        ref.child("users").child("SeXtpR45eNa3RZIkzuJTNRfuV5n2").child("playlist1").setValue(songArray)
//        //        ref.child("users").child("SeXtpR45eNa3RZIkzuJTNRfuV5n2").child("playlist2").setValue(songArray)
//    }
}
