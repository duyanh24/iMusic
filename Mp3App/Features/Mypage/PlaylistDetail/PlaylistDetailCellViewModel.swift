//
//  PlaylistDetailCellViewModel.swift
//  Mp3App
//
//  Created by Apple on 10/15/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import RxSwift

class PlaylistDetailCellViewModel: ViewModel {
    private let track: Track
    
    init(track: Track) {
        self.track = track
    }
    
    func transform(input: Input) -> Output {
        return Output(track: .just(track))
    }
}

extension PlaylistDetailCellViewModel {
    struct Input {
    }
    
    struct Output {
        var track: Observable<Track>
    }
}
