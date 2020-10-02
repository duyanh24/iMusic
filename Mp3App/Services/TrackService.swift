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
    func getPopularTrack(kind: String, limit: Int, offset: Int) -> Observable<TrackListResponse> {
        return HostAPIClient.performApiNetworkCall(router: .getPopularTrack(kind: kind, limit: limit, offset: offset), type: TrackListResponse.self)
    }
    
    func getChartTrack(kind: String, limit: Int, offset: Int) -> Observable<TrackListResponse> {
        return HostAPIClient.performApiNetworkCall(router: .getChartTrack(kind: kind, limit: limit, offset: offset), type: TrackListResponse.self)
    }
    
    func getElectronicAlbums(kind: String, genre: String, limit: Int, offset: Int) -> Observable<TrackListResponse> {
        return HostAPIClient.performApiNetworkCall(router: .getAlbums(kind: APIParameterKey.top.rawValue, genre: TrackGenre.electronic.rawValue, limit: 20, offset: 0), type: TrackListResponse.self)
    }
    
    func getHiphopAlbums(kind: String, genre: String, limit: Int, offset: Int) -> Observable<TrackListResponse> {
        return HostAPIClient.performApiNetworkCall(router: .getAlbums(kind: APIParameterKey.top.rawValue, genre: TrackGenre.hiphop.rawValue, limit: 20, offset: 0), type: TrackListResponse.self)
    }
    
    func getRockAlbums(kind: String, genre: String, limit: Int, offset: Int) -> Observable<TrackListResponse> {
        return HostAPIClient.performApiNetworkCall(router: .getAlbums(kind: APIParameterKey.top.rawValue, genre: TrackGenre.rock.rawValue, limit: 20, offset: 0), type: TrackListResponse.self)
    }
    
    func getClassicalAlbums(kind: String, genre: String, limit: Int, offset: Int) -> Observable<TrackListResponse> {
        return HostAPIClient.performApiNetworkCall(router: .getAlbums(kind: APIParameterKey.top.rawValue, genre: TrackGenre.classical.rawValue, limit: 20, offset: 0), type: TrackListResponse.self)
    }
}
