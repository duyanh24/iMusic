//
//  Playlist.swift
//  Mp3App
//
//  Created by AnhLD on 10/13/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation

struct Playlist: Codable {
    var id: Int?
    var title: String?
    var user: User?
    var isAlbum: Bool?
    var kind: String?
    var tracks: [Track]?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case user
        case isAlbum = "is_album"
        case tracks
        case kind
    }
}
