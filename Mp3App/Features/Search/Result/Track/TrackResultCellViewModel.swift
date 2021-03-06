//
//  TrackResultCellViewModel.swift
//  Mp3App
//
//  Created by Apple on 11/5/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import RxSwift

class TrackResultCellViewModel: ViewModel {
    private let track: Track
    
    init(track: Track) {
        self.track = track
    }
    
    func transform(input: Input) -> Output {
        let showTrackOption = input.optionButton.do(onNext: { [weak self] _ in
            guard let track = self?.track else {
                return
            }
            NotificationCenter.default.post(name: Notification.Name(rawValue: Strings.ShowTrackOption), object: nil, userInfo: [Strings.tracks: track])
        }).mapToVoid()
        
        return Output(track: .just(track), showTrackOption: showTrackOption)
    }
}

extension TrackResultCellViewModel {
    struct Input {
        var optionButton: Observable<Void>
    }
    
    struct Output {
        var track: Observable<Track>
        var showTrackOption: Observable<Void>
    }
}
