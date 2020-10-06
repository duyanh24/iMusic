//
//  ChartTableViewCellViewModel.swift
//  Mp3App
//
//  Created by AnhLD on 10/6/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ChartTableViewCellViewModel: ViewModel {
    private let album: Album
    private let rank: Int
    
    init(album: Album, rank: Int) {
        self.album = album
        self.rank = rank
    }
    
    func transform(input: Input) -> Output {
        return Output(dataSource: .just(album), rank: .just(rank))
    }
}

extension ChartTableViewCellViewModel {
    struct Input {
    }
    
    struct Output {
        var dataSource: Driver<Album>
        var rank: Driver<Int>
    }
}
