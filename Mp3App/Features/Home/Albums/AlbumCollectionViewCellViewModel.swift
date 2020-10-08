//
//  AlbumCollectionViewCellViewModel.swift
//  Mp3App
//
//  Created by Apple on 10/6/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AlbumCollectionViewCellViewModel: ViewModel {
    private let album: Album
    
    init(album: Album) {
        self.album = album
    }
    
    func transform(input: Input) -> Output {
        return Output(album: .just(album))
    }
}

extension AlbumCollectionViewCellViewModel {
    struct Input {
    }
    
    struct Output {
        var album: Driver<Album>
    }
}
