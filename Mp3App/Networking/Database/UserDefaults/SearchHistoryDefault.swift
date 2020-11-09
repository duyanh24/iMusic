//
//  SearchHistoryDefault.swift
//  Mp3App
//
//  Created by AnhLD on 11/9/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation

class SearchHistoryDefault {
    static let shared = SearchHistoryDefault()
    private let userSessionKey = SearchHistoryDefaulttKey.userSessionKey.rawValue
    private let userDefault = UserDefaults.standard
    
    func saveData(data: [String], key: SearchHistoryDefaulttKey) {
        userDefault.set(data, forKey: key.rawValue)
    }
    
    func retrieveData(key: SearchHistoryDefaulttKey) -> [String] {
        return UserDefaults.standard.array(forKey: key.rawValue) as? [String] ?? []
    }
    
    func clearData() {
        userDefault.removeObject(forKey: SearchHistoryDefaulttKey.searchHistory.rawValue)
    }
}
