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

class FirebaseDatabase {
    static let shared = FirebaseDatabase()
    private let reference = Database.database().reference()
    private let disposeBag = DisposeBag()
    private let loginResult = PublishSubject<Result<Void, Error>>()
    private let playlistResult = PublishSubject<Result<[String], Error>>()
    private let playlistDetailResult = PublishSubject<Result<[Track], Error>>()
    private let favouriteResult = PublishSubject<Result<[Track], Error>>()
    
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
            playlistResult.onNext(.failure(APIError(statusCode: AuthencationStatusCode.NotLoggedIn.rawValue, statusMessage: ErrorMessage.authenticalError)))
        } else {
            reference.child(FirebaseProperty.playlist.rawValue).child(userId).observe(.value, with: { [weak self] snapshot in
                let value = snapshot.value as? NSDictionary
                if let playlist = value?.allKeys as? [String] {
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
        return Observable.create { observer -> Disposable in
            let userId = AccountDefault.shared.retrieveStringData(key: .idkey)
            if userId.isEmpty {
                observer.onNext(.failure(APIError(statusCode: nil, statusMessage: ErrorMessage.authenticalError)))
            } else {
                observer.onNext(.success(()))
                Database.database().reference().child(FirebaseProperty.playlist.rawValue).child(userId).child(newPlaylist).setValue("")
            }
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func getTracksFromPlaylist(playlistName: String) -> Observable<Result<[Track], Error>> {
        let userId = AccountDefault.shared.retrieveStringData(key: .idkey)
        if userId.isEmpty {
            playlistResult.onNext(.failure(APIError(statusCode: nil, statusMessage: ErrorMessage.authenticalError)))
        } else {
            reference.child(FirebaseProperty.playlist.rawValue).child(userId).child(playlistName).observe(.value, with: { [weak self] (snapshot) in
                if let value = snapshot.value as? NSDictionary {
                    var tracks: [Track] = []
                    for playlist in value {
                        let track = playlist.value as? NSDictionary
                        let id = track?[FirebaseProperty.id.rawValue] as? Int
                        let title = track?[FirebaseProperty.title.rawValue] as? String
                        let artworkURL = track?[FirebaseProperty.artworkURL.rawValue] as? String
                        let description = track?[FirebaseProperty.description.rawValue] as? String
                        tracks.append(Track(id: id, title: title, user: nil, artworkURL: artworkURL, description: description, streamable: nil, streamURL: nil))
                    }
                    self?.playlistDetailResult.onNext(.success(tracks))
                } else {
                    self?.playlistDetailResult.onNext(.failure(APIError(statusCode: nil, statusMessage: ErrorMessage.unknownError)))
                }
            }) { (error) in
                self.playlistDetailResult.onNext(.failure(APIError(statusCode: nil, statusMessage: error.localizedDescription)))
            }
        }
        return playlistDetailResult
    }
    
    func addTrackToPlaylist(playlistName: String, track: Track) -> Observable<Result<Void, Error>> {
        return Observable.create { observer -> Disposable in
            let userId = AccountDefault.shared.retrieveStringData(key: .idkey)
            if userId.isEmpty {
                observer.onNext(.failure(APIError(statusCode: nil, statusMessage: ErrorMessage.authenticalError)))
            } else {
                if let trackId = track.id {
                    let trackDictionary: [String : Any] = [
                        FirebaseProperty.id.rawValue : trackId,
                        FirebaseProperty.title.rawValue : track.title ?? "",
                        FirebaseProperty.artworkURL.rawValue : track.artworkURL ?? "",
                        FirebaseProperty.description.rawValue : track.user?.username ?? ""
                    ]
                    Database.database().reference().child(FirebaseProperty.playlist    .rawValue).child(userId).child(playlistName).child(String(trackId)).setValue(trackDictionary)
                    observer.onNext(.success(()))
                } else {
                    observer.onNext(.failure(APIError(statusCode: nil, statusMessage: ErrorMessage.authenticalError)))
                }
            }
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func addTrackToFavourite(track: Track) -> Observable<Result<Void, Error>> {
        return Observable.create { observer -> Disposable in
            let userId = AccountDefault.shared.retrieveStringData(key: .idkey)
            if userId.isEmpty {
                observer.onNext(.failure(APIError(statusCode: nil, statusMessage: ErrorMessage.authenticalError)))
            } else {
                if let trackId = track.id {
                    let trackDictionary: [String : Any] = [
                        FirebaseProperty.id.rawValue : trackId,
                        FirebaseProperty.title.rawValue : track.title ?? "",
                        FirebaseProperty.artworkURL.rawValue : track.artworkURL ?? "",
                        FirebaseProperty.description.rawValue : track.user?.username ?? ""
                    ]
                    Database.database().reference().child(FirebaseProperty.favourite    .rawValue).child(userId).child(String(trackId)).setValue(trackDictionary)
                    observer.onNext(.success(()))
                } else {
                    observer.onNext(.failure(APIError(statusCode: nil, statusMessage: ErrorMessage.authenticalError)))
                }
            }
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func deletePlaylist(playlistName: String) -> Observable<Result<Void, Error>> {
        return Observable.create { [weak self] observer -> Disposable in
            let userId = AccountDefault.shared.retrieveStringData(key: .idkey)
            if userId.isEmpty {
                observer.onNext(.failure(APIError(statusCode: nil, statusMessage: ErrorMessage.authenticalError)))
            } else {
                self?.reference.child(FirebaseProperty.playlist.rawValue).child(userId).child(playlistName).removeValue()
                observer.onNext(.success(()))
            }
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func removeTrackInPlaylist(trackId: Int, playlist: String) -> Observable<Result<Void, Error>> {
        return Observable.create { [weak self] observer -> Disposable in
            let userId = AccountDefault.shared.retrieveStringData(key: .idkey)
            if userId.isEmpty {
                observer.onNext(.failure(APIError(statusCode: nil, statusMessage: ErrorMessage.authenticalError)))
            } else {
                self?.reference.child(FirebaseProperty.playlist.rawValue).child(userId).child(playlist).child(String(trackId)).removeValue()
                observer.onNext(.success(()))
            }
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func checkTrackAlreadyExitsInFavourite(trackId: Int) -> Observable<Result<Bool, Error>> {
        return Observable.create { [weak self] observer -> Disposable in
            let userId = AccountDefault.shared.retrieveStringData(key: .idkey)
            if userId.isEmpty {
                observer.onNext(.failure(APIError(statusCode: nil, statusMessage: ErrorMessage.authenticalError)))
            } else {
                self?.reference.child(FirebaseProperty.favourite.rawValue).child(userId).observeSingleEvent(of: .value, with: { snapshot in
                    if snapshot.hasChild(String(trackId)) {
                        observer.onNext(.success(true))
                    } else {
                        observer.onNext(.success(false))
                    }
                }) { error in
                    observer.onNext(.failure(APIError(statusCode: nil, statusMessage: error.localizedDescription)))
                }
            }
            return Disposables.create()
        }
    }
    
    func removeTrackInFavourite(trackId: Int) -> Observable<Result<Void, Error>> {
        return Observable.create { [weak self] observer -> Disposable in
            let userId = AccountDefault.shared.retrieveStringData(key: .idkey)
            if userId.isEmpty {
                observer.onNext(.failure(APIError(statusCode: nil, statusMessage: ErrorMessage.authenticalError)))
            } else {
                self?.reference.child(FirebaseProperty.favourite.rawValue).child(userId).child(String(trackId)).removeValue()
                observer.onNext(.success(()))
            }
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func getTracksFromFavourite() -> Observable<Result<[Track], Error>> {
        let userId = AccountDefault.shared.retrieveStringData(key: .idkey)
        if userId.isEmpty {
            favouriteResult.onNext(.failure(APIError(statusCode: nil, statusMessage: ErrorMessage.authenticalError)))
        } else {
            reference.child(FirebaseProperty.favourite.rawValue).child(userId).observe(.value, with: { [weak self] (snapshot) in
                if let value = snapshot.value as? NSDictionary {
                    var tracks: [Track] = []
                    for playlist in value {
                        let track = playlist.value as? NSDictionary
                        let id = track?[FirebaseProperty.id.rawValue] as? Int
                        let title = track?[FirebaseProperty.title.rawValue] as? String
                        let artworkURL = track?[FirebaseProperty.artworkURL.rawValue] as? String
                        let description = track?[FirebaseProperty.description.rawValue] as? String
                        tracks.append(Track(id: id, title: title, user: nil, artworkURL: artworkURL, description: description, streamable: nil, streamURL: nil))
                    }
                    self?.favouriteResult.onNext(.success(tracks))
                } else {
                    self?.favouriteResult.onNext(.failure(APIError(statusCode: nil, statusMessage: ErrorMessage.unknownError)))
                }
            }) { (error) in
                self.favouriteResult.onNext(.failure(APIError(statusCode: nil, statusMessage: error.localizedDescription)))
            }
        }
        return favouriteResult
    }
}
