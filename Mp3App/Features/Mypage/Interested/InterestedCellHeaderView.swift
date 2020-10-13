//
//  InterestedCellHeaderView.swift
//  Mp3App
//
//  Created by AnhLD on 10/13/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import UIKit

class InterestedCellHeaderView: UIView {
    @IBOutlet weak var view: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }

    private func nibSetup() {
        backgroundColor = .clear
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        addSubview(view)
    }

    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(type(of: self)), bundle: bundle)
        let nibView = nib.instantiateWithOwner(self, options: nil).first as! UIView
        return nibView
    }
}
