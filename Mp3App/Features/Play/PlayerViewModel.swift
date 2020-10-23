//
//  PlayerViewModel.swift
//  Mp3App
//
//  Created by AnhLD on 10/22/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PlayerViewModel: ServicesViewModel {
    var services: PlayerServices!
    private let errorTracker = ErrorTracker()
    private var hidePlayerViewTrigger = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    private var tracksPlayer = PublishSubject<[Track]>()
    
    init(hidePlayerViewClicked: PublishSubject<Void>, tracksPlayer: PublishSubject<[Track]>) {
        self.hidePlayerViewTrigger = hidePlayerViewClicked
        self.tracksPlayer = tracksPlayer
    }
    
    func transform(input: Input) -> Output {
        input.hidePlayerViewButton.subscribe(onNext: { [weak self] _ in
            self?.hidePlayerViewTrigger.onNext(())
        })
        .disposed(by: disposeBag)
        return Output(playlist: tracksPlayer)
    }
}

extension PlayerViewModel {
    struct Input {
        var hidePlayerViewButton: Observable<Void>
    }
    
    struct Output {
        var playlist: Observable<[Track]>
    }
}
