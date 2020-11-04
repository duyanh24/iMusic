//
//  TrackResultViewModel.swift
//  Mp3App
//
//  Created by AnhLD on 11/3/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class TrackResultViewModel: ServicesViewModel {
    var services: SearchServices!
    private let errorTracker = ErrorTracker()
    
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        
        let dataSource = input.searchTrack.distinctUntilChanged().flatMapLatest { [weak self] keyword -> Observable<SearchRespone> in
            guard let self = self else {
                return .empty()
            }
            print("test : \(keyword)")
            return self.searchTrack(keyword: keyword)
        }.map { searchRespone -> [TrackSectionModel] in
            return [TrackSectionModel(model: "", items: searchRespone.tracks ?? [])]
        }.trackActivity(activityIndicator)
        
        return Output(dataSource: dataSource, activityIndicator: activityIndicator.asObservable())
    }
}

extension TrackResultViewModel {
    struct Input {
        var searchTrack: Observable<String>
    }
    
    struct Output {
        var dataSource: Observable<[TrackSectionModel]>
        var activityIndicator: Observable<Bool>
    }
}

extension TrackResultViewModel {
    private func searchTrack(keyword: String) -> Observable<SearchRespone> {
        return services.searchService.searchTrack(keyword: keyword).trackError(errorTracker)
    }
}
