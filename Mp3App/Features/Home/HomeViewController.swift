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
    
    private lazy var dataSource: RxTableViewSectionedReloadDataSource<HomeSectionModel> = RxTableViewSectionedReloadDataSource(configureCell: { [weak self] (dataSource, tableView, indexPath, item) -> UITableViewCell in
        guard let self = self else { return UITableViewCell() }
        switch dataSource[indexPath] {
        case .albumsSlide(let type, let albums):
            let cell = tableView.dequeueReusableCell(for: indexPath) as SlideTableViewCell
            //cell.configureCell(albums: albums)
            return cell
        }
    })
    
    private let disposeBag = DisposeBag()
    private let loadDataTrigger = PublishSubject<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindViewModel()
        loadData()
    }
    
    private func bindViewModel() {
        let input = HomeViewModel.Input(loadDataTrigger: loadDataTrigger)
        let ouput = viewModel.transform(input: input)
        //ouput.homeDataModel.subscribe(onNext: { homeScreenDataModel in
//            print("-----------------------")
//            print(homeScreenDataModel.hiphopAlbums)
        //}).disposed(by: disposeBag)
        
        output.homeDataModel
        .drive(tableView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.register(cellType: SlideTableViewCell.self)
    }
}

extension HomeViewController {
    private func loadData() {
        loadDataTrigger.onNext(())
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
