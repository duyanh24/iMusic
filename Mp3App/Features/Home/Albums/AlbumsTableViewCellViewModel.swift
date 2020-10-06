//
//  AlbumsTableViewCellViewModel.swift
//  Mp3App
//
//  Created by Apple on 10/6/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
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
        return Output(dataSource: .just([AlbumSectionModel(model: "", items: albums)]),
                      homeSectionType: .just(type),
                      contentOffset: Driver.just(self.contentOffset))
    }
}

extension AlbumsTableViewCellViewModel {
    struct Input {
    }
    
    struct Output {
        var dataSource: Driver<[MovieSectionModel]>
        var homeSectionType: Driver<HomeSectionType>
        var contentOffset: Driver<CGPoint>
    }
}
