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
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    
    var viewModel: SplashViewModel!
    private let bag = DisposeBag()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func prepareUI() {
        super.prepareUI()
        setupUI()
    }
    
    private func setupUI() {
        backgroundImageView.image = Asset.splashScreenNormal.image
        logoImageView.image = Asset.logoNormal.image
    }
    
    private func bind() {
        let input = SplashViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.splashFinish
            .drive(onNext: { _ in
                SceneCoordinator.shared.transition(to: Scene.login)
            })
            .disposed(by: bag)
    }
}
