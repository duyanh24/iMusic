//
//  SettingViewModel.swift
//  Mp3App
//
//  Created by AnhLD on 9/29/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SettingViewModel: ServicesViewModel {
    var services: SettingServices!
    
    func transform(input: Input) -> Output {
        return Output()
    }
}

extension SettingViewModel {
    struct Input {
        
    }
    
    struct Output {
        
    }
}
