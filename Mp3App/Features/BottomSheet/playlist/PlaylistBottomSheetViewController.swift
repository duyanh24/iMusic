//
//  PlaylistBottomSheetViewController.swift
//  Mp3App
//
//  Created by AnhLD on 11/12/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Reusable
import RxDataSources

typealias PlaylistNameSectionModel = SectionModel<String, String>

class PlaylistBottomSheetViewController: BaseViewController, StoryboardBased, ViewModelBased {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var emptyErrorLabel: UILabel!
    
    var viewModel: PlaylistBottomSheetViewModel!
    private let disposeBag = DisposeBag()
    private let isTrackAlreadyExistsInFavorites = PublishSubject<Bool>()
    
    private lazy var dataSource: RxTableViewSectionedReloadDataSource<PlaylistNameSectionModel> = RxTableViewSectionedReloadDataSource(configureCell: { [weak self] (dataSource, tableView, indexPath, playlistName) -> UITableViewCell in
        guard let self = self else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(for: indexPath) as PlaylistBottomSheetCell
        let playlistBottomSheetCellViewModel = PlaylistBottomSheetCellViewModel(playlistName: playlistName)
        cell.configureCell(viewModel: playlistBottomSheetCellViewModel)
        return cell
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    override func prepareUI() {
        super.prepareUI()
        setupTableView()
        containerView.layer.cornerRadius = 5
        emptyErrorLabel.isHidden = true
    }
    
    private func bindViewModel() {
        let input = PlaylistBottomSheetViewModel.Input(itemSelected: tableView.rx.modelSelected(String.self).asObservable())
        let output = viewModel.transform(input: input)
        
        output.dataSource
            .do(onNext: { [weak self] data in
                guard let isEmpty = data.first?.items.isEmpty else {
                    self?.emptyErrorLabel.isHidden = false
                    return
                }
                self?.emptyErrorLabel.isHidden = !isEmpty
            })
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.addTrackToPlaylistResult.subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                self.showErrorAlert(message: error.localizedDescription, completion: nil)
            case .success:
                self.dismiss(animated: true, completion: {
                    UIApplication.topViewController()?.showErrorAlert(message: Strings.addTrackToPlaylistSuccess)
                })
            }
        }).disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.register(cellType: PlaylistBottomSheetCell.self)
    }
}

extension PlaylistBottomSheetViewController: UITableViewDelegate {
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
