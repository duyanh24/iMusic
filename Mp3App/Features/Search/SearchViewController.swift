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
    @IBOutlet weak var resultContainerView: UIView!
    
    var viewModel: SearchViewModel!
    private let disposeBag = DisposeBag()
    private let resultController = ResultViewController()
    
    override func loadView() {
        super.loadView()
        setupResultView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func prepareUI() {
        super.prepareUI()
        setupSearchBar()
    }
    
    private func setupResultView() {
        addChild(resultController)
        resultController.view.frame = resultContainerView.bounds
        resultContainerView.addSubview(resultController.view)
        resultController.didMove(toParent: self)
        resultContainerView.isHidden = true
    }
    
    private func setupSearchBar() {
        searchBar.backgroundColor = .none
        searchBar.placeholder = Strings.searchPlaceholder
        searchBar.searchBarStyle = .minimal
    }
    
    private func bindViewModel() {
        let keyword = searchBar.rx.text.asObservable()
            .distinctUntilChanged()
            .debounce(DispatchTimeInterval.milliseconds(200), scheduler: MainScheduler.instance)
            .compactMap { $0 }
            .filter { !$0.replacingOccurrences(of: " ", with: "").isEmpty }
        
        let input = SearchViewModel.Input(keyWord: keyword)
        let output = viewModel.transform(input: input)
        
        output.tracks.subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
        
        searchBar.rx.text.subscribe(onNext: { [weak self] text in
            guard let text = text else {
                self?.resultContainerView.isHidden = true
                return
            }
            self?.resultContainerView.isHidden = text.replacingOccurrences(of: " ", with: "").isEmpty
        })
        .disposed(by: disposeBag)
    }
}
