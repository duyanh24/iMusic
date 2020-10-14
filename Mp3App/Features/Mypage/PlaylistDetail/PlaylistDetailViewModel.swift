//
//  PlaylistDetailViewModel.swift
//  Mp3App
//
//  Created by Apple on 10/14/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import RxSwift

class PlaylisDetailViewModel: ServicesViewModel {
    var services: MypageServices!
    private let errorTracker = ErrorTracker()
    private var playlist: String
    
    init(playlist: String) {
        self.playlist = playlist
    }
    
    func transform(input: Input) -> Output {
//        let dataSource = services.playlistService.getAlbumsFromPlaylist(playlist: playlist)
//            .flatMapLatest { [weak self] listTrackId -> Observable<[AlbumSectionModel]> in
//                guard let self = self else {
//                    return .empty()
//                }
//                return self.getAllTrack(listTrackId: listTrackId)
//        }
//
        return Output()
    }
}

extension PlaylisDetailViewModel {
    struct Input {
    }
    
    struct Output {
        //var dataSource: Observable<[AlbumSectionModel]>
    }
}

extension PlaylisDetailViewModel {
//    private func getAllTrack(listTrackId: [String]) -> Observable<[AlbumSectionModel]> {
//
//    }
}
