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
    private var offset = 0
    private var maxResult = 60
    private var keyword = ""
    private let dataSource = BehaviorRelay<[PlaylistSectionModel]>(value: [])
    private let isLoadMoreEnabled = BehaviorSubject<Bool>(value: true)
    
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        
        let loadData = input.searchPlaylist.distinctUntilChanged().flatMapLatest { [weak self] keyword -> Observable<SearchPlaylistRespone> in
            guard let self = self else {
                return .empty()
            }
            if keyword.replacingOccurrences(of: " ", with: "").isEmpty {
                return .empty()
            }
            self.keyword = keyword
            self.offset = 0
            self.isLoadMoreEnabled.onNext(true)
            return self.searchPlaylists(keyword: keyword).trackActivity(activityIndicator)
        }.map { searchPlaylistRespone -> [PlaylistSectionModel] in
            return [PlaylistSectionModel(model: "", items: searchPlaylistRespone.playlists ?? [])]
        }.do(onNext: { [weak self] playlistSectionModel in
            self?.dataSource.accept(playlistSectionModel)
        }).mapToVoid()
        
        let loadMoreData = input.loadMore
            .skip(1)
            .flatMapLatest { [weak self] _ -> Observable<SearchPlaylistRespone> in
                guard let self = self else {
                    return .empty()
                }
                self.offset += 15
                if self.offset > self.maxResult {
                    self.isLoadMoreEnabled.onNext(false)
                }
                return self.searchPlaylists(keyword: self.keyword, offset: self.offset).trackActivity(activityIndicator)
        }.map { searchRespone -> [PlaylistSectionModel] in
            let users = (self.dataSource.value.first?.items ?? []) + (searchRespone.playlists ?? [])
            return [PlaylistSectionModel(model: "", items: users)]
        }.do(onNext: { [weak self] playlistSectionModel in
            self?.dataSource.accept(playlistSectionModel)
        }).mapToVoid()
        
        return Output(dataSource: dataSource.asObservable(), activityIndicator: activityIndicator.asObservable(), loadData: loadData, loadMoreData: loadMoreData, isLoadMoreEnabled: isLoadMoreEnabled)
    }
}

extension PlaylistResultViewModel {
    struct Input {
        var searchPlaylist: Observable<String>
        var loadMore: Observable<Void>
    }
    
    struct Output {
        var dataSource: Observable<[PlaylistSectionModel]>
        var activityIndicator: Observable<Bool>
        var loadData: Observable<Void>
        var loadMoreData: Observable<Void>
        var isLoadMoreEnabled: Observable<Bool>
    }
}

extension PlaylistResultViewModel {
    private func searchPlaylists(keyword: String, offset: Int = 0) -> Observable<SearchPlaylistRespone> {
        return services.searchService.searchPlaylists(keyword: keyword, offset: offset).trackError(errorTracker)
    }
}
