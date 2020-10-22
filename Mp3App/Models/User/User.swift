//
//  User.swift
//  Mp3App
//
//  Created by AnhLD on 10/1/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation

struct User: Codable {
    let id: Int?
    let avatarURL: String?
    let username: String?

    enum CodingKeys: String, CodingKey {
        case id
        case avatarURL = "avatar_url"
        case username = "username"
    }
}
