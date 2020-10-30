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
    
    func transform(input: Input) -> Output {
        let startPlayTracks = input.tracks.do(onNext: { tracks in
            TrackPlayer.shared.tracks = tracks
            TrackPlayer.shared.startPlayTracks()
        }).mapToVoid()
        
        let nextTrack = input.nextButton.do(onNext: { _ in
            TrackPlayer.shared.nextTrack()
        }).mapToVoid()
        
        let playTrack = input.playButton.do(onNext: { _ in
            TrackPlayer.shared.playContinue()
        }).mapToVoid()
        
        let prevTrack = input.prevButton.do(onNext: { _ in
            TrackPlayer.shared.prevTrack()
        }).mapToVoid()
        
        let seekTrack = input.seekValueSlider.do(onNext: { value in
            TrackPlayer.shared.seek(seconds: value)
        }).mapToVoid()
        
        let randomMode = input.randomModeButton.do(onNext: { _ in
            TrackPlayer.shared.setupRandomMode()
        }).mapToVoid()
        
        let repeatMode = input.repeatModeButton.do(onNext: { _ in
            TrackPlayer.shared.setupRepeatMode()
        }).mapToVoid()
        
        return Output(playList: Observable.combineLatest(input.tracks, TrackPlayer.shared.currentTrack),
                      nextTrack: nextTrack,
                      prevTrack: prevTrack,
                      playTrack: playTrack,
                      currentTime: TrackPlayer.shared.currentTime,
                      duration: TrackPlayer.shared.duration,
                      startPlayTracks: startPlayTracks,
                      isPlaying: TrackPlayer.shared.isPlayingTrigger,
                      currentTrack: TrackPlayer.shared.currentTrack.asObservable(),
                      seekTrack: seekTrack,
                      randomMode: randomMode,
                      isRandomModeSelected: TrackPlayer.shared.randomMode.asObservable(),
                      repeatMode: repeatMode,
                      isRepeatModeSelected: TrackPlayer.shared.repeatMode.asObservable())
    }
}

extension PlayerViewModel {
    struct Input {
        var prevButton: Observable<Void>
        var nextButton: Observable<Void>
        var playButton: Observable<Void>
        var randomModeButton: Observable<Void>
        var repeatModeButton: Observable<Void>
        var tracks: Observable<[Track]>
        var seekValueSlider: Observable<Float>
    }
    
    struct Output {
        var playList: Observable<([Track], Track?)>
        var nextTrack: Observable<Void>
        var prevTrack: Observable<Void>
        var playTrack: Observable<Void>
        var currentTime: Observable<Int>
        var duration: Observable<Int>
        var startPlayTracks: Observable<Void>
        var isPlaying: Observable<Bool>
        var currentTrack: Observable<Track?>
        var seekTrack: Observable<Void>
        var randomMode: Observable<Void>
        var isRandomModeSelected: Observable<Bool>
        var repeatMode: Observable<Void>
        var isRepeatModeSelected: Observable<Bool>
    }
}
