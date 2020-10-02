//
//  UserService.swift
//  Mp3App
//
//  Created by AnhLD on 10/2/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import RxSwift

protocol HasUserService {
    var userService: UserService { get }
}

struct UserService {
    func getPopularUser() -> Observable<[User]> {
        return HostAPIClient.performApiNetworkCall(router: .getPopularUser(limit: 20, offset: 0), type: [User].self)
    }
}
