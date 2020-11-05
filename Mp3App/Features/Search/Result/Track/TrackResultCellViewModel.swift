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
        return Output(track: .just(track))
    }
}

extension TrackResultCellViewModel {
    struct Input {
    }
    
    struct Output {
        var track: Observable<Track>
    }
}
