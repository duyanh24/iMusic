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
    private let checkLogin = BehaviorSubject<Bool>(value: false)
    
    init(track: Track) {
        self.track = track
    }
    
    func transform(input: Input) -> Output {
        let addTrackToFavourite = input.addTrackToFavouriteButton
            .withLatestFrom(input.isTrackInFavorites)
            .flatMapLatest { [weak self] isTrackInFavorites -> Observable<Result<Void, Error>> in
                guard let self = self else {
                    return .empty()
                }
                if isTrackInFavorites {
                    return self.services.libraryService.removeTrackInFavourite(trackId: self.track.id ?? 0)
                }
                return self.services.libraryService.addTrackToFavourite(track: self.track)
        }
        
        let checkTrackInFavorites = services.libraryService.checkTrackAlreadyExitsInFavourite(trackId: track.id ?? 0)
        
        let playTrack = input.play.do(onNext: { [weak self] _ in
            NotificationCenter.default.post(name: Notification.Name(rawValue: Strings.playerNotification), object: nil, userInfo: [Strings.tracks: [self?.track]])
        }).mapToVoid()
        
        let email = AccountDefault.shared.retrieveStringData(key: .emailKey)
        email.isEmpty ? checkLogin.onNext(false) : checkLogin.onNext(true)
        
        return Output(track: .just(track),
                      addTrackToFavouriteResult: addTrackToFavourite,
                      checkTrackInFavorites: checkTrackInFavorites,
                      playTrack: playTrack,
                      checkLogin: checkLogin)
    }
}

extension TrackBottomSheetViewModel {
    struct Input {
        var addTrackToFavouriteButton: Observable<Void>
        var isTrackInFavorites: Observable<Bool>
        var play: Observable<Void>
    }
    
    struct Output {
        var track: Observable<Track>
        var addTrackToFavouriteResult: Observable<Result<Void, Error>>
        var checkTrackInFavorites: Observable<Result<Bool, Error>>
        var playTrack: Observable<Void>
        var checkLogin: Observable<Bool>
    }
}
