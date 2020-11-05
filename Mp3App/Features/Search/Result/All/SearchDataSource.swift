//
//  SearchDataSource.swift
//  Mp3App
//
//  Created by AnhLD on 11/5/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import RxDataSources

enum SearchSectionType {
    case track
    case playlist
    case user
    
    var title: String? {
        switch self {
        case .track:
            return Strings.track
        case .playlist:
            return Strings.playlist
        case .user:
            return Strings.artist
        }
    }
}

enum SearchSectionModel {
    typealias Item = SearchSectionItem
    case track(type: SearchSectionType, items: [Item])
    case playlist(type: SearchSectionType, items: [Item])
    case user(type: SearchSectionType, items: [Item])
}

enum SearchSectionItem {
    case playlist(type: SearchSectionType, playlist: Playlist)
    case track(type: SearchSectionType, track: Track)
    case user(type: SearchSectionType, user: User)
}

extension SearchSectionModel: SectionModelType {
    var items: [SearchSectionItem] {
        switch self {
        case .playlist(_, let items):
            return items.map { $0 }
        case .track(_, let items):
            return items.map { $0 }
        case .user(_, let items):
            return items.map { $0 }
        }
    }
    
    var type: SearchSectionType {
        switch self {
        case .playlist(let type, _):
            return type
        case .track(let type, _):
            return type
        case .user(let type, _):
            return type
        }
    }
    
    init(original: SearchSectionModel, items: [SearchSectionItem]) {
        switch original {
        case let .playlist(type: type, items: _):
            self = .playlist(type: type, items: items)
        case let .track(type: type, items: _):
            self = .track(type: type, items: items)
        case let .user(type: type, items: _):
            self = .user(type: type, items: items)
        }
    }
}
