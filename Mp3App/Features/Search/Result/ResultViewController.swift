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

    override func viewDidLoad() {
        setupButtonBar()
        super.viewDidLoad()
    }
    
    override public func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        setupViewController()
        return [allResultViewController, trackResultViewController, userResultViewController, playlistResultViewController]
    }
    
    private func setupViewController() {
        let trackResultViewModel = TrackResultViewModel()
        let searchServices = SearchServices(searchService: SearchService())
        trackResultViewController = TrackResultViewController.instantiate(withViewModel: trackResultViewModel, andServices: searchServices)
        
        let userResultViewModel = UserResultViewModel()
        userResultViewController = UserResultViewController.instantiate(withViewModel: userResultViewModel, andServices: searchServices)
        
        let playlistResultViewModel = PlaylistResultViewModel()
        playlistResultViewController = PlaylistResultViewController.instantiate(withViewModel: playlistResultViewModel, andServices: searchServices)
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
    
    func setKeyword(keyword: String) {
        trackResultViewController.setkeyword(keyword: keyword)
        userResultViewController.setkeyword(keyword: keyword)
        playlistResultViewController.setkeyword(keyword: keyword)
    }
}
