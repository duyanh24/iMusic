//
//  SearchUserRespone.swift
//  Mp3App
//
//  Created by Apple on 11/5/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation

struct SearchUserRespone: Codable {
    var users: [User]?
    
    enum CodingKeys: String, CodingKey {
        case users = "collection"
    }
}
