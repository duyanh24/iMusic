//
//  SearchViewModel.swift
//  Mp3App
//
//  Created by AnhLD on 9/29/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SearchViewModel: ServicesViewModel {
    var services: SearchServices!
    
    func transform(input: Input) -> Output {
        let tracks = input.keyWord.flatMapLatest { [weak self] keyWord -> Observable<[Track]> in
            guard let self = self else {
                return .empty()
            }
            return self.services.searchService.searchTrack(keyWord: keyWord).map {($0.tracks ?? [])}
        }
        return Output(tracks: tracks)
    }
}

extension SearchViewModel {
    struct Input {
        var keyWord: Observable<String>
    }
    
    struct Output {
        var tracks: Observable<[Track]>
    }
}
