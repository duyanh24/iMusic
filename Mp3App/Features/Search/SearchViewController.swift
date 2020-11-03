//
//  SearchViewController.swift
//  Mp3App
//
//  Created by AnhLD on 9/29/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Reusable

class SearchViewController: BaseViewController, StoryboardBased, ViewModelBased {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var label: UILabel!
    
    var viewModel: SearchViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let keyword = searchBar.rx.text.asObservable()
            .distinctUntilChanged()
            .debounce(DispatchTimeInterval.milliseconds(200), scheduler: MainScheduler.instance)
            .compactMap { $0 }
            .filter { !$0.replacingOccurrences(of: " ", with: "").isEmpty }
        
        let input = SearchViewModel.Input(keyWord: keyword )
        let output = viewModel.transform(input: input)
        
        output.tracks.subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
    }
}
