//
//  TrackInformationViewModel.swift
//  Mp3App
//
//  Created by AnhLD on 10/22/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class TrackInformationViewModel: ViewModel {
    private let tracks: [Track]
    private let currentTrack: Track?
    
    init(tracks: [Track], currentTrack: Track?) {
        self.tracks = tracks
        self.currentTrack = currentTrack
    }
    
    func transform(input: Input) -> Output {
        if let currentTrack = currentTrack {
            let tracksTransform = tracks.map ({ track -> Track in
                if track.id == currentTrack.id {
                    var trackTransform = track
                    trackTransform.isPlaying = true
                    return trackTransform
                }
                return track
            })
            return Output(dataSource: .just([TrackSectionModel(model: "", items: [currentTrack] + tracksTransform)]))
        }
        guard let firstItem = tracks.first else {
            return Output(dataSource: .just([TrackSectionModel(model: "", items: tracks)]))
        }
        return Output(dataSource: .just([TrackSectionModel(model: "", items: [firstItem] + tracks)]))
    }
}

extension TrackInformationViewModel {
    struct Input {
    }
    
    struct Output {
        var dataSource: Driver<[TrackSectionModel]>
    }
}
