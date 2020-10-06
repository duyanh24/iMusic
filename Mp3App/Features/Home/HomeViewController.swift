//
//  HomeViewController.swift
//  Mp3App
//
//  Created by AnhLD on 9/29/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa
import RxDataSources

class HomeViewController: BaseViewController, StoryboardBased, ViewModelBased {
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: HomeViewModel!
    var startIndex = 0
    
    private lazy var dataSource: RxTableViewSectionedReloadDataSource<HomeSectionModel> = RxTableViewSectionedReloadDataSource(configureCell: { [weak self] (dataSource, tableView, indexPath, item) -> UITableViewCell in
        guard let self = self else { return UITableViewCell() }
        switch dataSource[indexPath] {
            
        case .albumsSlide(let type, let albums):
            let cell = tableView.dequeueReusableCell(for: indexPath) as SlideTableViewCell
            cell.setupData(albums: albums)
            return cell
        case .albumsChart(let type, let album):
            let cell = tableView.dequeueReusableCell(for: indexPath) as ChartTableViewCell
            let chartTableViewCellViewModel = ChartTableViewCellViewModel(album: album, rank: indexPath.row + 1)

            cell.configureCell(viewModel: chartTableViewCellViewModel)
            return cell
            
        case .singers(let type, let users):
            print("singers")
            return UITableViewCell()

        case .albumsDefault(let type, let albums):
            let cell = tableView.dequeueReusableCell(for: indexPath) as AlbumsTableViewCell

            cell.contentOffsetChange.subscribe(onNext: { [weak self] contentOffset in
                guard let self = self else { return }
                self.viewModel.collectionViewContentOffSetDictionary[type] = contentOffset
            }).disposed(by: cell.disposeBag)

            let albumsTableViewCellViewModel = AlbumsTableViewCellViewModel(type: type, albums: albums, contentOffset: self.viewModel.collectionViewContentOffSetDictionary[type] ?? CGPoint(x: -20, y: 0))

            cell.configureCell(viewModel: albumsTableViewCellViewModel)
            return cell
        }
    })
    
    private let disposeBag = DisposeBag()
    private let loadDataTrigger = PublishSubject<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        loadData()
    }
    
    override func prepareUI() {
        super.prepareUI()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func bindViewModel() {
        let input = HomeViewModel.Input(loadDataTrigger: loadDataTrigger)
        let output = viewModel.transform(input: input)
        output.homeDataModel.bind(to: tableView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        //tableView.contentInsetAdjustmentBehavior = .never
        tableView.delegate = self
        tableView.register(cellType: SlideTableViewCell.self)
        tableView.register(cellType: AlbumsTableViewCell.self)
        tableView.register(cellType: ChartTableViewCell.self)
    }
}

extension HomeViewController {
    private func loadData() {
        loadDataTrigger.onNext(())
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch dataSource[indexPath.section] {
        case .chartAlbums:
            return 60
        case .popularAlbums:
            let paddingLeft: CGFloat = 20
            let paddingTop: CGFloat = 20
            let width = UIScreen.main.bounds.width - paddingLeft * 2
            var statusBarHeight: CGFloat = 0
            if #available(iOS 13.0, *) {
                let window = UIApplication.shared.currentWindow
                statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
            } else {
                statusBarHeight = UIApplication.shared.statusBarFrame.height
            }
            let height = width * 7 / 16 + statusBarHeight + paddingTop * 2
            return height
            
        case .popularUsers:
            return 200
        default:
            return 250
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch dataSource[section] {
        case .chartAlbums:
            return 50
        default:
            return .leastNonzeroMagnitude
        }
        //return .leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch dataSource[section] {
        case .chartAlbums:
//            let view = UIView()
//            let label = UILabel()
//            label.text = "ok"
//            view.backgroundColor = .blue
//            view.addSubview(label)
            return HeaderOfChartCellUIView()
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}
