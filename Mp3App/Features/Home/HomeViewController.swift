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
            //let cell = tableView.dequeueReusableCell(for: indexPath) as SlideTableViewCell
            //cell.configureCell(albums: albums)
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SlideTableViewCell", for: IndexPath(row: indexPath.row, section: 0)) as? SlideTableViewCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.setupData(albums: albums, startIndex: self.startIndex)
            print(albums)
            return cell
        case .albumsChart(let type, let albums):
            print("albumsDefault")
            return UITableViewCell()
        case .singers(let type, let users):
            print("singers")
            return UITableViewCell()
        case .albumsDefault(let type, let albums):
            print("albumsDefault")
            return UITableViewCell()
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
        //ouput.homeDataModel.subscribe(onNext: { homeScreenDataModel in
//            print("-----------------------")
//            print(homeScreenDataModel.hiphopAlbums)
        //}).disposed(by: disposeBag)
        
        output.homeDataModel.bind(to: tableView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.delegate = self
        tableView.register(UINib(nibName: "SlideTableViewCell", bundle: nil), forCellReuseIdentifier: "SlideTableViewCell")
    }
}

extension HomeViewController {
    private func loadData() {
        loadDataTrigger.onNext(())
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
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
        } else {
            return 50
        }
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

extension HomeViewController: SlideTableViewCellDelegate {
    func didEndDragging(startIndex: Int) {
        self.startIndex = startIndex
    }
}
