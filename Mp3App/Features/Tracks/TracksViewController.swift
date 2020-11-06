//
//  TracksViewController.swift
//  Mp3App
//
//  Created by AnhLD on 11/6/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Reusable
import RxDataSources

class TracksViewController: BaseViewController, StoryboardBased, ViewModelBased {
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var notificationLabel: UILabel!
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<TrackSectionModel>(
        configureCell: { _, tableView, indexPath, track in
            let cell = tableView.dequeueReusableCell(for: indexPath) as TracksDetailCell
            let tracksCellViewModel = TracksDetailCellViewModel(track: track)
            cell.configureCell(viewModel: tracksCellViewModel)
            return cell
    })
    
    var viewModel: TracksViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    override func prepareUI() {
        super.prepareUI()
        playButton.layer.cornerRadius = playButton.frame.size.height / 2
        title = Strings.favouriteSong
        playButton.isHidden = true
        notificationLabel.isHidden = true
        setupTableView()
    }
    
    private func bindViewModel() {
        let input = TracksViewModel.Input(playButton: playButton.rx.tap.asObservable())
        let output = viewModel.transform(input: input)
        
        output.dataSource.subscribe(onNext: { [weak self] dataSource in
            self?.playButton.isHidden = dataSource.first?.items.isEmpty ?? true
            self?.notificationLabel.isHidden = !(dataSource.first?.items.isEmpty ?? true)
        }).disposed(by: disposeBag)
        
        output.showPlayerView.subscribe().disposed(by: disposeBag)
        
        output.dataSource
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.title.subscribe(onNext: { [weak self] title in
            self?.title = title
        })
        .disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.register(cellType: TracksDetailCell.self)
        tableView.contentInset.bottom = 50
    }
}

extension TracksViewController: UITableViewDelegate {
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
