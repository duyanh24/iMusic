//
//  SearchDataModel.swift
//  Mp3App
//
//  Created by AnhLD on 11/5/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation

class SearchDataModel {
    var tracks = [Track]()
    var playlists = [Playlist]()
    var users = [User]()
    
    init(tracks: [Track], playlits: [Playlist], users: [User]) {
        self.tracks = tracks
        self.playlists = playlits
        self.users = users
    }
    
    func toDataSource() -> [SearchSectionModel] {
        var sectionModels = [SearchSectionModel]()
        if !tracks.isEmpty {
            sectionModels.append(.track(
                type: .track,
                items: tracks.prefix(3).map { SearchSectionItem.track(type: .track, track: $0)})
            )
        }
        if !users.isEmpty {
            sectionModels.append(.user(
                type: .user,
                items: users.prefix(3).map { SearchSectionItem.user(type: .user, user: $0)})
            )
        }
        if !playlists.isEmpty {
            sectionModels.append(.playlist(
                type: .playlist,
                items: playlists.prefix(3).map { SearchSectionItem.playlist(type: .playlist, playlist: $0)})
            )
        }
        return sectionModels
    }
}
