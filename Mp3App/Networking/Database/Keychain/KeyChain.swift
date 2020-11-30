//
//  KeyChain.swift
//  Mp3App
//
//  Created by AnhLD on 11/20/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation

class Keychain {
    static let shared = Keychain()
    
    func saveData(_ data: String, for key: String) {
        let data = data.data(using: String.Encoding.utf8)!
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: key,
                                    kSecValueData as String: data]
        SecItemAdd(query as CFDictionary, nil)
    }
    
    func getData(for key: String) -> String? {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: key,
                                    kSecReturnData as String: true]
        var retrivedData: AnyObject? = nil
        let _ = SecItemCopyMatching(query as CFDictionary, &retrivedData)
        guard let data = retrivedData as? Data else { return nil }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    func clearData() {
        let spec: NSDictionary = [kSecClass: kSecClassGenericPassword]
        SecItemDelete(spec)
    }
}
