//
//  UserResultViewController.swift
//  Mp3App
//
//  Created by AnhLD on 11/3/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Reusable
import RxDataSources
import XLPagerTabStrip

typealias UserSectionModel = SectionModel<String, User>

class UserResultViewController: BaseViewController, StoryboardBased, ViewModelBased, IndicatorInfoProvider {
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: UserResultViewModel!
    private let disposeBag = DisposeBag()
    private let keywordTrigger = BehaviorRelay<String>(value: "")
    private let isViewControllerVisible = BehaviorRelay<Bool>(value: false)
    private let searchUserTrigger = PublishSubject<String>()
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<UserSectionModel>(
        configureCell: { _, tableView, indexPath, user in
            let cell = tableView.dequeueReusableCell(for: indexPath) as UserResultCell
            
            let userResultCellViewModel = UserResultCellViewModel(user: user)
            cell.configureCell(viewModel: userResultCellViewModel)
            return cell
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isViewControllerVisible.accept(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        isViewControllerVisible.accept(false)
    }
    
    override func prepareUI() {
        super.prepareUI()
        setupTableView()
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Nghệ sĩ")
    }
    
    func setkeyword(keyword: String) {
        self.keywordTrigger.accept(keyword)
    }
    
    func bindViewModel() {
        let input = UserResultViewModel.Input(searchUser: searchUserTrigger)
        let output = viewModel.transform(input: input)
        
        Observable.combineLatest(isViewControllerVisible, keywordTrigger).subscribe(onNext: { [weak self] isViewControllerVisible, keyword  in
            guard let self = self else {
                return
            }
            if isViewControllerVisible {
                self.searchUserTrigger.onNext(keyword)
            }
        }).disposed(by: disposeBag)
        
        output.activityIndicator.bind(to: ProgressHUD.rx.isAnimating).disposed(by: disposeBag)
        
        output.dataSource
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.register(cellType: UserResultCell.self)
    }
}

extension UserResultViewController: UITableViewDelegate {
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

