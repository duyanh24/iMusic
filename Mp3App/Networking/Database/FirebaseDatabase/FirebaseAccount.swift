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
import FirebaseAuth
import Firebase
import FirebaseFirestore

class FirebaseAccount {
    static let shared = FirebaseAccount()
    private let reference = Database.database().reference()
    private let disposeBag = DisposeBag()
    
    func login(email: String, password: String) -> Observable<String> {
        return Observable.create { observer -> Disposable in
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if error != nil {
                    if let errorCode = AuthErrorCode(rawValue: error!._code) {
                        switch errorCode.rawValue {
                        case AuthencationStatusCode.FIRAuthErrorCodeWrongPassword.rawValue:
                            observer.onError(APIError(status_code: AuthencationStatusCode.FIRAuthErrorCodeWrongPassword.rawValue, status_message: ErrorMessage.authenticalError))
                        default:
                            observer.onError(APIError(status_code: nil, status_message: ErrorMessage.unknownError))
                        }
                    } else {
                        observer.onError(APIError(status_code: nil, status_message: ErrorMessage.unknownError))
                    }
                    observer.onCompleted()
                } else {
                    if let result = result {
                        observer.onNext(result.user.uid)
                    } else {
                        observer.onError(APIError(status_code: nil, status_message: ErrorMessage.unknownError))
                    }
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

    func checkLogin(email: String, password: String) {
        print("click")
        Auth.auth().signIn(withEmail: "test5@gmail.com", password: "123456") { (result, error) in
            if error != nil {
                
                if let errCode = AuthErrorCode(rawValue: error!._code) {
                    switch errCode.rawValue {
                    case AuthencationStatusCode.FIRAuthErrorCodeWrongPassword.rawValue:
                        print("sai mk")
                    default:
                        print("conf laij")
                    }
                    print(errCode)
                    
                } else {
                    
                }
            } else {
                print(result?.user.uid)
            }
        }
        
//        let db = Firestore.firestore()
//        let docRef = db.collection("users").document("6zQ0jUrPJpFrxwyKaa8r")
//
//        docRef.getDocument { (document, error) in
//            if let document = document, document.exists {
//                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                print("Document data: \(dataDescription)")
//            } else {
//                print("Document does not exist")
//            }
//        }
        
//        Auth.auth().createUser(withEmail: "test5@gmail.com", password: "123456") { (user, error) in
//            if error != nil {
//                print("error")
//            } else {
//                var ref: DocumentReference? = nil
//                let db = Firestore.firestore()
//                ref = db.collection("users").addDocument(data: [
//                    "first": "Ada",
//                    "last": "Lovelace",
//                    "born": 1815,
//                    "id": user?.user.uid
//                ]) { err in
//                    if let err = err {
//                        print("Error adding document: \(err)")
//                    } else {
//                        print("Document added with ID: \(ref!.documentID)")
//                    }
//                }
//            }
//        }
//        var ref: DocumentReference? = nil
//        let db = Firestore.firestore()
//        ref = db.collection("intersted").addDocument(data: [
//            "uid": "Thi5obQ6M5WWgNGOxyIygPw0OEV2",
//            "songid": "1200006"
//        ]) { err in
//            if let err = err {
//                print("Error adding document: \(err)")
//            } else {
//                print("Document added with ID: \(ref!.documentID)")
//            }
//        }
        
        
    }
    
     func getLastUserId() -> Observable<Int> {
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
        checkUsernameExist(username: username).asObservable().subscribe(onNext: { result in
                print(result)
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
