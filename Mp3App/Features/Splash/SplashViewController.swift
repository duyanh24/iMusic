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
    private let checkLogin = PublishSubject<Bool>()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = SplashViewModel.Input(checkLogin: checkLogin)
        let output = viewModel.transform(input: input)
        
        output.loginResult
        .subscribe(onNext: { [weak self] result in
            switch result {
            case .failure:
                self?.checkLogin.onNext(false)
                SceneCoordinator.shared.transition(to: Scene.tabbar)
            case .success:
                self?.checkLogin.onNext(true)
                SceneCoordinator.shared.transition(to: Scene.tabbar)
            }
        })
        .disposed(by: disposeBag)
        
        output.cleanDataAccount.subscribe().disposed(by: disposeBag)
    }
}
