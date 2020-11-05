//
//  HomeScreenDataModel.swift
//  Mp3App
//
//  Created by AnhLD on 10/1/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation

class HomeScreenDataModel {
    var popularAlbums = [Album]()
    var electronicAlbums = [Album]()
    var hiphopAlbums = [Album]()
    var rockAlbums = [Album]()
    var classicalAlbums = [Album]()
    var chartTracks = [Album]()
    var popularUsers = [User]()
    
    init (popularAlbums: [Album], electronicAlbums: [Album], hiphopAlbums: [Album], rockAlbums: [Album], classicalAlbums: [Album], chartTracks: [Album], popularUsers: [User]) {
        self.popularAlbums = popularAlbums
        self.electronicAlbums = electronicAlbums
        self.hiphopAlbums = hiphopAlbums
        self.rockAlbums = rockAlbums
        self.classicalAlbums = classicalAlbums
        self.chartTracks = chartTracks
        self.popularUsers = popularUsers
    }
    
    func toDataSource() -> [HomeSectionModel] {
        var sectionModels = [HomeSectionModel]()
        
        if !popularAlbums.isEmpty {
            sectionModels.append(.popularAlbums(type: .popularAlbums,
                                               items: [.albumsSlide(type: .popularAlbums, albums: popularAlbums.compactMap { $0 })])
            )
        }
        if !electronicAlbums.isEmpty {
            sectionModels.append(.electronicAlbums(type: .electronicAlbums,
                                                   items: [.albumsDefault(type: .electronicAlbums, albums: electronicAlbums.compactMap { $0 })])
            )
        }
        if !hiphopAlbums.isEmpty {
            sectionModels.append(.hiphopAlbums(type: .hiphopAlbums,
                                               items: [.albumsDefault(type: .hiphopAlbums, albums: hiphopAlbums.compactMap { $0 })])
            )
        }
        if !chartTracks.isEmpty {
            sectionModels.append(.chartAlbums(
                type: .chartAlbums,
                items: Array(chartTracks.prefix(5)).map { HomeSectionItem.albumsChart(type: .chartAlbums, albums: $0)})
            )
        }
        if !rockAlbums.isEmpty {
            sectionModels.append(.rockAlbums(type: .rockAlbums,
                                            items: [.albumsDefault(type: .rockAlbums, albums: rockAlbums.compactMap { $0 })])
            )
        }
        if !classicalAlbums.isEmpty {
            sectionModels.append(.classicalAlbums(type: .classicalAlbums,
                                                  items: [.albumsDefault(type: .classicalAlbums, albums: classicalAlbums.compactMap { $0 })])
            )
        }
        
//        if !popularUsers.isEmpty {
//            sectionModels.append(.popularUsers(type: .popularUsers,
//                                               items: [.singers(type: .popularUsers, users: popularUsers.compactMap { $0 })])
//            )
//        }
        return sectionModels
    }
}
