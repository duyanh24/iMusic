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
    private var tracks: [Track] = []
    private let disposeBag = DisposeBag()
    
    init(playlistName: String) {
        self.playlistName = playlistName
    }
    
    func transform(input: Input) -> Output {
        input.playButton.subscribe(onNext: { [weak self] _ in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Strings.PlayerNotification), object: nil, userInfo: [Strings.tracks : self?.tracks ?? []])
        }).disposed(by: disposeBag)
    
        let activityIndicator = ActivityIndicator()
        
        let dataSource = getTracksFromPlaylist().map { [weak self] tracks -> [TrackSectionModel] in
            self?.tracks = tracks
            return [TrackSectionModel(model: "", items: tracks)]
        }.trackActivity(activityIndicator)
        return Output(dataSource: dataSource, playlistName: .just(playlistName), activityIndicator: activityIndicator.asObservable())
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
