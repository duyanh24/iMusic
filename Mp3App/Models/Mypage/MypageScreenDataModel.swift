//
//  MypageScreenDataModel.swift
//  Mp3App
//
//  Created by AnhLD on 10/13/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation

class MypageScreenDataModel {
    var playlists: [Playlist] = []
    
    init (playlists: [Playlist]) {
        self.playlists = playlists
    }
    
    func toDataSource() -> [MypageSectionModel] {
        var sectionModels = [MypageSectionModel]()
        sectionModels.append(.interested(type: .interested, items: [MypageSectionItem.interested(type: .interested, library: "Bài hát yêu thích")]))
        if !playlists.isEmpty {
            sectionModels.append(.playlist(
                type: .playlist,
                items: playlists.map { MypageSectionItem.playlist(type: .playlist, playlist: $0)})
            )
        }
        return sectionModels
    }
}
