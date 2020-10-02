//
//  Album.swift
//  Mp3App
//
//  Created by AnhLD on 10/2/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation

struct Album: Codable {
    var track: Track?
    
    enum CodingKeys: String, CodingKey {
        case track
    }
}
