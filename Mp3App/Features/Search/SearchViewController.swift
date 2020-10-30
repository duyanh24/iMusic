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
        searchBar.rx.text.subscribe(onNext: { value in
            self.label.text = value
        }).disposed(by: disposeBag)
    }
}
