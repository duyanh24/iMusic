//
//  PlaylistDetailViewController.swift
//  Mp3App
//
//  Created by Apple on 10/14/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import UIKit
import RxSwift
import Reusable
import RxDataSources

typealias TrackSectionModel = SectionModel<String, Track>

class PlaylistDetailViewController: BaseViewController, StoryboardBased, ViewModelBased {
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<TrackSectionModel>(
        configureCell: { _, tableView, indexPath, track in
            let cell = tableView.dequeueReusableCell(for: indexPath) as PlaylistDetailTableViewCell
            let playlistDetailCellViewModel = PlaylistDetailCellViewModel(track: track)
            cell.configureCell(viewModel: playlistDetailCellViewModel)
            return cell
    })
    
    var viewModel: PlaylisDetailViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    override func prepareUI() {
        super.prepareUI()
        playButton.layer.cornerRadius = playButton.frame.size.height / 2
        setupTableView()
    }
    
    private func bindViewModel() {
        let input = PlaylisDetailViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.activityIndicator.bind(to: ProgressHUD.rx.isAnimating).disposed(by: disposeBag)
        
        output.playlistName.subscribe(onNext: { [weak self] playlistName in
            self?.title = playlistName
        })
        .disposed(by: disposeBag)
        
        output.dataSource
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.register(cellType: PlaylistDetailTableViewCell.self)
    }
}

extension PlaylistDetailViewController: UITableViewDelegate {
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
