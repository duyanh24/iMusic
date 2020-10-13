//
//  Playlist.swift
//  Mp3App
//
//  Created by AnhLD on 10/13/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation

class Playlist {
    var id: String?
    var playlistName: String?
    
    init(id: String?, playlistName: String?) {
        self.id = id
        self.playlistName = playlistName
    }
}
