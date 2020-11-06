//
//  PlaylistResultCellViewModel.swift
//  Mp3App
//
//  Created by Apple on 11/5/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import RxSwift

class PlaylistResultCellViewModel: ViewModel {
    private let playlist: Playlist
    
    init(playlist: Playlist) {
        self.playlist = playlist
    }
    
    func transform(input: Input) -> Output {
        return Output(playlist: .just(playlist))
    }
}

extension PlaylistResultCellViewModel {
    struct Input {
    }
    
    struct Output {
        var playlist: Observable<Playlist>
    }
}
