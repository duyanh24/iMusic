//
//  SplashViewController.swift
//  Mp3App
//
//  Created by AnhLD on 9/29/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Reusable

class SplashViewController: BaseViewController, StoryboardBased, ViewModelBased {
    var viewModel: SplashViewModel!
    private let disposeBag = DisposeBag()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = SplashViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.loginResult
        .subscribe(onNext: { result in
            switch result {
            case .failure:
                SceneCoordinator.shared.transition(to: Scene.login)
            case .success:
                SceneCoordinator.shared.transition(to: Scene.tabbar)
            }
        })
        .disposed(by: disposeBag)
    }
}
