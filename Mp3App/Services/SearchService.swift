//
//  SearchService.swift
//  Mp3App
//
//  Created by AnhLD on 10/30/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import RxSwift

protocol HasSearchService {
    var searchService: SearchService { get }
}

struct SearchService {
    func searchTracks(keyword: String) -> Observable<SearchTrackRespone> {
        return HostAPIClient.performApiNetworkCall(router: .searchTracks(keyword: keyword), type: SearchTrackRespone.self)
    }
    
    func searchUsers(keyword: String) -> Observable<SearchUserRespone> {
        return HostAPIClient.performApiNetworkCall(router: .searchUsers(keyword: keyword), type: SearchUserRespone.self)
    }
    
    func searchPlaylists(keyword: String) -> Observable<SearchPlaylistRespone> {
        return HostAPIClient.performApiNetworkCall(router: .searchPlaylists(keyword: keyword), type: SearchPlaylistRespone.self)
    }
}
