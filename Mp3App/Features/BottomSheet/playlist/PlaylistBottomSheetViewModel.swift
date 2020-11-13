//
//  PlaylistBottomSheetViewModel.swift
//  Mp3App
//
//  Created by AnhLD on 11/12/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PlaylistBottomSheetViewModel: ServicesViewModel {
    var services: MypageServices!
    private var track = Track()
    private let errorTracker = ErrorTracker()
    
    init(track: Track) {
        self.track = track
    }
    
    func transform(input: Input) -> Output {
        let dataSource = getAllPlaylist().map { playlists -> [PlaylistNameSectionModel] in
            return [PlaylistNameSectionModel(model: "", items: playlists)]
        }
        
        let addTrackToPlaylist = input.itemSelected
            .flatMapLatest { [weak self] playlistName -> Observable<Result<Void, Error>> in
                guard let self = self else {
                    return .empty()
                }
                return self.services.playlistService.addTrackToPlaylist(playlistName: playlistName, track: self.track)
        }
        
        return Output(dataSource: dataSource, addTrackToPlaylistResult: addTrackToPlaylist)
    }
}

extension PlaylistBottomSheetViewModel {
    struct Input {
        var itemSelected: Observable<String>
    }
    
    struct Output {
        var dataSource: Observable<[PlaylistNameSectionModel]>
        var addTrackToPlaylistResult: Observable<Result<Void, Error>>
    }
}

extension PlaylistBottomSheetViewModel {
    private func getAllPlaylist() -> Observable<[String]> {
        return services.playlistService.getAllPlaylist().trackError(errorTracker)
            .map { playlists -> [String] in
                switch playlists {
                case .failure:
                    return []
                case .success(let playlists):
                    return playlists
                }
        }
    }
}
