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
    @IBOutlet weak var notificationLabel: UILabel!
    
    var viewModel: PlaylistResultViewModel!
    private let disposeBag = DisposeBag()
    private let keywordTrigger = BehaviorRelay<String>(value: "")
    private let isViewControllerVisibleTrigger = BehaviorRelay<Bool>(value: false)
    private let searchPlaylistTrigger = PublishSubject<String>()
    
    var isViewControllerVisible: Bool = false {
        didSet {
            isViewControllerVisibleTrigger.accept(isViewControllerVisible)
        }
    }
    
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
    
    func setkeyword(keyword: String) {
        keywordTrigger.accept(keyword)
    }
    
    func bindViewModel() {
        let input = PlaylistResultViewModel.Input(searchPlaylist: searchPlaylistTrigger)
        let output = viewModel.transform(input: input)
        
        Observable.combineLatest(isViewControllerVisibleTrigger, keywordTrigger).subscribe(onNext: { [weak self] isViewControllerVisible, keyword  in
            guard let self = self else {
                return
            }
            if isViewControllerVisible {
                self.searchPlaylistTrigger.onNext(keyword)
            }
        }).disposed(by: disposeBag)
        
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
        
        tableView.rx.modelSelected(Playlist.self).subscribe(onNext: { playlist in
            print(playlist)
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