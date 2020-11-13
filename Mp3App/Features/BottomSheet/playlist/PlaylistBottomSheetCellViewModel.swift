//
//  PlaylistBottomSheetCellViewModel.swift
//  Mp3App
//
//  Created by AnhLD on 11/12/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PlaylistBottomSheetCellViewModel: ViewModel {
    private let playlistName: String
    
    init(playlistName: String) {
        self.playlistName = playlistName
    }
    
    func transform(input: Input) -> Output {
        return Output(playlistName: .just(playlistName))
    }
}

extension PlaylistBottomSheetCellViewModel {
    struct Input {
    }
    
    struct Output {
        var playlistName: Observable<String>
    }
}
