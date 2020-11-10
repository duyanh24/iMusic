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
    func searchTracks(keyword: String, offset: Int, limit: Int = 15) -> Observable<SearchTrackRespone> {
        return HostAPIClient.performApiNetworkCall(router: .searchTracks(keyword: keyword, offset: offset, litmit: limit), type: SearchTrackRespone.self)
    }
    
    func searchUsers(keyword: String, offset: Int, limit: Int = 15) -> Observable<SearchUserRespone> {
        return HostAPIClient.performApiNetworkCall(router: .searchUsers(keyword: keyword, offset: offset, litmit: limit), type: SearchUserRespone.self)
    }
    
    func searchPlaylists(keyword: String, offset: Int, limit: Int = 15) -> Observable<SearchPlaylistRespone> {
        return HostAPIClient.performApiNetworkCall(router: .searchPlaylists(keyword: keyword, offset: offset, litmit: limit), type: SearchPlaylistRespone.self)
    }
    
    func searchAll(keyword: String) -> Observable<SearchDataRespone> {
        return HostAPIClient.performApiNetworkCall(router: .searchAll(keyword: keyword), type: SearchDataRespone.self)
    }
    
    func saveSearchHistory(keyword: String) {
        let oldHistory = SearchHistoryDefault.shared.retrieveData(key: .searchHistory)
        var newHistory = oldHistory.filter { $0 != keyword }
        newHistory.insert(keyword, at: 0)
        SearchHistoryDefault.shared.saveData(data: newHistory, key: .searchHistory)
    }
}
