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
    private let playlistResult = PublishSubject<Result<[String], Error>>()
    private let createPlaylistResult = PublishSubject<Result<Void, Error>>()
    
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
    
    func getAllPlaylist() -> Observable<Result<[String], Error>> {
        let userId = AccountDefault.shared.retrieveStringData(key: .idkey)
        if userId.isEmpty {
            playlistResult.onNext(.failure(APIError(statusCode: nil, statusMessage: ErrorMessage.authenticalError)))
        } else {
            reference.child(FirebaseProperty.users.rawValue).child(userId).observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
                let value = snapshot.value as? NSDictionary
                if let playlist = value?.allKeys as? [String] {
                    print(playlist)
                    self?.playlistResult.onNext(.success(playlist))
                } else {
                    self?.playlistResult.onNext(.failure(APIError(statusCode: nil, statusMessage: ErrorMessage.unknownError)))
                }
            }) { (error) in
                self.playlistResult.onNext(.failure(APIError(statusCode: nil, statusMessage: error.localizedDescription)))
            }
        }
        return playlistResult
    }
    
    func createPlaylist(newPlaylist: String) -> Observable<Result<Void, Error>> {
//        let userId = AccountDefault.shared.retrieveStringData(key: .idkey)
//        if userId.isEmpty {
//            createPlaylistResult.onNext(.failure(APIError(statusCode: nil, statusMessage: ErrorMessage.authenticalError)))
//        } else {
//            createPlaylistResult.onNext(.success(()))
//            Database.database().reference().child(FirebaseProperty.users.rawValue).child(userId).child(newPlaylist).setValue("")
//        }
//        return createPlaylistResult
        return Observable.create { observer -> Disposable in
            let userId = AccountDefault.shared.retrieveStringData(key: .idkey)
            if userId.isEmpty {
                observer.onNext(.failure(APIError(statusCode: nil, statusMessage: ErrorMessage.authenticalError)))
            } else {
                observer.onNext(.success(()))
                Database.database().reference().child(FirebaseProperty.users.rawValue).child(userId).child(newPlaylist).setValue("")
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
}
