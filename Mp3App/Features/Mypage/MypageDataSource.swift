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
    case favourite
    case playlist
    
    var title: String? {
        switch self {
        case .favourite:
            return Strings.library
        case .playlist:
            return Strings.playlist
        }
    }
}

enum MypageSectionModel {
    typealias Item = MypageSectionItem
    case favourite(type: MypageSectionType, items: [Item])
    case playlist(type: MypageSectionType, items: [Item])
}

enum MypageSectionItem {
    case playlist(type: MypageSectionType, playlist: String)
    case favourite(type: MypageSectionType, library: String)
    
}

extension MypageSectionModel: SectionModelType {
    var items: [MypageSectionItem] {
        switch self {
        case .playlist(_, let items):
            return items.map { $0 }
        case .favourite(_, let items):
            return items.map { $0 }
        }
    }
    
    var type: MypageSectionType {
        switch self {
        case .playlist(let type, _):
            return type
        case .favourite(let type, _):
            return type
        }
    }
    
    init(original: MypageSectionModel, items: [MypageSectionItem]) {
        switch original {
        case let .playlist(type: type, items: _):
            self = .playlist(type: type, items: items)
        case let .favourite(type: type, items: _):
            self = .favourite(type: type, items: items)
        }
    }
}
