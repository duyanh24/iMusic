//
//  LibraryDetailViewModel.swift
//  Mp3App
//
//  Created by Apple on 10/18/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class LibraryDetailViewModel: ServicesViewModel {
    var services: MypageServices!
    private let errorTracker = ErrorTracker()
    
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        
        let tracks = getTracksFromFavourite()
        let showPlayerView = input.playButton.withLatestFrom(tracks).do(onNext: { trackList in
            NotificationCenter.default.post(name: Notification.Name(rawValue: Strings.playerNotification), object: nil, userInfo: [Strings.tracks: trackList])
            }).mapToVoid()
        
        let dataSource = getTracksFromFavourite().map { tracks -> [TrackSectionModel] in
            return [TrackSectionModel(model: "", items: tracks)]
        }.trackActivity(activityIndicator)
        
        let playTrack = input.play.do(onNext: { track in
            NotificationCenter.default.post(name: Notification.Name(rawValue: Strings.playerNotification), object: nil, userInfo: [Strings.tracks: [track]])
        }).mapToVoid()
        
        return Output(dataSource: dataSource, activityIndicator: activityIndicator.asObservable(), showPlayerView: showPlayerView, playTrack: playTrack)
    }
}

extension LibraryDetailViewModel {
    struct Input {
        var playButton: Observable<Void>
        var play: Observable<Track>
    }
    
    struct Output {
        var dataSource: Observable<[TrackSectionModel]>
        var activityIndicator: Observable<Bool>
        var showPlayerView: Observable<Void>
        var playTrack: Observable<Void>
    }
}

extension LibraryDetailViewModel {
    private func getTracksFromFavourite() -> Observable<[Track]> {
        return services.libraryService.getTracksFromFavourite().trackError(errorTracker)
            .map { result -> [Track] in
                switch result {
                case .failure:
                    return []
                case .success(let tracks):
                    return tracks
                }
        }
    }
}
