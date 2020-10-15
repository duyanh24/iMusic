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
    func getAllPlaylist() -> Observable<Result<[String], Error>> {
        return FirebaseAccount.shared.getAllPlaylist()
    }
    
    func createPlaylist(newPlaylist: String) -> Observable<Result<Void, Error>> {
        return FirebaseAccount.shared.createPlaylist(newPlaylist: newPlaylist)
    }
    
    func getAlbumsFromPlaylist(playlist: String) -> Observable<[String]> {
        return FirebaseAccount.shared.getAlbumsFromPlaylist(playlist: playlist)
    }
}
