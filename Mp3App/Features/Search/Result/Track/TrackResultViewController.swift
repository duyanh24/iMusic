//
//  TrackResultViewController.swift
//  Mp3App
//
//  Created by AnhLD on 11/3/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Reusable
import RxDataSources
import XLPagerTabStrip

class TrackResultViewController: BaseViewController, StoryboardBased, ViewModelBased, IndicatorInfoProvider {
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: TrackResultViewModel!
    private let disposeBag = DisposeBag()
    private let keywordTrigger = BehaviorRelay<String>(value: "")
    private let isViewControllerVisible = BehaviorRelay<Bool>(value: false)
    private let searchTrackTrigger = PublishSubject<String>()
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<TrackSectionModel>(
        configureCell: { _, tableView, indexPath, track in
            let cell = tableView.dequeueReusableCell(for: indexPath) as LibraryDetailTableViewCell
            let libraryDetailCellViewModel = LibraryDetailCellViewModel(track: track)
            cell.configureCell(viewModel: libraryDetailCellViewModel)
            return cell
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isViewControllerVisible.accept(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        isViewControllerVisible.accept(false)
    }
    
    override func prepareUI() {
        super.prepareUI()
        setupTableView()
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Bài hát")
    }
    
    func setkeyword(keyword: String) {
        self.keywordTrigger.accept(keyword)
    }
    
    func bindViewModel() {
        let input = TrackResultViewModel.Input(searchTrack: searchTrackTrigger)
        let output = viewModel.transform(input: input)
        
        Observable.combineLatest(isViewControllerVisible, keywordTrigger).subscribe(onNext: { [weak self] isViewControllerVisible, keyword  in
            guard let self = self else {
                return
            }
            if isViewControllerVisible {
                self.searchTrackTrigger.onNext(keyword)
            }
        }).disposed(by: disposeBag)
        
        output.dataSource
        .bind(to: tableView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.register(cellType: LibraryDetailTableViewCell.self)
    }
}

extension TrackResultViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}
