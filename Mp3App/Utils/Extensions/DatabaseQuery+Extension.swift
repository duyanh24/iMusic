//
//  DatabaseQuery+Extension.swift
//  Mp3App
//
//  Created by AnhLD on 10/9/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import FirebaseDatabase
import RxSwift
import RxCocoa

extension DatabaseQuery {
    func observeSingleEvent(of event: DataEventType) -> Observable<DataSnapshot> {
        return Observable.create({ (observer) -> Disposable in
            self.observeSingleEvent(of: event, with: { (snapshot) in
                observer.onNext(snapshot)
                observer.onCompleted()
            }, withCancel: { (error) in
                observer.onError(error)
            })
            return Disposables.create()
        })
    }
    
    func observeEvent(event: DataEventType) -> Observable<DataSnapshot> {
        return Observable.create({ (observer) -> Disposable in
            let handle = self.observe(event, with: { (snapshot) in
                observer.onNext(snapshot)
            }, withCancel: { (error) in
                observer.onError(error)
            })
            return Disposables.create {
                self.removeObserver(withHandle: handle)
            }
        })
    }
}
