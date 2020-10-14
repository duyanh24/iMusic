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
    private let library: String
    
    init(library: String) {
        self.library = library
    }
    
    func transform(input: Input) -> Output {
        return Output(library: .just(library))
    }
}

extension LibraryTableViewCellViewModel {
    struct Input {
    }
    
    struct Output {
        var library: Observable<String>
    }
}
