//
//  HomeViewModel.swift
//  Mp3App
//
//  Created by AnhLD on 9/29/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewModel: ServicesViewModel {
    var services: HomeServices!
    private let errorTracker = ErrorTracker()
    var collectionViewContentOffsetDictionary: [HomeSectionType: CGPoint] = [:]
    
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        
        let homeDataModel = input.loadDataTrigger.flatMapLatest { [weak self] _ -> Observable<HomeScreenDataModel> in
            guard let self = self else {
                return .empty()
            }
            return self.getAllHomeData().trackActivity(activityIndicator)
        }.map({ $0.toDataSource()})
        
        let playTrack = input.play.do(onNext: { homeSectionItem in
            switch homeSectionItem {
            case .albumsChart(_, let album):
                NotificationCenter.default.post(name: Notification.Name(rawValue: Strings.playerNotification), object: nil, userInfo: [Strings.tracks: [album.track]])
            default:
                break
            }
            
        }).mapToVoid()
        
        return Output(homeDataModel: homeDataModel,
                    activityIndicator: activityIndicator.asObservable(),
                    playTrack: playTrack)
    }
}

extension HomeViewModel {
    struct Input {
        var loadDataTrigger: Observable<Void>
        var play: Observable<HomeSectionItem>
    }
    
    struct Output {
        var homeDataModel: Observable<[HomeSectionModel]>
        var activityIndicator: Observable<Bool>
        var playTrack: Observable<Void>
    }
}

extension HomeViewModel {
    private func getAllHomeData() -> Observable<HomeScreenDataModel> {
        let popularAlbums = services.trackService.getPopularAlbums(kind: APIParameterKey.top)
            .trackError(errorTracker)
            .map { $0.albums ?? [] }
            .catchErrorJustReturn([])
        
        let hiphopAlbums = services.trackService.getAlbums(kind: APIParameterKey.top, genre: TrackGenre.hiphop)
            .trackError(errorTracker)
            .map { $0.albums ?? [] }
            .catchErrorJustReturn([])
        
        let electronicAlbums = services.trackService.getAlbums(kind: APIParameterKey.top, genre: TrackGenre.electronic)
            .trackError(errorTracker)
            .map { $0.albums ?? [] }
            .catchErrorJustReturn([])
        
        let rockAlbums = services.trackService.getAlbums(kind: APIParameterKey.top, genre: TrackGenre.rock)
            .trackError(errorTracker)
            .map { $0.albums ?? [] }
            .catchErrorJustReturn([])
        
        let classicalAlbums = services.trackService.getAlbums(kind: APIParameterKey.top, genre: TrackGenre.classical)
            .trackError(errorTracker)
            .map { $0.albums ?? [] }
            .catchErrorJustReturn([])
        
        let chartTracks = services.trackService.getChartTrack(kind: APIParameterKey.top)
            .trackError(errorTracker)
            .map { $0.albums ?? [] }
            .catchErrorJustReturn([])
        
        let popularUsers = services.userService.getPopularUser()
            .trackError(errorTracker)
            .catchErrorJustReturn([])
        
        let homeScreenDataModel = Observable.zip(popularAlbums,
                                                 hiphopAlbums,
                                                 electronicAlbums,
                                                 rockAlbums,
                                                 classicalAlbums,
                                                 chartTracks,
                                                 popularUsers)
                                            .map {(popularAlbums,
                                                hiphopAlbums,
                                                electronicAlbums,
                                                rockAlbums,
                                                classicalAlbums,
                                                chartTracks,
                                                popularUsers) -> HomeScreenDataModel in

            return HomeScreenDataModel(popularAlbums: popularAlbums, electronicAlbums: electronicAlbums, hiphopAlbums: hiphopAlbums, rockAlbums: rockAlbums, classicalAlbums: classicalAlbums, chartTracks: chartTracks, popularUsers: popularUsers)
        }
        return homeScreenDataModel
    }
}
