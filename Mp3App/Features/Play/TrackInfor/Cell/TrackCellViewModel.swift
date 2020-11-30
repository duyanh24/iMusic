//
//  File.swift
//  Mp3App
//
//  Created by AnhLD on 10/22/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class TrackCellViewModel : ViewModel {
    private let track: Track
    
    init(track: Track) {
        self.track = track
    }
    
    func transform(input: Input) -> Output {
        let isCurrentTrack = TrackPlayer.shared.currentTrack.flatMapLatest { [weak self] currentTrack -> Observable<Bool> in
            guard let track = self?.track, let currentTrack = currentTrack else {
                return .just(false)
            }
            if track.id == currentTrack.id {
                return .just(true)
            }
            return .just(false)
        }
        
        let isPlaying = Observable.combineLatest(isCurrentTrack, TrackPlayer.shared.isPlayingTrigger)
        return Output(track: .just(track), isPlaying: isPlaying, isCurrentTrack: isCurrentTrack)
    }
}

extension TrackCellViewModel {
    struct Input {
    }
    
    struct Output {
        var track: Observable<Track>
        var isPlaying: Observable<(Bool, Bool)>
        var isCurrentTrack: Observable<Bool>
    }
}
