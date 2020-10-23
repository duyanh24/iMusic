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
    private var tracks: [Track] = []
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        input.playButton.subscribe(onNext: { [weak self] _ in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Strings.PlayerNotification), object: nil, userInfo: [Strings.tracks : self?.tracks ?? []])
        }).disposed(by: disposeBag)
        
        let activityIndicator = ActivityIndicator()
        
        let dataSource = getTracksFromFavourite().map { [weak self] tracks -> [TrackSectionModel] in
            self?.tracks = tracks
            return [TrackSectionModel(model: "", items: tracks)]
        }.trackActivity(activityIndicator)
        
        return Output(dataSource: dataSource, activityIndicator: activityIndicator.asObservable())
    }
}

extension LibraryDetailViewModel {
    struct Input {
        var playButton: Observable<Void>
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
