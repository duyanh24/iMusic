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
import FirebaseDatabase
import CodableFirebase

class FirebaseAccount {
    static let shared = FirebaseAccount()
    private let reference = Database.database().reference()
    private let disposeBag = DisposeBag()

    private func checkLogin(username: String, password: String) {
        
    }
    
    private func getLastUserId() -> Observable<Int> {
        let userReference = reference.child(FirebaseProperty.users.rawValue).queryLimited(toLast: 1)
        return userReference.observeSingleEvent(of: .value)
            .map { snapshot -> Int in
                guard
                    let result = snapshot.children.allObjects as? [DataSnapshot],
                    let lastId = result.first?.childSnapshot(forPath: FirebaseProperty.id.rawValue).value as? Int
                else {
                    return 0
                }
                return lastId
            }
    }
    
    func registerAccount(username: String, password: String) {
        checkUsernameExist(username: username).asObservable().subscribe(onNext: { (<#Bool#>) in
            <#code#>
            }).disposed(by: disposeBag)
//        getLastUserId().asObservable().subscribe(onNext: { [weak self] (lastUserId) in
//            let account: [String: Any] = [
//                FirebaseProperty.id.rawValue: lastUserId + 1,
//                FirebaseProperty.username.rawValue: username,
//                FirebaseProperty.password.rawValue: password
//            ]
//            self?.reference.child(FirebaseProperty.users.rawValue).child("\(lastUserId + 1)").setValue(account)
//        }).disposed(by: disposeBag)
    }
    
    private func checkUsernameExist(username: String) -> Observable<Bool> {
        return Observable.create { [weak self] observer -> Disposable in
            guard let self = self else {
                observer.onCompleted()
                return Disposables.create()
            }
            self.reference.child(FirebaseProperty.users.rawValue).queryOrdered(byChild: FirebaseProperty.username.rawValue).queryEqual(toValue : username).observe(.value) { (snapshot: DataSnapshot) in
                if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                    observer.onNext(!snapshot.isEmpty)
                } else {
                    observer.onNext(false)
                }
            }
            observer.onCompleted()
            return Disposables.create()
        }
    }
}
