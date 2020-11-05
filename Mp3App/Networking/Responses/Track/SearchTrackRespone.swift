//
//  SearchRespone.swift
//  Mp3App
//
//  Created by AnhLD on 10/30/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation

struct SearchTrackRespone: Codable {
    var tracks: [Track]?
    
    enum CodingKeys: String, CodingKey {
        case tracks = "collection"
    }
}
