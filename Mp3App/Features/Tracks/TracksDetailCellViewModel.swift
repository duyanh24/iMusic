//
//  TracksCellViewModel.swift
//  Mp3App
//
//  Created by AnhLD on 11/6/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import RxSwift

class TracksDetailCellViewModel: ViewModel {
    private let track: Track
    
    init(track: Track) {
        self.track = track
    }
    
    func transform(input: Input) -> Output {
        return Output(track: .just(track))
    }
}

extension TracksDetailCellViewModel {
    struct Input {
    }
    
    struct Output {
        var track: Observable<Track>
    }
}
