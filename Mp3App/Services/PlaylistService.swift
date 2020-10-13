//
//  PlaylistService.swift
//  Mp3App
//
//  Created by AnhLD on 10/13/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import RxSwift

protocol HasPlaylistService {
    var playlistService: PlaylistService { get }
}

struct PlaylistService {
    func getAllPlaylist() -> Observable<[Playlist]> {
        return FirebaseAccount.shared.getAllPlaylist()
    }
}
