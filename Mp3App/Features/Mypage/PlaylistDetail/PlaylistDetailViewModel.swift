//
//  PlaylistDetailViewModel.swift
//  Mp3App
//
//  Created by Apple on 10/14/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PlaylistDetailViewModel: ServicesViewModel {
    var services: MypageServices!
    private let errorTracker = ErrorTracker()
    private var playlistName: String
    
    init(playlistName: String) {
        self.playlistName = playlistName
    }
    
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        
        let tracks = getTracksFromPlaylist()
        let showPlayerView = input.playButton.withLatestFrom(tracks).do(onNext: { trackList in
            NotificationCenter.default.post(name: Notification.Name(rawValue: Strings.PlayerNotification), object: nil, userInfo: [Strings.tracks: trackList])
            }).mapToVoid()
        
        let dataSource = tracks.map { tracks -> [TrackSectionModel] in
            return [TrackSectionModel(model: "", items: tracks)]
        }.trackActivity(activityIndicator)
        return Output(dataSource: dataSource, playlistName: .just(playlistName), activityIndicator: activityIndicator.asObservable(), showPlayerView: showPlayerView)
    }
}

extension PlaylistDetailViewModel {
    struct Input {
        var playButton: Observable<Void>
    }
    
    struct Output {
        var dataSource: Observable<[TrackSectionModel]>
        var playlistName: Observable<String>
        var activityIndicator: Observable<Bool>
        var showPlayerView: Observable<Void>
    }
}

extension PlaylistDetailViewModel {
    private func getTracksFromPlaylist() -> Observable<[Track]> {
        return services.playlistService.getTracksFromPlaylist(playlistName: playlistName).trackError(errorTracker)
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
