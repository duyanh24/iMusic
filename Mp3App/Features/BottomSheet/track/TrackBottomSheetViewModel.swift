//
//  TrackBottomSheetViewModel.swift
//  Mp3App
//
//  Created by Apple on 11/11/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class TrackBottomSheetViewModel: ViewModel {
    private var track = Track()
    
    init(track: Track) {
        self.track = track
    }
    
    func transform(input: Input) -> Output {
        return Output(track: .just(track))
    }
}

extension TrackBottomSheetViewModel {
    struct Input {
    }
    
    struct Output {
        var track: Observable<Track>
    }
}
