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
    @IBOutlet weak var searchTextField: CustomTextField!
    @IBOutlet weak var resultContainerView: UIView!
    
    var viewModel: SearchViewModel!
    private let disposeBag = DisposeBag()
    private let resultController = ResultViewController()
    private var keywordTrigger = PublishSubject<String>()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        setupSearchTextField()
    }
    
    private func setupResultView() {
        addChild(resultController)
        resultController.view.frame = resultContainerView.bounds
        resultContainerView.addSubview(resultController.view)
        resultController.didMove(toParent: self)
        resultContainerView.isHidden = true
    }
    
    private func setupSearchTextField() {
        searchTextField.layer.cornerRadius = 20
    }
    
    private func bindViewModel() {
        let input = SearchViewModel.Input()
        let output = viewModel.transform(input: input)
        
        let keyword = searchTextField.rx.text.asObservable()
            .distinctUntilChanged()
            .debounce(DispatchTimeInterval.milliseconds(200), scheduler: MainScheduler.instance)
            .compactMap { $0 }
            .filter { !$0.replacingOccurrences(of: " ", with: "").isEmpty }
        
        keyword.subscribe(onNext: { [weak self] keyword in
            self?.resultController.setKeyword(keyword: keyword)
        }).disposed(by: disposeBag)
        
        searchTextField.rx.text.subscribe(onNext: { [weak self] text in
            guard let text = text else {
                self?.resultContainerView.isHidden = true
                return
            }
            if !text.replacingOccurrences(of: " ", with: "").isEmpty {
                self?.resultContainerView.isHidden = false
            }
        })
        .disposed(by: disposeBag)
    }
}
