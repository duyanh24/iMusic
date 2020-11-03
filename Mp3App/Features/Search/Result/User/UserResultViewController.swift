//
//  UserResultViewController.swift
//  Mp3App
//
//  Created by AnhLD on 11/3/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import UIKit
import Reusable
import XLPagerTabStrip

class UserResultViewController: BaseViewController, StoryboardBased, IndicatorInfoProvider {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Ca sĩ")
    }
}
