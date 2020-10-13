//
//  MypageDataSource.swift
//  Mp3App
//
//  Created by AnhLD on 10/13/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation

import Foundation
import RxDataSources

enum MypageSectionType {
    case interested
    case playlist
    
    var title: String? {
        switch self {
        case .interested:
            return Strings.library
        case .playlist:
            return Strings.playlist
        }
    }
}

enum MypageSectionModel {
    typealias Item = MypageSectionItem
    case interested(type: MypageSectionType, items: [Item])
    case playlist(type: MypageSectionType, items: [Item])
}

enum MypageSectionItem {
    case playlist(type: MypageSectionType, playlist: Playlist)
    case interested(type: MypageSectionType, library: String)
    
}

extension MypageSectionModel: SectionModelType {
    var items: [MypageSectionItem] {
        switch self {
        case .playlist(_, let items):
            return items.map { $0 }
        case .interested(_, let items):
            return items.map { $0 }
        }
    }
    
    var type: MypageSectionType {
        switch self {
        case .playlist(let type, _):
            return type
        case .interested(let type, _):
            return type
        }
    }
    
    init(original: MypageSectionModel, items: [MypageSectionItem]) {
        switch original {
        case let .playlist(type: type, items: _):
            self = .playlist(type: type, items: items)
        case let .interested(type: type, items: _):
            self = .interested(type: type, items: items)
        }
    }
}
