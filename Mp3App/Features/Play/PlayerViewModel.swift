//
//  PlayerViewModel.swift
//  Mp3App
//
//  Created by AnhLD on 10/22/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
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
        return Output(playlist: .just(tracksPlayer))
    }
}

extension PlayerViewModel {
    struct Input {
    }
    
    struct Output {
        var playlist: Observable<[Track]>
    }
}
