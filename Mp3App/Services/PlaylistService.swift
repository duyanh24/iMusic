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
        return FirebaseDatabase.shared.getAllPlaylist()
    }
    
    func createPlaylist(newPlaylist: String) -> Observable<Result<Void, Error>> {
        return FirebaseDatabase.shared.createPlaylist(newPlaylist: newPlaylist)
    }
    
    func getTracksFromPlaylist(playlistName: String) -> Observable<Result<[Track], Error>> {
        return FirebaseDatabase.shared.getTracksFromPlaylist(playlistName: playlistName)
    }
    
    func addTrackToPlaylist(playlistName: String, track: Track) -> Observable<Result<Void, Error>> {
        return FirebaseDatabase.shared.addTrackToPlaylist(playlistName: playlistName, track: track)
    }
    
    func deletePlaylist(playlistName: String) -> Observable<Result<Void, Error>> {
        return FirebaseDatabase.shared.deletePlaylist(playlistName: playlistName)
    }
    
    func removeTrackInPlaylist(trackId: Int, playlist: String) -> Observable<Result<Void, Error>> {
        return FirebaseDatabase.shared.removeTrackInPlaylist(trackId: trackId, playlist: playlist)
    }
}
