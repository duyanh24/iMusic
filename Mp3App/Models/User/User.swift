//
//  User.swift
//  Mp3App
//
//  Created by AnhLD on 10/1/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation

struct User: Codable {
    let idUser: Int?
    let avatarURL: String?
    let userName: String?

    enum CodingKeys: String, CodingKey {
        case idUser = "id"
        case avatarURL = "avatar_url"
        case userName = "username"
    }
}
