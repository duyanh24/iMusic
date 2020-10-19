//
//  LibraryDetailViewModel.swift
//  Mp3App
//
//  Created by Apple on 10/18/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class LibraryDetailViewModel: ServicesViewModel {
    var services: MypageServices!
    private let errorTracker = ErrorTracker()
    
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        
        let dataSource = getTracksFromFavourite().map { tracks -> [TrackSectionModel] in
            return [TrackSectionModel(model: "", items: tracks)]
        }.trackActivity(activityIndicator)
        
        return Output(dataSource: dataSource, activityIndicator: activityIndicator.asObservable())
    }
}

extension LibraryDetailViewModel {
    struct Input {
    }
    
    struct Output {
        var dataSource: Observable<[TrackSectionModel]>
        var activityIndicator: Observable<Bool>
    }
}

extension LibraryDetailViewModel {
    private func getTracksFromFavourite() -> Observable<[Track]> {
        return services.libraryService.getTracksFromFavourite().trackError(errorTracker)
            .map { result -> [Track] in
                switch result {
                case .failure:
                    return []
                case .success(let tracks):
                    return tracks
                }
        }
    }
}
