//
//  HomeScreenDataModel.swift
//  Mp3App
//
//  Created by AnhLD on 10/1/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation

class HomeScreenDataModel {
    var popularAlbums: [Album] = []
    var electronicAlbums: [Album] = []
    var hiphopAlbums: [Album] = []
    var rockAlbums: [Album] = []
    var classicalAlbums: [Album] = []
    var chartTracks: [Album] = []
    var popularUsers: [User] = []
    
    init (popularAlbums: [Album], electronicAlbums: [Album], hiphopAlbums: [Album], rockAlbums: [Album], classicalAlbums: [Album], chartTracks: [Album], popularUserList: [User]) {
        self.popularAlbums = popularAlbums
        self.electronicAlbums = electronicAlbums
        self.hiphopAlbums = hiphopAlbums
        self.rockAlbums = rockAlbums
        self.classicalAlbums = classicalAlbums
        self.chartTracks = chartTracks
        self.popularUsers = popularUserList
    }
}
