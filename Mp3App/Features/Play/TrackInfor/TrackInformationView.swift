//
//  InforPage.swift
//  Mp3App
//
//  Created by AnhLD on 10/19/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa
import RxDataSources

class TrackInformationView: UIView, NibOwnerLoadable, ViewModelBased {
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<TrackSectionModel>(
        configureCell: { _, tableView, indexPath, track in
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(for: indexPath) as TrackInforCell
                let trackInforCellViewModel = TrackInforCellViewModel(track: track)
                cell.configureCell(viewModel: trackInforCellViewModel)
                return cell
            }
            let cell = tableView.dequeueReusableCell(for: indexPath) as TrackCell
            let trackCellViewModel = TrackCellViewModel(track: track)
            cell.configureCell(viewModel: trackCellViewModel)
            return cell
    })
    
    var isTableViewOnTop: Bool {
        return tableView.contentOffset.y <= 0
    }
    
    var viewModel: TrackInformationViewModel!
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        loadNibContent()
        setupUI()
    }
    
    private func setupUI() {
        setupTableView()
    }
    
    func configureViewModel(viewModel: TrackInformationViewModel) {
        self.viewModel = viewModel
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = TrackInformationViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.dataSource
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.register(cellType: TrackInforCell.self)
        tableView.register(cellType: TrackCell.self)
    }
}

extension TrackInformationView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 130
        }
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
