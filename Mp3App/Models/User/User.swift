//
//  User.swift
//  Mp3App
//
//  Created by AnhLD on 10/1/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation

struct User: Codable {
    var id: Int?
    var avatarURL: String?
    var username: String?
    var description: String?
    var kind: String?

    enum CodingKeys: String, CodingKey {
        case id
        case avatarURL = "avatar_url"
        case username = "username"
        case description = "description"
        case kind
    }
}
