//
//  SearchAllRespone.swift
//  Mp3App
//
//  Created by AnhLD on 11/5/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation

struct SearchAllRespone: Codable {
    var data: [DataSearch]?
    
    enum CodingKeys: String, CodingKey {
        case data = "collection"
    }
}

enum DataSearch: Codable {
    case track(Track)
    case user(User)
    case playlist(Playlist)
    
    private enum SearchDataType: String {
        case track = "track"
        case user = "user"
        case playlist = "playlist"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let data = try? container.decode(Playlist.self), data.kind == SearchDataType.playlist.rawValue {
            self = .playlist(data)
            return
        }
        if let data = try? container.decode(User.self), data.kind == SearchDataType.user.rawValue {
            self = .user(data)
            return
        }
        if let data = try? container.decode(Track.self), data.kind == SearchDataType.track.rawValue {
            self = .track(data)
            return
        }
        throw DecodingError.typeMismatch(DataSearch.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Data"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .track(let data):
            try container.encode(data)
        case .user(let data):
            try container.encode(data)
        case .playlist(let data):
            try container.encode(data)
        }
    }
}
