//
//  SearchHistoryCell.swift
//  Mp3App
//
//  Created by AnhLD on 11/9/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import UIKit
import Reusable

class SearchHistoryCell: UITableViewCell, NibReusable {
    @IBOutlet weak var historyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupUI() {
        selectionStyle = .none
    }
    
    func setHistoryLabel(value: String) {
        historyLabel.text = value
    }
}
