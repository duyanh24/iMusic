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
        let popularTrack = services.trackService.getPopularTrack()
            .trackError(errorTracker)
            .map { $0.playlist ?? [] }
            .catchErrorJustReturn([])
        
        let hiphopPlaylist = services.trackService.getHiphopPlaylist()
            .trackError(errorTracker)
            .map { $0.playlist ?? [] }
            .catchErrorJustReturn([])
        
        let electronicPlaylist = services.trackService.getElectronicPlaylist()
            .trackError(errorTracker)
            .map { $0.playlist ?? [] }
            .catchErrorJustReturn([])
        
        let rockPlaylist = services.trackService.getElectronicPlaylist()
            .trackError(errorTracker)
            .map { $0.playlist ?? [] }
            .catchErrorJustReturn([])
        
        let classicalPlaylist = services.trackService.getElectronicPlaylist()
            .trackError(errorTracker)
            .map { $0.playlist ?? [] }
            .catchErrorJustReturn([])
        
        let chartTrack = services.trackService.getElectronicPlaylist()
            .trackError(errorTracker)
            .map { $0.playlist ?? [] }
            .catchErrorJustReturn([])
        
        let popularUser = services.userService.getPopularUser()
            .trackError(errorTracker)
            .catchErrorJustReturn([])
        
        let homeScreenDataModel = Observable.zip(popularTrack,
                                                 hiphopPlaylist,
                                                 electronicPlaylist,
                                                 rockPlaylist,
                                                 classicalPlaylist,
                                                 chartTrack,
                                                 popularUser)
                                            .map {(popularTrack,
                                                hiphopPlaylist,
                                                electronicPlaylist,
                                                rockPlaylist,
                                                classicalPlaylist,
                                                chartTrack,
                                                popularUser) -> HomeScreenDataModel in
            let homeScreenDataModel = HomeScreenDataModel()
            homeScreenDataModel.listElectronicPlaylist = electronicPlaylist
            homeScreenDataModel.listPopularTrack = popularTrack
            homeScreenDataModel.listHiphopPlaylist = hiphopPlaylist
            homeScreenDataModel.listRockPlaylist = rockPlaylist
            homeScreenDataModel.listClassicalPlaylist = classicalPlaylist
            homeScreenDataModel.listChartTrack = chartTrack
            homeScreenDataModel.listPopularUser = popularUser
            return homeScreenDataModel
        }
        return homeScreenDataModel
    }
}
