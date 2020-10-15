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
    
    func transform(input: Input) -> Output {
        let mypageDataModel = input.loadDataTrigger.flatMapLatest { [weak self] _ -> Observable<MypageScreenDataModel> in
            guard let self = self else {
                return .empty()
            }
            return self.getAllMypageData()
        }.map({ $0.toDataSource()})
        return Output(mypageDataModel: mypageDataModel)
    }
}

extension MypageViewModel {
    struct Input {
        var loadDataTrigger: Observable<Void>
    }
    
    struct Output {
        var mypageDataModel: Observable<[MypageSectionModel]>
    }
}

extension MypageViewModel {
    private func getAllMypageData() -> Observable<MypageScreenDataModel> {
        let playlists = services.playlistService.getAllPlaylist()
            .trackError(errorTracker)
        
        let mypageScreenDataModel = playlists.map { playlists -> MypageScreenDataModel in
            switch playlists {
            case .failure:
                return MypageScreenDataModel(playlists: [])
            case .success(let playlists):
                return MypageScreenDataModel(playlists: playlists)
            }
        }
        return mypageScreenDataModel
    }
}
