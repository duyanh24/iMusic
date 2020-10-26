//
//  PlayerViewModel.swift
//  Mp3App
//
//  Created by AnhLD on 10/22/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PlayerViewModel: ServicesViewModel {
    var services: PlayerServices!
    private let errorTracker = ErrorTracker()
    private var tracksPlayer: [Track]
    
    init(tracksPlayer: [Track]) {
        self.tracksPlayer = tracksPlayer
    }
    
    func transform(input: Input) -> Output {
        Player.tracks = tracksPlayer
        Player.startPlayTracks()
        
        let nextTrack = input.nextButton.do(onNext: { _ in
            Player.nextTrack()
        }).mapToVoid()
        
        let playTrack = input.playButton.do(onNext: { _ in
            Player.playTrack()
            print("ok")
        }).mapToVoid()
        
        return Output(playlist: .just(tracksPlayer), nextTrack: nextTrack, playTrack: playTrack, currentTime: Player.currentTime, duration: Player.duration)
    }
}

extension PlayerViewModel {
    struct Input {
        var nextButton: Observable<Void>
        var playButton: Observable<Void>
    }
    
    struct Output {
        var playlist: Observable<[Track]>
        var nextTrack: Observable<Void>
        var playTrack: Observable<Void>
        var currentTime: Observable<Int>
        var duration: Observable<Int>
    }
}
