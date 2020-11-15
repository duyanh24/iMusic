//
//  TrackResultViewModel.swift
//  Mp3App
//
//  Created by AnhLD on 11/3/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class TrackResultViewModel: ServicesViewModel {
    var services: SearchServices!
    private let errorTracker = ErrorTracker()
    private var offset = 0
    private var maxResult = 60
    private var keyword = ""
    private let dataSource = BehaviorRelay<[TrackSectionModel]>(value: [])
    private let isLoadMoreEnabled = BehaviorSubject<Bool>(value: true)
    
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        
        let loadData = input.searchTrack.distinctUntilChanged().flatMapLatest { [weak self] keyword -> Observable<SearchTrackRespone> in
            guard let self = self else {
                return .empty()
            }
            if keyword.replacingOccurrences(of: " ", with: "").isEmpty {
                return .empty()
            }
            self.keyword = keyword
            self.offset = 0
            self.isLoadMoreEnabled.onNext(true)
            return self.searchTrack(keyword: keyword).trackActivity(activityIndicator)
        }.map { searchRespone -> [TrackSectionModel] in
            let tracksRespone = searchRespone.tracks?.filter({ track -> Bool in
                guard let streamable = track.streamable else {
                    return false
                }
                if !streamable || track.title == nil || track.artworkURL == nil {
                    return false
                }
                return true
            })
            return [TrackSectionModel(model: "", items: tracksRespone ?? [])]
        }.do(onNext: { [weak self] trackSectionModel in
            self?.dataSource.accept(trackSectionModel)
        }).mapToVoid()
        
        let loadMoreData = input.loadMore
            .skip(1)
            .flatMapLatest { [weak self] _ -> Observable<SearchTrackRespone> in
                guard let self = self else {
                    return .empty()
                }
                self.offset += 15
                if self.offset > self.maxResult {
                    self.isLoadMoreEnabled.onNext(false)
                }
                return self.searchTrack(keyword: self.keyword, offset: self.offset).trackActivity(activityIndicator)
        }.map { searchRespone -> [TrackSectionModel] in
            let tracksRespone = searchRespone.tracks?.filter({ track -> Bool in
                guard let streamable = track.streamable else {
                    return false
                }
                if !streamable || track.title == nil || track.artworkURL == nil {
                    return false
                }
                return true
            })
            let tracks = (self.dataSource.value.first?.items ?? []) + (tracksRespone ?? [])
            return [TrackSectionModel(model: "", items: tracks)]
        }.do(onNext: { [weak self] trackSectionModel in
            self?.dataSource.accept(trackSectionModel)
        }).mapToVoid()
        
        let playTrack = input.play.do(onNext: { track in
            NotificationCenter.default.post(name: Notification.Name(rawValue: Strings.playerNotification), object: nil, userInfo: [Strings.tracks: [track]])
        }).mapToVoid()
        
        return Output(dataSource: dataSource.asObservable(), activityIndicator: activityIndicator.asObservable(), loadData: loadData, loadMoreData: loadMoreData, isLoadMoreEnabled: isLoadMoreEnabled, playTrack: playTrack)
    }
}

extension TrackResultViewModel {
    struct Input {
        var searchTrack: Observable<String>
        var loadMore: Observable<Void>
        var play: Observable<Track>
    }
    
    struct Output {
        var dataSource: Observable<[TrackSectionModel]>
        var activityIndicator: Observable<Bool>
        var loadData: Observable<Void>
        var loadMoreData: Observable<Void>
        var isLoadMoreEnabled: Observable<Bool>
        var playTrack: Observable<Void>
    }
}

extension TrackResultViewModel {
    private func searchTrack(keyword: String, offset: Int = 0) -> Observable<SearchTrackRespone> {
        return services.searchService.searchTracks(keyword: keyword, offset: offset).trackError(errorTracker)
    }
}
