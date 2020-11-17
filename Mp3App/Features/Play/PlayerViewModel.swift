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
    private var isTrackAlreadyExistsInFavorites = false
    
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
        
        let randomMode = input.changeRandomMode.do(onNext: { _ in
            TrackPlayer.shared.setupRandomMode()
        }).mapToVoid()
        
        let repeatMode = input.changeRepeatMode.do(onNext: { _ in
            TrackPlayer.shared.setupRepeatMode()
        }).mapToVoid()
        
        let checkTrackAlreadyExistsInFavorites = TrackPlayer.shared.currentTrack.flatMapLatest { [weak self] track -> Observable<Result<Bool, Error>> in
            guard let self = self else {
                return .empty()
            }
            return self.services.libraryService.checkTrackAlreadyExitsInFavourite(trackId: track?.id ?? 0)
        }.map { result -> Bool in
            switch result {
            case .success(let value):
                self.isTrackAlreadyExistsInFavorites = value
                return value
            case .failure(let error):
                print(error.localizedDescription)
                return false
            }
        }
        
        let addTrackToFavourite = input.addTrackToFavourite
            .withLatestFrom(TrackPlayer.shared.currentTrack)
            .flatMapLatest { [weak self] track -> Observable<Result<Void, Error>> in
                guard let self = self, let trackId = track?.id, let track = track else {
                    return .just(Result(error: APIError(statusCode: nil, statusMessage: ErrorMessage.unknownError)))
                }
                if self.isTrackAlreadyExistsInFavorites {
                    self.isTrackAlreadyExistsInFavorites = false
                    return self.services.libraryService.removeTrackInFavourite(trackId: trackId)
                }
                self.isTrackAlreadyExistsInFavorites = true
                return self.services.libraryService.addTrackToFavourite(track: track)
        }
        
        let showPlaylist = input.addTrackToPlaylist
            .withLatestFrom(TrackPlayer.shared.currentTrack)
            .flatMapLatest { track -> Observable<Void> in
                guard let track = track else {
                    return .empty()
                }
                NotificationCenter.default.post(name: Notification.Name(rawValue: Strings.ShowPlaylistOption), object: nil, userInfo: [Strings.tracks: track])
                return.empty()
        }
        
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
                      isRepeatModeSelected: TrackPlayer.shared.repeatMode.asObservable(),
                      isTrackAlreadyExistsInFavorites: checkTrackAlreadyExistsInFavorites,
                      addTrackToFavouriteResult: addTrackToFavourite,
                      showPlaylist: showPlaylist)
    }
}

extension PlayerViewModel {
    struct Input {
        var prevButton: Observable<Void>
        var nextButton: Observable<Void>
        var playButton: Observable<Void>
        var changeRandomMode: Observable<Void>
        var changeRepeatMode: Observable<Void>
        var tracks: Observable<[Track]>
        var seekValueSlider: Observable<Float>
        var addTrackToFavourite: Observable<Void>
        var addTrackToPlaylist: Observable<Void>
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
        var isTrackAlreadyExistsInFavorites: Observable<Bool>
        var addTrackToFavouriteResult: Observable<Result<Void, Error>>
        var showPlaylist: Observable<Void>
    }
}
