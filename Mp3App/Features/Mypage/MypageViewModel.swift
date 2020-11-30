//
//  MypageViewModel.swift
//  Mp3App
//
//  Created by AnhLD on 9/29/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MypageViewModel: ServicesViewModel {
    var services: MypageServices!
    private let errorTracker = ErrorTracker()
    private let checkLogin = BehaviorSubject<Bool>(value: false)
    
    func transform(input: Input) -> Output {
        let mypageDataModel = input.loadDataTrigger.flatMapLatest { [weak self] _ -> Observable<MypageScreenDataModel> in
            guard let self = self else {
                return .empty()
            }
            return self.getAllMypageData()
        }.map({ $0.toDataSource()})
        
        let deletePlaylistResult = input.deletePlaylist
            .flatMapLatest { [weak self] playlistName -> Observable<Result<Void, Error>> in
                guard let self = self else {
                    return .empty()
                }
                return self.services.playlistService.deletePlaylist(playlistName: playlistName)
        }
        
        let email = AccountDefault.shared.retrieveStringData(key: .emailKey)
        email.isEmpty ? checkLogin.onNext(false) : checkLogin.onNext(true)
        
        return Output(mypageDataModel: mypageDataModel,
                      deletePlaylistResult: deletePlaylistResult,
                      checkLogin: checkLogin)
    }
}

extension MypageViewModel {
    struct Input {
        var loadDataTrigger: Observable<Void>
        var deletePlaylist: Observable<String>
    }
    
    struct Output {
        var mypageDataModel: Observable<[MypageSectionModel]>
        var deletePlaylistResult: Observable<Result<Void, Error>>
        var checkLogin: Observable<Bool>
    }
}

extension MypageViewModel {
    private func getAllMypageData() -> Observable<MypageScreenDataModel> {
        return services.playlistService.getAllPlaylist().trackError(errorTracker)
            .map { playlists -> MypageScreenDataModel in
                switch playlists {
                case .failure:
                    return MypageScreenDataModel(playlistNames: [])
                case .success(let playlists):
                    return MypageScreenDataModel(playlistNames: playlists)
                }
        }
    }
}
