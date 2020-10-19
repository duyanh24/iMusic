//
//  LibraryDetailViewController.swift
//  Mp3App
//
//  Created by Apple on 10/18/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Reusable
import RxDataSources

class LibraryDetailViewController: BaseViewController, StoryboardBased, ViewModelBased {
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var notificationLabel: UILabel!
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<TrackSectionModel>(
        configureCell: { _, tableView, indexPath, track in
            let cell = tableView.dequeueReusableCell(for: indexPath) as LibraryDetailTableViewCell
            let libraryDetailCellViewModel = LibraryDetailCellViewModel(track: track)
            cell.configureCell(viewModel: libraryDetailCellViewModel)
            return cell
    })
    
    var viewModel: LibraryDetailViewModel!
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
        let input = LibraryDetailViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.activityIndicator.bind(to: ProgressHUD.rx.isAnimating).disposed(by: disposeBag)
        
        output.dataSource.subscribe(onNext: { dataSource in
            self.playButton.isHidden = dataSource.first?.items.isEmpty ?? true
            self.notificationLabel.isHidden = !(dataSource.first?.items.isEmpty ?? true)
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

extension LibraryDetailViewController: UITableViewDelegate {
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
