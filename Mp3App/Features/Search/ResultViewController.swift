//
//  ResultViewController.swift
//  Mp3App
//
//  Created by AnhLD on 11/3/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import XLPagerTabStrip

class ResultViewController: ButtonBarPagerTabStripViewController {
    private var allResultViewController = AllResultViewController.instantiate()
    private var trackResultViewController = TrackResultViewController.instantiate()
    private var userResultViewController = UserResultViewController.instantiate()
    private var playlistResultViewController = PlaylistResultViewController.instantiate()
    private let disposeBag = DisposeBag()
    private let currentIndexTrigger = BehaviorSubject<Int>(value: 0)

    override func viewDidLoad() {
        setupButtonBar()
        super.viewDidLoad()
        setupNotificationCenter()
        setupObservable()
    }
    
    private func setupViewController() {
        let trackResultViewModel = TrackResultViewModel()
        let searchServices = SearchServices(searchService: SearchService())
        trackResultViewController = TrackResultViewController.instantiate(withViewModel: trackResultViewModel, andServices: searchServices)
        
        let userResultViewModel = UserResultViewModel()
        userResultViewController = UserResultViewController.instantiate(withViewModel: userResultViewModel, andServices: searchServices)
        
        let playlistResultViewModel = PlaylistResultViewModel()
        playlistResultViewController = PlaylistResultViewController.instantiate(withViewModel: playlistResultViewModel, andServices: searchServices)
        
        let allResultViewModel = AllResultViewModel()
        allResultViewController = AllResultViewController.instantiate(withViewModel: allResultViewModel, andServices: searchServices)
    }
    
    func setKeyword(keyword: String) {
        trackResultViewController.setkeyword(keyword: keyword)
        userResultViewController.setkeyword(keyword: keyword)
        playlistResultViewController.setkeyword(keyword: keyword)
        allResultViewController.setKeyword(keyword: keyword)
    }
    
    private func setupObservable() {
        currentIndexTrigger.distinctUntilChanged().subscribe(onNext: { [weak self] index in
            self?.resetViewControllerStatus()
            switch index {
            case 0:
                self?.allResultViewController.isViewControllerVisible = true
            case 1:
                self?.trackResultViewController.isViewControllerVisible = true
            case 2:
                self?.userResultViewController.isViewControllerVisible = true
            case 3:
                self?.playlistResultViewController.isViewControllerVisible = true
            default: break
                
            }
        }).disposed(by: disposeBag)
    }
    
    private func resetViewControllerStatus() {
        allResultViewController.isViewControllerVisible = false
        trackResultViewController.isViewControllerVisible = false
        userResultViewController.isViewControllerVisible = false
        playlistResultViewController.isViewControllerVisible = false
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(moveViewController(_:)), name: Notification.Name(Strings.changeTabSearch), object: nil)
    }
    
    @objc func moveViewController(_ notification: Notification) {
        guard let index = notification.userInfo?[Strings.index] as? Int else { return }
        moveToViewController(at: index)
    }
    
    private func setupButtonBar() {
        settings.style.selectedBarBackgroundColor = Colors.purpleColor
        settings.style.buttonBarItemFont = UIFont.systemFont(ofSize: 12, weight: .semibold)
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarBackgroundColor = .white
        settings.style.selectedBarHeight = 2
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.buttonBarHeight = 40
    }
    
    override public func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        setupViewController()
        return [allResultViewController, trackResultViewController, userResultViewController, playlistResultViewController]
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        moveToViewController(at: indexPath.row)
        currentIndexTrigger.onNext(indexPath.row)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = scrollView.contentOffset.x / view.bounds.size.width
        currentIndexTrigger.onNext(Int(currentPage))
    }
}
