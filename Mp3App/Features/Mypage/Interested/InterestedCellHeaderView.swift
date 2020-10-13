//
//  InterestedCellHeaderView.swift
//  Mp3App
//
//  Created by AnhLD on 10/13/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import UIKit

class InterestedCellHeaderView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        let viewFromXib = UINib(nibName: "InterestedCellHeaderView", bundle: .main).instantiate(withOwner: nil, options: nil).first as! UIView
        guard let viewFromXib = Bundle.main.loadNibNamed("InterestedCellHeaderView", owner: self, options: nil)?.first as? UIView else {
            return
        }
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
    }
}
