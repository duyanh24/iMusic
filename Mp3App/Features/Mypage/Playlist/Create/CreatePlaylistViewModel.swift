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
        
        let isCreatePlaylistEnabled = input.newPlaylistName
            .map { newPlaylistName -> Bool in
                guard let newPlaylistName = newPlaylistName
                    else { return false }
                return !newPlaylistName.isEmpty
        }
        
        let createPlaylistResult =  input.createPlaylist.withLatestFrom(input.newPlaylistName)
            .flatMapLatest({ [weak self] newPlaylistName -> Observable<Result<Void, Error>> in
                guard let self = self, let newPlaylistName = newPlaylistName else {
                    return .empty()
                }
                return self.services.playlistService.createPlaylist(newPlaylist: newPlaylistName).trackActivity(activityIndicator)
            })

        return Output(createPlaylistResult: createPlaylistResult, activityIndicator: activityIndicator.asObservable(), isCreatePlaylistEnabled: isCreatePlaylistEnabled)
    }
}

extension CreatePlaylistViewModel {
    struct Input {
        var createPlaylist: Observable<Void>
        var newPlaylistName: Observable<String?>
    }
    
    struct Output {
        var createPlaylistResult: Observable<Result<Void, Error>>
        var activityIndicator: Observable<Bool>
        var isCreatePlaylistEnabled: Observable<Bool>
    }
}
