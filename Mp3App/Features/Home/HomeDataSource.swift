//
//  HomeDataSource.swift
//  Mp3App
//
//  Created by Apple on 10/5/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import RxDataSources

enum HomeSectionType {
    case popularAlbums
    case electronicAlbums
    case hiphopAlbums
    case rockAlbums
    case classicalAlbums
    case chartAlbums
    case popularUsers
    
    var title: String? {
        switch self {
        case .electronicAlbums:
            return Strings.electronic
        case .hiphopAlbums:
            return Strings.hiphop
        case .classicalAlbums:
            return Strings.classical
        case .chartAlbums:
            return Strings.chart
        case .popularUsers:
            return Strings.singer
        case .rockAlbums:
            return Strings.rock
        case .popularAlbums:
            return ""
        }
    }
}

enum HomeSectionModel {
    typealias Item = HomeSectionItem
    case electronicAlbums(type: HomeSectionType, items: [Item])
    case hiphopAlbums(type: HomeSectionType, items: [Item])
    case classicalAlbums(type: HomeSectionType, items: [Item])
    case chartAlbums(type: HomeSectionType, items: [Item])
    case rockAlbums(type: HomeSectionType, items: [Item])
    case popularUsers(type: HomeSectionType, items: [Item])
    case popularAlbums(type: HomeSectionType, items: [Item])
}

enum HomeSectionItem {
    case albumsDefault(type: HomeSectionType, albums: [Album])
    case albumsSlide(type: HomeSectionType, albums: [Album])
    case albumsChart(type: HomeSectionType, albums: [Album])
    case singers(type: HomeSectionType, users: [User])
}

extension HomeSectionModel: SectionModelType {
    var items: [HomeSectionItem] {
        switch self {
        case .electronicAlbums(_, let items):
            return items.map { $0 }
        case .hiphopAlbums(_, let items):
            return items.map { $0 }
        case .classicalAlbums(_, let items):
            return items.map { $0 }
        case .chartAlbums(_, let items):
            return items.map { $0 }
        case .rockAlbums(_, let items):
            return items.map { $0 }
        case .popularUsers(_, let items):
            return items.map { $0 }
        case .popularAlbums(_, let items):
            return items.map { $0 }
        }
    }
    
    var type: HomeSectionType {
        switch self {
        case .electronicAlbums(let type, _):
            return type
        case .hiphopAlbums(let type, _):
            return type
        case .classicalAlbums(let type, _):
            return type
        case .chartAlbums(let type, _):
            return type
        case .rockAlbums(let type, _):
            return type
        case .popularUsers(let type, _):
            return type
        case .popularAlbums(let type, _):
            return type
        }
    }
    
    init(original: HomeSectionModel, items: [HomeSectionItem]) {
        switch original {
        case let .electronicAlbums(type: type, items: _):
            self = .electronicAlbums(type: type, items: items)
        case let .hiphopAlbums(type: type, items: _):
            self = .hiphopAlbums(type: type, items: items)
        case let .classicalAlbums(type: type, items: _):
            self = .classicalAlbums(type: type, items: items)
        case let .chartAlbums(type: type, items: _):
            self = .chartAlbums(type: type, items: items)
        case let .rockAlbums(type: type, items: _):
            self = .rockAlbums(type: type, items: items)
        case let .popularUsers(type: type, items: _):
            self = .popularUsers(type: type, items: items)
        case let .popularAlbums(type: type, items: _):
            self = .popularAlbums(type: type, items: items)
        }
    }
}
