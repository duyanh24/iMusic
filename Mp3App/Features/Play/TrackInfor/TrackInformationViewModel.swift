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
    
    init(tracks: [Track]) {
        self.tracks = tracks
    }
    
    func transform(input: Input) -> Output {
        return Output(dataSource: .just([TrackSectionModel(model: "", items: tracks)]))
    }
}

extension TrackInformationViewModel {
    struct Input {
    }
    
    struct Output {
        var dataSource: Driver<[TrackSectionModel]>
    }
}
