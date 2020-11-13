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

class TrackBottomSheetViewModel: ServicesViewModel {
    var services: MypageServices!
    private var track = Track()
    
    init(track: Track) {
        self.track = track
    }
    
    func transform(input: Input) -> Output {
        let addTrackToFavourite = input.addTrackToFavouriteButton
            .withLatestFrom(input.isTrackAlreadyExistsInFavorites)
            .flatMapLatest { [weak self] isTrackAlreadyExistsInFavorites -> Observable<Result<Void, Error>> in
                guard let self = self else {
                    return .empty()
                }
                if isTrackAlreadyExistsInFavorites {
                    return self.services.libraryService.removeTrackInFavourite(trackId: self.track.id ?? 0)
                }
                return self.services.libraryService.addTrackToFavourite(track: self.track)
        }
        
        let checkTrackAlreadyExistsInFavorites = services.libraryService.checkTrackAlreadyExitsInFavourite(trackId: track.id ?? 0)
        
        return Output(track: .just(track),
                      addTrackToFavouriteResult: addTrackToFavourite,
                      isTrackAlreadyExistsInFavorites: checkTrackAlreadyExistsInFavorites)
    }
}

extension TrackBottomSheetViewModel {
    struct Input {
        var addTrackToFavouriteButton: Observable<Void>
        var isTrackAlreadyExistsInFavorites: Observable<Bool>
    }
    
    struct Output {
        var track: Observable<Track>
        var addTrackToFavouriteResult: Observable<Result<Void, Error>>
        var isTrackAlreadyExistsInFavorites: Observable<Result<Bool, Error>>
    }
}
