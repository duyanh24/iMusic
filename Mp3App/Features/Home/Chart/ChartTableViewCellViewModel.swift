//
//  ChartTableViewCellViewModel.swift
//  Mp3App
//
//  Created by AnhLD on 10/6/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ChartTableViewCellViewModel: ViewModel {
    private let album: Album
    private let rank: Int
    
    init(album: Album, rank: Int) {
        self.album = album
        self.rank = rank
    }
    
    func transform(input: Input) -> Output {
        let showTrackOption = input.optionButton.do(onNext: { [weak self] _ in
            guard let track = self?.album.track else {
                return
            }
            NotificationCenter.default.post(name: Notification.Name(rawValue: Strings.ShowTrackOption), object: nil, userInfo: [Strings.tracks: track])
        }).mapToVoid()
        return Output(albumData: .just(album), rank: .just(rank), showTrackOption: showTrackOption)
    }
}

extension ChartTableViewCellViewModel {
    struct Input {
        var optionButton: Observable<Void>
    }
    
    struct Output {
        var albumData: Driver<Album>
        var rank: Driver<Int>
        var showTrackOption: Observable<Void>
    }
}
