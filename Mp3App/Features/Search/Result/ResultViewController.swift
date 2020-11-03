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

    override func viewDidLoad() {
        setupButtonBar()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override public func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let allResultViewController = AllResultViewController.instantiate()
        let trackResultViewController = TrackResultViewController.instantiate()
        let userResultViewController = UserResultViewController.instantiate()
        let playlistResultViewController = PlaylistResultViewController.instantiate()
        return [allResultViewController, trackResultViewController, userResultViewController, playlistResultViewController]
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
}
