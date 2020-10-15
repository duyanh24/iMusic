//
//  File.swift
//  Mp3App
//
//  Created by AnhLD on 10/15/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import RxSwift

class CreatePlaylistViewModel: ServicesViewModel {
    var services: MypageServices!
    
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        
        let isCreatePlaylistEnabled = input.newPlaylist
            .map { [weak self] newPlaylist -> Bool in
                guard let self = self, let newPlaylist = newPlaylist
                    else { return false }
                return self.validatePlaylist(newPlaylist: newPlaylist)
        }
        
        let createPlaylistResult =  input.createPlaylist.withLatestFrom(input.newPlaylist)
            .flatMapLatest({ [weak self] newPlaylist -> Observable<Result<Void, Error>> in
                guard let self = self, let newPlaylist = newPlaylist else {
                    return .empty()
                }
                return self.services.playlistService.createPlaylist(newPlaylist: newPlaylist).trackActivity(activityIndicator)
            })

        return Output(createPlaylistResult: createPlaylistResult, activityIndicator: activityIndicator.asObservable(), isCreatePlaylistEnabled: isCreatePlaylistEnabled)
    }
    
    func validatePlaylist(newPlaylist: String) -> Bool {
        return newPlaylist.count > 0
    }
}

extension CreatePlaylistViewModel {
    struct Input {
        var createPlaylist: Observable<Void>
        var newPlaylist: Observable<String?>
    }
    
    struct Output {
        var createPlaylistResult: Observable<Result<Void, Error>>
        var activityIndicator: Observable<Bool>
        var isCreatePlaylistEnabled: Observable<Bool>
    }
}
