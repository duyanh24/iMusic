//
//  UserResultCellViewModel.swift
//  Mp3App
//
//  Created by Apple on 11/5/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import RxSwift

class UserResultCellViewModel: ViewModel {
    private let user: User
    
    init(user: User) {
        self.user = user
    }
    
    func transform(input: Input) -> Output {
        return Output(user: .just(user))
    }
}

extension UserResultCellViewModel {
    struct Input {
    }
    
    struct Output {
        var user: Observable<User>
    }
}
