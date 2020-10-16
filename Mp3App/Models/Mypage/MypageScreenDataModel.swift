//
//  MypageScreenDataModel.swift
//  Mp3App
//
//  Created by AnhLD on 10/13/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation

class MypageScreenDataModel {
    var playlistNames: [String] = []
    
    init (playlistNames: [String]) {
        self.playlistNames = playlistNames
    }
    
    func toDataSource() -> [MypageSectionModel] {
        var sectionModels = [MypageSectionModel]()
        sectionModels.append(.favourite(type: .favourite, items: [MypageSectionItem.favourite(type: .favourite, libraryTitle: Strings.favouriteSong)]))
        if !playlistNames.isEmpty {
            sectionModels.append(.playlist(
                type: .playlist,
                items: playlistNames.map { MypageSectionItem.playlist(type: .playlist, playlist: $0)})
            )
        }
        return sectionModels
    }
}
