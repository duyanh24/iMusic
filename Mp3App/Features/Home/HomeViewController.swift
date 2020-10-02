//
//  HomeViewController.swift
//  Mp3App
//
//  Created by AnhLD on 9/29/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa

class HomeViewController: BaseViewController, StoryboardBased, ViewModelBased {
    var viewModel: HomeViewModel!
    private let disposeBag = DisposeBag()
    private let loadDataTrigger = PublishSubject<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        loadData()
    }
    
    private func loadData() {
        loadDataTrigger.onNext(())
    }
    
    private func bindViewModel() {
        let input = HomeViewModel.Input(loadDataTrigger: loadDataTrigger)
        let ouput = viewModel.transform(input: input)
        ouput.homeDataModel.subscribe(onNext: { homeScreenDataModel in
            print("-----------------------")
            print(homeScreenDataModel.hiphopAlbums)
        }).disposed(by: disposeBag)
    }
}
