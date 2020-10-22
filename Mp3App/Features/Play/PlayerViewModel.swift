//
//  PlayerViewModel.swift
//  Mp3App
//
//  Created by AnhLD on 10/22/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PlayerViewModel: ServicesViewModel {
    var services: MypageServices!
    private let errorTracker = ErrorTracker()
    
    func transform(input: Input) -> Output {
        return Output(playlist: getTracksFromPlaylist())
    }
}

extension PlayerViewModel {
    struct Input {
    }
    
    struct Output {
        var playlist: Observable<[Track]>
    }
}

extension PlayerViewModel {
    private func getTracksFromPlaylist() -> Observable<[Track]> {
        return services.playlistService.getTracksFromPlaylist(playlistName: "Nhạc trẻ").trackError(errorTracker)
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
