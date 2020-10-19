//
//  SettingViewController.swift
//  Mp3App
//
//  Created by AnhLD on 9/29/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import UIKit
import Reusable
import RxSwift
import RxCocoa

class SettingViewController: BaseViewController, StoryboardBased, ViewModelBased {
    @IBOutlet weak var logoutButton: UIButton!
    
    var viewModel: SettingViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = SettingViewModel.Input(logout: logoutButton.rx.tap.asObservable())
        let output = viewModel.transform(input: input)
        output.logoutSuccess.subscribe(onNext: { _ in
            SceneCoordinator.shared.transition(to: Scene.login)
        })
        .disposed(by: disposeBag)
    }
}
