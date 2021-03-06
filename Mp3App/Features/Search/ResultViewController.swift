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
    private var listViewController = [BaseResultViewController]()
    private var keyword = ""
    let loading = PublishSubject<Bool>()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        setupButtonBar()
        super.viewDidLoad()
        setupNotificationCenter()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
        
        trackResultViewController.loading.bind(to: loading).disposed(by: disposeBag)
        userResultViewController.loading.bind(to: loading).disposed(by: disposeBag)
        playlistResultViewController.loading.bind(to: loading).disposed(by: disposeBag)
        allResultViewController.loading.bind(to: loading).disposed(by: disposeBag)
        
        listViewController = [allResultViewController, trackResultViewController, userResultViewController, playlistResultViewController]
    }
    
    func setKeyword(keyword: String) {
        self.keyword = keyword
        search(keyword: keyword, index: currentIndex)
    }
    
    private func search(keyword: String, index: Int) {
        listViewController[index].search(keyword: keyword)
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(moveViewController(_:)), name: Notification.Name(Strings.changeTabSearch), object: nil)
    }
    
    @objc func moveViewController(_ notification: Notification) {
        guard let index = notification.userInfo?[Strings.index] as? Int else { return }
        moveToViewController(at: index)
        search(keyword: keyword, index: index)
    }
    
    override public func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        setupViewController()
        return listViewController
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        moveToViewController(at: indexPath.row)
        search(keyword: keyword, index: indexPath.row)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = scrollView.contentOffset.x / view.bounds.size.width
        search(keyword: keyword, index: Int(currentPage))
    }
}
