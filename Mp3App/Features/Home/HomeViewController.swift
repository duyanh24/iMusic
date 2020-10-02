//
//  HomeViewController.swift
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

class HomeViewController: BaseViewController, StoryboardBased, ViewModelBased {
    var viewModel: HomeViewModel!
    var disposeBag = DisposeBag()
    let loadDataTrigger = PublishSubject<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        loadDataTrigger.onNext(())
    }
    
    private func bindViewModel() {
        let input = HomeViewModel.Input(loadDataTrigger: loadDataTrigger)
        let ouput = viewModel.transform(input: input)
        ouput.homeDataModel.subscribe(onNext: { _ in
            print("ok")
        }).disposed(by: disposeBag)
    }
}
