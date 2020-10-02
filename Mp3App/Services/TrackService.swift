//
//  TrackService.swift
//  Mp3App
//
//  Created by AnhLD on 10/1/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import RxSwift

protocol HasTrackService {
    var trackService: TrackService { get }
}

struct TrackService {
    func getPopularTrack(kind: String, limit: Int = 5, offset: Int = 0) -> Observable<TrackListResponse> {
        return HostAPIClient.performApiNetworkCall(router: .getPopularTrack(kind: kind, limit: limit, offset: offset), type: TrackListResponse.self)
    }
    
    func getChartTrack(kind: String, limit: Int = 20, offset: Int = 0) -> Observable<TrackListResponse> {
        return HostAPIClient.performApiNetworkCall(router: .getChartTrack(kind: kind, limit: limit, offset: offset), type: TrackListResponse.self)
    }
    
    func getAlbums(kind: String, genre: String, limit: Int = 20, offset: Int = 0) -> Observable<TrackListResponse> {
        return HostAPIClient.performApiNetworkCall(router: .getAlbums(kind: kind, genre: genre, limit: limit, offset: offset), type: TrackListResponse.self)
    }
}
