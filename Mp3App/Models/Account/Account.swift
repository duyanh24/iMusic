//
//  Account.swift
//  Mp3App
//
//  Created by AnhLD on 10/9/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation

class Account: Codable {
    var id: String?
    var email: String?
    var password: String?
    var imageURL: String?
    var interestedAlbums: [Int]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case password
    }
}
