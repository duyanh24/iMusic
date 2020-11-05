//
//  SearchPlaylistRespone.swift
//  Mp3App
//
//  Created by Apple on 11/5/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation

struct SearchPlaylistRespone: Codable {
    var playlists: [Playlist]?
    
    enum CodingKeys: String, CodingKey {
        case playlists = "collection"
    }
}
