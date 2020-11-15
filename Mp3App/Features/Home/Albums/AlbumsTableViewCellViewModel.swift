//
//  AlbumsTableViewCellViewModel.swift
//  Mp3App
//
//  Created by Apple on 10/6/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class AlbumsTableViewCellViewModel: ViewModel {
    private let albums: [Album]
    private let type: HomeSectionType
    private let contentOffset: CGPoint
    
    init(type: HomeSectionType, albums: [Album], contentOffset: CGPoint) {
        self.albums = albums
        self.type = type
        self.contentOffset = contentOffset
    }
    
    func transform(input: Input) -> Output {
        let playTrack = input.play.do(onNext: { album in
            NotificationCenter.default.post(name: Notification.Name(rawValue: Strings.playerNotification), object: nil, userInfo: [Strings.tracks: [album.track]])
        }).mapToVoid()
        
        return Output(dataSource: .just([AlbumSectionModel(model: "", items: albums)]),
                      homeSectionType: .just(type),
                      contentOffset: Driver.just(self.contentOffset), playTrack: playTrack)
    }
}

extension AlbumsTableViewCellViewModel {
    struct Input {
        var play: Observable<Album>
    }
    
    struct Output {
        var dataSource: Driver<[AlbumSectionModel]>
        var homeSectionType: Driver<HomeSectionType>
        var contentOffset: Driver<CGPoint>
        var playTrack: Observable<Void>
    }
}
