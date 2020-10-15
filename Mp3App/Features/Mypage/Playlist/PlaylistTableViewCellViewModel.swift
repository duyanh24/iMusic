//
//  PlaylistTableViewCellViewModel.swift
//  Mp3App
//
//  Created by Apple on 10/14/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PlaylistTableViewCellViewModel: ViewModel {
    private let playlist: String
    
    init(playlist: String) {
        self.playlist = playlist
    }
    
    func transform(input: Input) -> Output {
        return Output(playlist: .just(playlist))
    }
}

extension PlaylistTableViewCellViewModel {
    struct Input {
    }
    
    struct Output {
        var playlist: Observable<String>
    }
}
