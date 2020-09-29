//
//  SplashViewModel.swift
//  Mp3App
//
//  Created by AnhLD on 9/29/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SplashViewModel: ViewModel {
    func transform(input: Input) -> Output {
        let splashFinish = Observable.just(())
            .delay(DispatchTimeInterval.seconds(3), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: ())
        return Output(splashFinish: splashFinish)
    }
}

extension SplashViewModel {
    struct Input {
        
    }
    
    struct Output {
        var splashFinish: Driver<Void>
    }
}
