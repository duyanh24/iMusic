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
    @IBOutlet weak var notificationLabel: UILabel!
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<TrackSectionModel>(
        configureCell: { _, tableView, indexPath, track in
            let cell = tableView.dequeueReusableCell(for: indexPath) as PlaylistDetailTableViewCell
            let playlistDetailCellViewModel = PlaylistDetailCellViewModel(track: track)
            cell.configureCell(viewModel: playlistDetailCellViewModel)
            return cell
    })
    
    var viewModel: PlaylistDetailViewModel!
    private let disposeBag = DisposeBag()
    private let deleteTrackTrigger = PublishSubject<Int>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    override func prepareUI() {
        super.prepareUI()
        playButton.layer.cornerRadius = playButton.frame.size.height / 2
        playButton.isHidden = true
        notificationLabel.isHidden = true
        setupTableView()
    }
    
    private func bindViewModel() {
        let input = PlaylistDetailViewModel.Input(playButton: playButton.rx.tap.asObservable(),
                                                  play: tableView.rx.modelSelected(Track.self).asObservable(),
                                                  deleteTrack: deleteTrackTrigger)
        let output = viewModel.transform(input: input)
        
        output.activityIndicator.bind(to: ProgressHUD.rx.isAnimating).disposed(by: disposeBag)
        
        output.playlistName.subscribe(onNext: { [weak self] playlistName in
            self?.title = playlistName
        })
        .disposed(by: disposeBag)
        
        output.dataSource.subscribe(onNext: { [weak self] dataSource in
            self?.playButton.isHidden = dataSource.first?.items.isEmpty ?? true
            self?.notificationLabel.isHidden = !(dataSource.first?.items.isEmpty ?? true)
        }).disposed(by: disposeBag)
        
        output.showPlayerView.subscribe().disposed(by: disposeBag)
        output.playTrack.subscribe().disposed(by: disposeBag)
        
        output.dataSource
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.deleteTrack.subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                self.showErrorAlert(message: error.localizedDescription, completion: nil)
            case .success:
                break
            }
        }).disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        tableView.addGestureRecognizer(setupGesture())
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

extension PlaylistDetailViewController: UIGestureRecognizerDelegate {
    func setupGesture() -> UILongPressGestureRecognizer {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        return longPress
    }
    
    @objc func handleLongPress(sender: UILongPressGestureRecognizer){
        if sender.state == UIGestureRecognizer.State.began {
            let touchPoint = sender.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                let track = dataSource[indexPath]
                showConfirmMessage(title: track.title ?? "", message: Strings.deleteTrackMessage, confirmTitle: Strings.confirm, cancelTitle: Strings.cancel) { [weak self] selectedCase in
                    if selectedCase == .confirm {
                        guard let trackId = track.id else {
                            return
                        }
                        self?.deleteTrackTrigger.onNext(trackId)
                    }
                }
            }
        }
    }
}
