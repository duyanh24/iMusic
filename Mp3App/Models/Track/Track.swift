//
//  Track.swift
//  Mp3App
//
//  Created by AnhLD on 10/1/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation

struct Track: Codable {
    var id: Int?
    var title: String?
    var user: User?
    var artworkURL: String?
    var description: String?
    var streamable: Bool?
    var streamURL: String?
    var genre: String?
    var isPlaying = false
    var isRepeated = false
    var kind: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case user
        case artworkURL = "artwork_url"
        case description
        case streamable
        case streamURL = "stream_url"
        case genre
        case kind
    }
}
