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
import RxDataSources
import NVActivityIndicatorView

typealias HistorySectionModel = SectionModel<String, String>

class SearchViewController: BaseViewController, StoryboardBased, ViewModelBased {
    @IBOutlet weak var searchTextField: CustomTextField!
    @IBOutlet weak var resultContainerView: UIView!
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var loadingIndicatorView: NVActivityIndicatorView!
    
    var viewModel: SearchViewModel!
    private let disposeBag = DisposeBag()
    private let resultController = ResultViewController()
    private var keywordTrigger = PublishSubject<String>()
    private let clearHistoryTrigger = PublishSubject<Void>()
    
    private lazy var historyDataSource = RxTableViewSectionedReloadDataSource<HistorySectionModel>(
        configureCell: { _, tableView, indexPath, value in
            let cell = tableView.dequeueReusableCell(for: indexPath) as SearchHistoryCell
            cell.setHistoryLabel(value: value)
            return cell
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupResultView()
        setupNotificationCenter()
        hideKeyboardWhenTappedAround()
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
        setupTableView()
        loadingIndicatorView.type = .circleStrokeSpin
        loadingIndicatorView.color = Colors.purpleColor
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
        let keyword = searchTextField.rx.text.asObservable()
        .distinctUntilChanged()
        .debounce(DispatchTimeInterval.milliseconds(200), scheduler: MainScheduler.instance)
        .compactMap { $0 }
        .filter { !$0.replacingOccurrences(of: " ", with: "").isEmpty }
        
        let input = SearchViewModel.Input(keyword: keyword, showHistory: searchTextField.rx.text.asObservable(), clearHistory: clearHistoryTrigger)
        let output = viewModel.transform(input: input)
        
        output.saveHistory.subscribe().disposed(by: disposeBag)
        output.clearHistory.subscribe().disposed(by: disposeBag)
        
        keyword.subscribe(onNext: { [weak self] keyword in
            self?.resultController.setKeyword(keyword: keyword)
            self?.historyTableView.isHidden = true
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
        
        output.historyDataSource
        .do(onNext: { [weak self] data in
            guard let isEmpty = data.first?.items.isEmpty else {
                self?.historyTableView.isHidden = true
                return
            }
            self?.historyTableView.isHidden = isEmpty
        })
        .bind(to: historyTableView.rx.items(dataSource: historyDataSource))
        .disposed(by: disposeBag)
        
        historyTableView.rx.modelSelected(String.self).subscribe(onNext: { [weak self] value in
            self?.searchTextField.rx.text.onNext(value)
            self?.searchTextField.sendActions(for: .valueChanged)
        })
        .disposed(by: disposeBag)
        
        resultController.loading.subscribe(onNext: { [weak self] isLoading in
            isLoading ? self?.loadingIndicatorView.startAnimating() : self?.loadingIndicatorView.stopAnimating()
            isLoading ? (self?.searchTextField.clearButtonMode = .never) : (self?.searchTextField.clearButtonMode = .whileEditing)
        })
        .disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        historyTableView.delegate = self
        historyTableView.register(cellType: SearchHistoryCell.self)
        historyTableView.contentInset.bottom = 50
        historyTableView.keyboardDismissMode = .onDrag
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(showDeleteSearchHistoryMessage(_:)), name: Notification.Name(Strings.deleteSearchHistory), object: nil)
    }
    
    @objc func showDeleteSearchHistoryMessage(_ notification: Notification) {
        self.showConfirmMessage(title: Strings.deleteSearchHistoryMessage, message: "", confirmTitle: Strings.confirm, cancelTitle: Strings.cancel) { [weak self] selectedCase in
            if selectedCase == .confirm {
                self?.clearHistoryTrigger.onNext(())
                self?.searchTextField.rx.text.onNext("")
                self?.searchTextField.sendActions(for: .valueChanged)
                self?.resultContainerView.isHidden = true
            } 
        }
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let searchHistoryHeaderCell = SearchHistoryHeaderCell()
        return searchHistoryHeaderCell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}

extension SearchViewController: UIGestureRecognizerDelegate {
    func hideKeyboardWhenTappedAround() {
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc override func dismissKeyboard() {
        view.endEditing(true)
    }
}
