//
//  AccountDefault.swift
//  Mp3App
//
//  Created by AnhLD on 10/12/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation

class AccountDefault {
    static let shared = AccountDefault()
    private let userSessionKey = AccountDefaultKey.userSessionKey.rawValue
    private let userDefault = UserDefaults.standard
    
    func saveStringData(data: String, key: AccountDefaultKey) {
        userDefault.set(data, forKey: key.rawValue)
    }
    
    func retrieveStringData(key: AccountDefaultKey) -> String {
        return UserDefaults.standard.string(forKey: key.rawValue) ?? ""
    }
    
    func clearUserData() {
        userDefault.removeObject(forKey: AccountDefaultKey.idkey.rawValue)
        userDefault.removeObject(forKey: AccountDefaultKey.emailKey.rawValue)    }
}
