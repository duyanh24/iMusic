//
//  PlaylistResultViewController.swift
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

typealias PlaylistSectionModel = SectionModel<String, Playlist>

class PlaylistResultViewController: BaseViewController, StoryboardBased, ViewModelBased, IndicatorInfoProvider {
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: PlaylistResultViewModel!
    private let disposeBag = DisposeBag()
    private let keywordTrigger = BehaviorRelay<String>(value: "")
    private let isViewControllerVisible = BehaviorRelay<Bool>(value: false)
    private let searchPlaylistTrigger = PublishSubject<String>()
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<PlaylistSectionModel>(
        configureCell: { _, tableView, indexPath, playlist in
            let cell = tableView.dequeueReusableCell(for: indexPath) as PlaylistResultCell
            
            let playlistResultCellViewModel = PlaylistResultCellViewModel(playlist: playlist)
            cell.configureCell(viewModel: playlistResultCellViewModel)
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
        return IndicatorInfo(title: Strings.playlist)
    }
    
    func setkeyword(keyword: String) {
        self.keywordTrigger.accept(keyword)
    }
    
    func bindViewModel() {
        let input = PlaylistResultViewModel.Input(searchPlaylist: searchPlaylistTrigger)
        let output = viewModel.transform(input: input)
        
        Observable.combineLatest(isViewControllerVisible, keywordTrigger).subscribe(onNext: { [weak self] isViewControllerVisible, keyword  in
            guard let self = self else {
                return
            }
            if isViewControllerVisible {
                self.searchPlaylistTrigger.onNext(keyword)
            }
        }).disposed(by: disposeBag)
        
        output.activityIndicator.bind(to: ProgressHUD.rx.isAnimating).disposed(by: disposeBag)
        
        output.dataSource
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.register(cellType: PlaylistResultCell.self)
        tableView.contentInset.bottom = 50
    }
}

extension PlaylistResultViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
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
