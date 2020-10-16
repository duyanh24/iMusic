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
        case .favourite(let type, let libraryTitle):
            let cell = tableView.dequeueReusableCell(for: indexPath) as LibraryTableViewCell
            let libraryTableViewCellViewModel = LibraryTableViewCellViewModel(libraryTitle: libraryTitle)
            cell.configureCell(viewModel: libraryTableViewCellViewModel)
            return cell
        case .playlist(let type, let playlist):
            let cell = tableView.dequeueReusableCell(for: indexPath) as PlaylistTableViewCell
            let playlistTableViewCellViewModel = PlaylistTableViewCellViewModel(playlist: playlist)
            cell.configureCell(viewModel: playlistTableViewCellViewModel)
            return cell
        }
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotificationCenter()
        bindViewModel()
        loadData()
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: Notification.Name(Strings.playlistCreatedNotification), object: nil)
    }
    
    @objc func reloadData() {
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
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Asset.icBackNormal.image, style: .plain, target: nil, action: nil)
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
        tableView.register(cellType: LibraryTableViewCell.self)
        tableView.register(cellType: PlaylistTableViewCell.self)
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            guard let self = self else {
                return
            }
            switch self.dataSource[indexPath] {
            case .favourite(_, let library):
                print(library)
            case .playlist(_, let playlist):
                SceneCoordinator.shared.transition(to: Scene.playlistDetail(playlist: playlist))
                print(playlist)
            }
        }).disposed(by: disposeBag)
    }
}

extension MypageViewController {
    func loadData() {
        loadDataTrigger.onNext(())
    }
}

extension MypageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch dataSource[section] {
        case .favourite:
            return .leastNonzeroMagnitude
        case .playlist:
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = MypageCellHeaderView()
        switch dataSource[section] {
        case .favourite:
            view.setTitle(title: Strings.library)
        case .playlist:
            view.setTitle(title: Strings.playlist)
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch dataSource[section] {
        case .favourite:
            return nil
        case .playlist:
            let playlistCellFooterView = PlaylistCellFooterView()
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapFooter))
            playlistCellFooterView.addGestureRecognizer(tapRecognizer)
            return playlistCellFooterView
        }
    }
    
    @objc func handleTapFooter(gestureRecognizer: UIGestureRecognizer) {
        SceneCoordinator.shared.transition(to: Scene.createPlaylist)
    }
}
