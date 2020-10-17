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

class PlaylisDetailViewModel: ServicesViewModel {
    var services: MypageServices!
    private let errorTracker = ErrorTracker()
    private var playlistName: String
    
    init(playlistName: String) {
        self.playlistName = playlistName    }
    
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        
        let dataSource = getTracksFromPlaylist().map { tracks -> [TrackSectionModel] in
            return [TrackSectionModel(model: "", items: tracks)]
        }.trackActivity(activityIndicator)
        return Output(dataSource: dataSource, playlistName: .just(playlistName), activityIndicator: activityIndicator.asObservable())
    }
}

extension PlaylisDetailViewModel {
    struct Input {
    }
    
    struct Output {
        var dataSource: Observable<[TrackSectionModel]>
        var playlistName: Observable<String>
        var activityIndicator: Observable<Bool>
    }
}

extension PlaylisDetailViewModel {
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
