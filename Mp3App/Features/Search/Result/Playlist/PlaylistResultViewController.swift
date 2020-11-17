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

class PlaylistResultViewController: BaseResultViewController, StoryboardBased, ViewModelBased, IndicatorInfoProvider {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var notificationLabel: UILabel!
    
    var viewModel: PlaylistResultViewModel!
    private let disposeBag = DisposeBag()
    private let keywordTrigger = BehaviorSubject<String>(value: "")
    private let loadMoreTrigger = PublishSubject<Void>()
    private var isLoadMoreEnabled = true
    private let startLoadingOffset = CGFloat(20.0)
    let loading = PublishSubject<Bool>()
    
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
    
    override func prepareUI() {
        super.prepareUI()
        setupTableView()
        notificationLabel.isHidden = true
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: Strings.playlist)
    }
    
    override func search(keyword: String) {
        keywordTrigger.onNext(keyword)
    }
    
    private func bindViewModel() {
        let input = PlaylistResultViewModel.Input(searchPlaylist: keywordTrigger, loadMore: loadMoreTrigger)
        let output = viewModel.transform(input: input)
        
        output.activityIndicator.bind(to: loading).disposed(by: disposeBag)
        output.loadData.subscribe().disposed(by: disposeBag)
        output.loadMoreData.subscribe().disposed(by: disposeBag)
        
        output.isLoadMoreEnabled.subscribe(onNext: { [weak self] isLoadMoreEnabled in
            self?.isLoadMoreEnabled = isLoadMoreEnabled
        })
        .disposed(by: disposeBag)
        
        output.dataSource
            .skip(1)
            .do(onNext: { [weak self] data in
                guard let isEmpty = data.first?.items.isEmpty else {
                    self?.notificationLabel.isHidden = false
                    return
                }
                self?.notificationLabel.isHidden = !isEmpty
            })
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Playlist.self).subscribe(onNext: { playlist in
            let tracks = playlist.tracks?.filter({ track -> Bool in
                guard let streamable = track.streamable else {
                    return false
                }
                if !streamable || track.title == nil || track.artworkURL == nil {
                    return false
                }
                return true
            })
            SceneCoordinator.shared.transition(to: Scene.tracks(tracks: tracks ?? [], title: playlist.title ?? ""))
        })
        .disposed(by: disposeBag)
        
        tableView.rx.contentOffset.subscribe(onNext: { [weak self] contentOffset in
            self?.loadMore(contentOffset: contentOffset)
        }).disposed(by: disposeBag)
    }
    
    private func loadMore(contentOffset: CGPoint) {
        if contentOffset.y + tableView.frame.size.height + startLoadingOffset > tableView.contentSize.height && isLoadMoreEnabled {
            loadMoreTrigger.onNext(())
        }
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
