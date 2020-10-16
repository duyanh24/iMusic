//
//  MypageScreenDataModel.swift
//  Mp3App
//
//  Created by AnhLD on 10/13/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation

class MypageScreenDataModel {
    var playlistName: [String] = []
    
    init (playlistName: [String]) {
        self.playlistName = playlistName
    }
    
    func toDataSource() -> [MypageSectionModel] {
        var sectionModels = [MypageSectionModel]()
        sectionModels.append(.favourite(type: .favourite, items: [MypageSectionItem.favourite(type: .favourite, libraryTitle: Strings.favouriteSong)]))
        if !playlistName.isEmpty {
            sectionModels.append(.playlist(
                type: .playlist,
                items: playlistName.map { MypageSectionItem.playlist(type: .playlist, playlist: $0)})
            )
        }
        return sectionModels
    }
}
