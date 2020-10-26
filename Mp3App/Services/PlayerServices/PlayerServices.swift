//
//  PlayerServices.swift
//  Mp3App
//
//  Created by AnhLD on 10/23/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation

struct PlayerServices: HasPlaylistService, HasTrackService, HasLibraryService {
    var playlistService: PlaylistService
    var trackService: TrackService
    var libraryService: LibraryService
}
