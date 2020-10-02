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
            return self.getAllHomeData()
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
    private func getAllHomeData() -> Observable<HomeScreenDataModel> {
        let popularTracks = services.trackService.getPopularTrack(kind: APIParameterKey.top.rawValue)
            .trackError(errorTracker)
            .map { $0.albums ?? [] }
            .catchErrorJustReturn([])
        
        let hiphopAlbums = services.trackService.getAlbums(kind: APIParameterKey.top.rawValue, genre: TrackGenre.hiphop.rawValue)
            .trackError(errorTracker)
            .map { $0.albums ?? [] }
            .catchErrorJustReturn([])
        
        let electronicAlbums = services.trackService.getAlbums(kind: APIParameterKey.top.rawValue, genre: TrackGenre.electronic.rawValue)
            .trackError(errorTracker)
            .map { $0.albums ?? [] }
            .catchErrorJustReturn([])
        
        let rockAlbums = services.trackService.getAlbums(kind: APIParameterKey.top.rawValue, genre: TrackGenre.rock.rawValue)
            .trackError(errorTracker)
            .map { $0.albums ?? [] }
            .catchErrorJustReturn([])
        
        let classicalAlbums = services.trackService.getAlbums(kind: APIParameterKey.top.rawValue, genre: TrackGenre.classical.rawValue)
            .trackError(errorTracker)
            .map { $0.albums ?? [] }
            .catchErrorJustReturn([])
        
        let chartTracks = services.trackService.getChartTrack(kind: APIParameterKey.top.rawValue)
            .trackError(errorTracker)
            .map { $0.albums ?? [] }
            .catchErrorJustReturn([])
        
        let popularUsers = services.userService.getPopularUser()
            .trackError(errorTracker)
            .catchErrorJustReturn([])
        
        let homeScreenDataModel = Observable.zip(popularTracks,
                                                 hiphopAlbums,
                                                 electronicAlbums,
                                                 rockAlbums,
                                                 classicalAlbums,
                                                 chartTracks,
                                                 popularUsers)
                                            .map {(popularTracks,
                                                hiphopAlbums,
                                                electronicAlbums,
                                                rockAlbums,
                                                classicalAlbums,
                                                chartTracks,
                                                popularUsers) -> HomeScreenDataModel in

            return HomeScreenDataModel(popularAlbums: popularTracks, electronicAlbums: electronicAlbums, hiphopAlbums: hiphopAlbums, rockAlbums: rockAlbums, classicalAlbums: classicalAlbums, chartTracks: chartTracks, popularUserList: popularUsers)
        }
        return homeScreenDataModel
    }
}
