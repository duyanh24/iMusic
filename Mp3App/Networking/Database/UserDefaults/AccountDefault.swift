//
//  AccountDefault.swift
//  Mp3App
//
//  Created by AnhLD on 10/12/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation

struct AccountDefault {
    
    static let userSessionKey = "com.save.usersession"
    private static let userDefault = UserDefaults.standard
    
    static func save(account: Account){
        userDefault.set([
            AccountDefaultKey.idkey.rawValue: account.id,
            AccountDefaultKey.emailKey.rawValue: account.email,
            AccountDefaultKey.passwordKey.rawValue: account.password,
            AccountDefaultKey.imageURLKey.rawValue: account.imageURL
        ],forKey: userSessionKey)
    }
    
    static func getNameAndAddress()-> Account {
        //return UserDetails((userDefault.value(forKey: userSessionKey) as? [String: String]) ?? [:])
        return Account()
    }
    
    static func clearUserData(){
        userDefault.removeObject(forKey: userSessionKey)
    }
}

enum AccountDefaultKey: String {
    case idkey = "id"
    case emailKey = "email"
    case passwordKey = "password"
    case imageURLKey = "imageURL"
}
