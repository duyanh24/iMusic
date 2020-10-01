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

class TrackService {
    func getPopularTrack() -> Observable<TrackListResponse> {
        return HostAPIClient.performApiNetworkCall(router: .getPopularTrack(kind: APIParameterKey.top.rawValue, limit: 5, offset: 0), type: TrackListResponse.self)
    }
    
    func getChartTrack() -> Observable<TrackListResponse> {
        return HostAPIClient.performApiNetworkCall(router: .getChartTrack(kind: APIParameterKey.top.rawValue, limit: 20, offset: 0), type: TrackListResponse.self)
    }
    
    func getElectronicPlaylist() -> Observable<TrackListResponse> {
        return HostAPIClient.performApiNetworkCall(router: .getPlaylist(kind: APIParameterKey.top.rawValue, genre: TrackGenre.electronic.rawValue, limit: 20, offset: 0), type: TrackListResponse.self)
    }
    
    func getHiphopPlaylist() -> Observable<TrackListResponse> {
        return HostAPIClient.performApiNetworkCall(router: .getPlaylist(kind: APIParameterKey.top.rawValue, genre: TrackGenre.hiphop.rawValue, limit: 20, offset: 0), type: TrackListResponse.self)
    }
    
    func getRockPlaylist() -> Observable<TrackListResponse> {
        return HostAPIClient.performApiNetworkCall(router: .getPlaylist(kind: APIParameterKey.top.rawValue, genre: TrackGenre.rock.rawValue, limit: 20, offset: 0), type: TrackListResponse.self)
    }
    
    func getClassicalPlaylist() -> Observable<TrackListResponse> {
        return HostAPIClient.performApiNetworkCall(router: .getPlaylist(kind: APIParameterKey.top.rawValue, genre: TrackGenre.classical.rawValue, limit: 20, offset: 0), type: TrackListResponse.self)
    }
}
