//
//  AllResultViewModel.swift
//  Mp3App
//
//  Created by AnhLD on 11/5/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AllResultViewModel: ServicesViewModel {
    var services: SearchServices!
    private let errorTracker = ErrorTracker()
    
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        
        let dataSource = input.searchAll.distinctUntilChanged().flatMapLatest { [weak self] keyword -> Observable<SearchDataModel> in
            guard let self = self else {
                return .empty()
            }
            if keyword.replacingOccurrences(of: " ", with: "").isEmpty {
                return .empty()
            }
            return self.searchAll(keyword: keyword).trackActivity(activityIndicator)
        }.map { $0.toDataSource() }
        
        return Output(dataSource: dataSource, activityIndicator: activityIndicator.asObservable())
    }
}

extension AllResultViewModel {
    struct Input {
        var searchAll: Observable<String>
    }
    
    struct Output {
        var dataSource: Observable<[SearchSectionModel]>
        var activityIndicator: Observable<Bool>
    }
}

extension AllResultViewModel {
    private func searchAll(keyword: String) -> Observable<SearchDataModel> {
        return services.searchService
            .searchAll(keyword: keyword)
            .trackError(errorTracker)
            .map { searchAllRespone -> SearchDataModel in
                var tracks = [Track]()
                var users = [User]()
                var playlists = [Playlist]()
                for data in searchAllRespone.data! {
                    switch data {
                    case .track(let track):
                        tracks.append(track)
                    case .user(let user):
                        users.append(user)
                    case .playlist(let playlist):
                        playlists.append(playlist)
                    }
                }
                return SearchDataModel(tracks: tracks, playlits: playlists, users: users)
            }
    }
}
