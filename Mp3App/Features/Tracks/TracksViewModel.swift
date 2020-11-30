//
//  TracksViewModel.swift
//  Mp3App
//
//  Created by AnhLD on 11/6/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class TracksViewModel: ViewModel {
    private var tracks = [Track]()
    private var title = ""
    
    init(tracks: [Track], title: String) {
        self.tracks = tracks
        self.title = title
    }
    
    func transform(input: Input) -> Output {
        let showPlayerView = input.playButton.do(onNext: { [weak self] _ in
            NotificationCenter.default.post(name: Notification.Name(rawValue: Strings.playerNotification), object: nil, userInfo: [Strings.tracks: self?.tracks ?? []])
        }).mapToVoid()
        
        let playTrack = input.play.do(onNext: { track in
            NotificationCenter.default.post(name: Notification.Name(rawValue: Strings.playerNotification), object: nil, userInfo: [Strings.tracks: [track]])
        }).mapToVoid()
        
        return Output(dataSource: .just([TrackSectionModel(model: "", items: tracks)]), showPlayerView: showPlayerView, title: .just(title), playTrack: playTrack)
    }
}

extension TracksViewModel {
    struct Input {
        var playButton: Observable<Void>
        var play: Observable<Track>
    }
    
    struct Output {
        var dataSource: Observable<[TrackSectionModel]>
        var showPlayerView: Observable<Void>
        var title: Observable<String>
        var playTrack: Observable<Void>
    }
}
