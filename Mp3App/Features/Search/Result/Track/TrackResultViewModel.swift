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
    private var keyword = ""
    
    init(keyword: String) {
        self.keyword = keyword
    }
    
    func transform(input: Input) -> Output {
        
        return Output()
    }
}

extension TrackResultViewModel {
    struct Input {
    }
    
    struct Output {
    }
}

extension TrackResultViewModel {
    
}
