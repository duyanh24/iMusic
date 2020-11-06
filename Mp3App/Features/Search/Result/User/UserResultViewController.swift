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
    @IBOutlet weak var notificationLabel: UILabel!
    
    var viewModel: UserResultViewModel!
    private let disposeBag = DisposeBag()
    private let keywordTrigger = BehaviorRelay<String>(value: "")
    private let isViewControllerVisibleTrigger = BehaviorRelay<Bool>(value: false)
    private let searchUserTrigger = PublishSubject<String>()
    
    var isViewControllerVisible: Bool = false {
        didSet {
            isViewControllerVisibleTrigger.accept(isViewControllerVisible)
        }
    }
    
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
    
    override func prepareUI() {
        super.prepareUI()
        setupTableView()
        notificationLabel.isHidden = true
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: Strings.artist)
    }
    
    func setkeyword(keyword: String) {
        self.keywordTrigger.accept(keyword)
    }
    
    func bindViewModel() {
        let input = UserResultViewModel.Input(searchUser: searchUserTrigger)
        let output = viewModel.transform(input: input)
        
        Observable.combineLatest(isViewControllerVisibleTrigger, keywordTrigger).subscribe(onNext: { [weak self] isViewControllerVisible, keyword  in
            guard let self = self else {
                return
            }
            if isViewControllerVisible {
                self.searchUserTrigger.onNext(keyword)
            }
        }).disposed(by: disposeBag)
        
        output.activityIndicator.bind(to: ProgressHUD.rx.isAnimating).disposed(by: disposeBag)
        
        output.dataSource
            .do(onNext: { [weak self] data in
                guard let isEmpty = data.first?.items.isEmpty else {
                    self?.notificationLabel.isHidden = false
                    return
                }
                self?.notificationLabel.isHidden = !isEmpty
            })
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.register(cellType: UserResultCell.self)
        tableView.contentInset.bottom = 50
    }
}

extension UserResultViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
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

