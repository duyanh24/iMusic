//
//  PlayPage.swift
//  Mp3App
//
//  Created by AnhLD on 10/19/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import UIKit

class PlayPage: UIView {
    @IBOutlet var containerView: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("PlayPage", owner: self, options: nil)
        containerView.fixInView(self)
        setupUI()
    }
    
    private func setupUI() {
        
    }
}
