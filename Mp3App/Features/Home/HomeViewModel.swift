//
//  HomeViewModel.swift
//  Mp3App
//
//  Created by AnhLD on 9/29/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel: ServicesViewModel {
    var services: HomeServices!
    private let errorTracker = ErrorTracker()
    
    func transform(input: Input) -> Output {
        let homeDataModel = input.loadDataTrigger.flatMapLatest { [weak self] _ -> Observable<HomeScreenDataModel> in
            guard let self = self else {
                return .empty()
            }
            return self.getAllDataHome()
        }
        return Output(homeDataModel: homeDataModel)
    }
}

extension HomeViewModel {
    struct Input {
        var loadDataTrigger: Observable<Void>
    }
    
    struct Output {
        var homeDataModel: Observable<HomeScreenDataModel>
    }
}

extension HomeViewModel {
    private func getAllDataHome() -> Observable<HomeScreenDataModel> {
        let popularTrack = services.trackService.getPopularTrack(kind: APIParameterKey.top.rawValue, limit: 5, offset: 0)
            .trackError(errorTracker)
            .map { $0.albums ?? [] }
            .catchErrorJustReturn([])
        
        let hiphopAlbums = services.trackService.getHiphopAlbums(kind: APIParameterKey.top.rawValue, genre: TrackGenre.hiphop.rawValue, limit: 20, offset: 0)
            .trackError(errorTracker)
            .map { $0.albums ?? [] }
            .catchErrorJustReturn([])
        
        let electronicAlbums  = services.trackService.getElectronicAlbums(kind: APIParameterKey.top.rawValue, genre: TrackGenre.electronic.rawValue, limit: 20, offset: 0)
            .trackError(errorTracker)
            .map { $0.albums ?? [] }
            .catchErrorJustReturn([])
        
        let rockAlbums  = services.trackService.getRockAlbums(kind: APIParameterKey.top.rawValue, genre: TrackGenre.rock.rawValue, limit: 20, offset: 0)
            .trackError(errorTracker)
            .map { $0.albums ?? [] }
            .catchErrorJustReturn([])
        
        let classicalAlbums  = services.trackService.getClassicalAlbums(kind: APIParameterKey.top.rawValue, genre: TrackGenre.classical.rawValue, limit: 20, offset: 0)
            .trackError(errorTracker)
            .map { $0.albums ?? [] }
            .catchErrorJustReturn([])
        
        let chartTrack = services.trackService.getChartTrack(kind: APIParameterKey.top.rawValue, limit: 20, offset: 0)
            .trackError(errorTracker)
            .map { $0.albums ?? [] }
            .catchErrorJustReturn([])
        
        let popularUser = services.userService.getPopularUser(limit: 20, offset: 0)
            .trackError(errorTracker)
            .catchErrorJustReturn([])
        
        let homeScreenDataModel = Observable.zip(popularTrack,
                                                 hiphopAlbums,
                                                 electronicAlbums,
                                                 rockAlbums,
                                                 classicalAlbums,
                                                 chartTrack,
                                                 popularUser)
                                            .map {(popularTrack,
                                                hiphopAlbums,
                                                electronicAlbums,
                                                rockAlbums,
                                                classicalAlbums,
                                                chartTrack,
                                                popularUser) -> HomeScreenDataModel in

            return HomeScreenDataModel(popularAlbums: popularTrack, electronicAlbums: electronicAlbums, hiphopAlbums: hiphopAlbums, rockAlbums: rockAlbums, classicalAlbums: classicalAlbums, chartTrackList: chartTrack, popularUserList: popularUser)
        }
        return homeScreenDataModel
    }
}
