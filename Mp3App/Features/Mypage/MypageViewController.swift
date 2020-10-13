//
//  MypageViewController.swift
//  Mp3App
//
//  Created by AnhLD on 9/29/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import RxSwift
import RxCocoa
import Reusable
import UIKit
import RxDataSources

class MypageViewController: BaseViewController, StoryboardBased, ViewModelBased {
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: MypageViewModel!
    private let disposeBag = DisposeBag()
    private let loadDataTrigger = PublishSubject<Void>()
    
    private lazy var dataSource: RxTableViewSectionedReloadDataSource<MypageSectionModel> = RxTableViewSectionedReloadDataSource(configureCell: { [weak self] (dataSource, tableView, indexPath, item) -> UITableViewCell in
        guard let self = self else { return UITableViewCell() }
        switch dataSource[indexPath] {
        case .interested(let type, let library):
            let cell = tableView.dequeueReusableCell(for: indexPath) as InterestedTableViewCell
            //cell.setupData(albums: albums)
            return cell
        case .playlist(let type, let playlist):
            let cell = tableView.dequeueReusableCell(for: indexPath) as PlaylistTableViewCell
            //cell.setupData(albums: albums)
            return cell
        }
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func prepareUI() {
        super.prepareUI()
        setupTableView()
    }
    
    private func bindViewModel() {
        let input = MypageViewModel.Input(loadDataTrigger: loadDataTrigger)
        let output = viewModel.transform(input: input)
        output.mypageDataModel
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.register(cellType: InterestedTableViewCell.self)
        tableView.register(cellType: PlaylistTableViewCell.self)
    }
}

extension MypageViewController {
    private func loadData() {
        loadDataTrigger.onNext(())
    }
}

extension MypageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let width = UIScreen.main.bounds.width
        return InterestedCellHeaderView(frame: CGRect(x: 0, y: 0, width: width, height: 60))
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}
