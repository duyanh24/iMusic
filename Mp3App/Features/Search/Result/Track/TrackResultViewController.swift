//
//  TrackResultViewController.swift
//  Mp3App
//
//  Created by AnhLD on 11/3/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Reusable
import XLPagerTabStrip

class TrackResultViewController: BaseViewController, StoryboardBased, ViewModelBased, IndicatorInfoProvider {

    var viewModel: TrackResultViewModel!
    private let disposeBag = DisposeBag()
    private var keyword = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotificationCenter()
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Bài hát")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(keyword)
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(setupKeyword(_:)), name: Notification.Name("NotificationSearch"), object: nil)
    }
    
    @objc func setupKeyword(_ notification: Notification) {
        guard let keyword = notification.userInfo?["keyword"] as? String else { return }
        self.keyword = keyword
    }
}
