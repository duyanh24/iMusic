//
//  PlaylistResultViewModel.swift
//  Mp3App
//
//  Created by Apple on 11/5/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PlaylistResultViewModel: ServicesViewModel {
    var services: SearchServices!
    private let errorTracker = ErrorTracker()
    
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        
        let dataSource = input.searchPlaylist.distinctUntilChanged().flatMapLatest { [weak self] keyword -> Observable<SearchPlaylistRespone> in
            guard let self = self else {
                return .empty()
            }
            return self.searchPlaylists(keyword: keyword)
        }.map { searchUserRespone -> [PlaylistSectionModel] in
            return [PlaylistSectionModel(model: "", items: searchUserRespone.playlists ?? [])]
        }.trackActivity(activityIndicator)
        
        return Output(dataSource: dataSource, activityIndicator: activityIndicator.asObservable())
    }
}

extension PlaylistResultViewModel {
    struct Input {
        var searchPlaylist: Observable<String>
    }
    
    struct Output {
        var dataSource: Observable<[PlaylistSectionModel]>
        var activityIndicator: Observable<Bool>
    }
}

extension PlaylistResultViewModel {
    private func searchPlaylists(keyword: String) -> Observable<SearchPlaylistRespone> {
        return services.searchService.searchPlaylists(keyword: keyword).trackError(errorTracker)
    }
}
