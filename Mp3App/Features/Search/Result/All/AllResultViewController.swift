//
//  AllResultViewController.swift
//  Mp3App
//
//  Created by AnhLD on 11/3/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import XLPagerTabStrip
import Reusable
import RxDataSources

class AllResultViewController: BaseResultViewController, StoryboardBased, ViewModelBased, IndicatorInfoProvider {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var notificationLabel: UILabel!
    
    var viewModel: AllResultViewModel!
    private let disposeBag = DisposeBag()
    private let keywordTrigger = BehaviorSubject<String>(value: "")
    
    private lazy var dataSource: RxTableViewSectionedReloadDataSource<SearchSectionModel> = RxTableViewSectionedReloadDataSource(configureCell: { [weak self] (dataSource, tableView, indexPath, item) -> UITableViewCell in
        guard let self = self else { return UITableViewCell() }
        switch dataSource[indexPath] {
        case .track(let type, let track):
            let cell = tableView.dequeueReusableCell(for: indexPath) as TrackResultCell
            let trackResultCellViewModel = TrackResultCellViewModel(track: track)
            cell.configureCell(viewModel: trackResultCellViewModel)
            return cell
        case .playlist(let type, let playlist):
            let cell = tableView.dequeueReusableCell(for: indexPath) as PlaylistResultCell
            let playlistResultCellViewModel = PlaylistResultCellViewModel(playlist: playlist)
            cell.configureCell(viewModel: playlistResultCellViewModel)
            return cell
        case .user(let type, let user):
            let cell = tableView.dequeueReusableCell(for: indexPath) as UserResultCell
            let userResultCellViewModel = UserResultCellViewModel(user: user)
            cell.configureCell(viewModel: userResultCellViewModel)
            return cell
        }
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    override func prepareUI() {
        super.prepareUI()
        setupTableView()
        notificationLabel.isHidden = true
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: Strings.all)
    }
    
    override func search(keyword: String) {
        keywordTrigger.onNext(keyword)
    }
    
    private func bindViewModel() {
        let input = AllResultViewModel.Input(searchAll: keywordTrigger)
        let output = viewModel.transform(input: input)
        
        output.activityIndicator.bind(to: ProgressHUD.rx.isAnimating).disposed(by: disposeBag)
        
        output.dataSource
            .do(onNext: { [weak self] data in
                guard let isEmpty = data.first?.items.isEmpty else {
                    self?.notificationLabel.isHidden = false
                    return
                }
                self?.notificationLabel.isHidden = !isEmpty
            })
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.register(cellType: UserResultCell.self)
        tableView.register(cellType: TrackResultCell.self)
        tableView.register(cellType: PlaylistResultCell.self)
        tableView.contentInset.bottom = 50
    }
}

extension AllResultViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let resultCellHeaderView = ResultCellHeaderView()
        switch dataSource[section] {
        case .track:
            resultCellHeaderView.setTitle(title: Strings.track)
        case .playlist:
            resultCellHeaderView.setTitle(title: Strings.playlist)
        case .user:
            resultCellHeaderView.setTitle(title: Strings.artist)
        }
        return resultCellHeaderView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let resultCellFooterView = ResultCellFooterView()
        switch dataSource[section] {
        case .track:
            resultCellFooterView.setSection(currentSection: 1)
        case .user:
            resultCellFooterView.setSection(currentSection: 2)
        case .playlist:
            resultCellFooterView.setSection(currentSection: 3)
        }
        return resultCellFooterView
    }
}
