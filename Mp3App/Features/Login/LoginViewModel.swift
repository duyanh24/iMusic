//
//  LoginViewModel.swift
//  Mp3App
//
//  Created by AnhLD on 9/29/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel: ServicesViewModel {
    var services: LoginServices!
    
    func transform(input: Input) -> Output {
        return Output()
    }
}

extension LoginViewModel {
    struct Input {
        
    }
    
    struct Output {
        
    }
}
