//
//  LibraryTableViewCellViewModel.swift
//  Mp3App
//
//  Created by Apple on 10/14/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class LibraryTableViewCellViewModel: ViewModel {
    private let libraryTitle: String
    
    init(libraryTitle: String) {
        self.libraryTitle = libraryTitle
    }
    
    func transform(input: Input) -> Output {
        return Output(libraryTitle: .just(libraryTitle))
    }
}

extension LibraryTableViewCellViewModel {
    struct Input {
    }
    
    struct Output {
        var libraryTitle: Observable<String>
    }
}
