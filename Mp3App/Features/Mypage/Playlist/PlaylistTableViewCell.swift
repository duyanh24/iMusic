//
//  PlaylistTableViewCell.swift
//  Mp3App
//
//  Created by AnhLD on 10/13/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import UIKit
import Reusable

class PlaylistTableViewCell: UITableViewCell, NibReusable {
    @IBOutlet weak var playlistImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupUI() {
        playlistImageView.layer.cornerRadius = 5
    }
}
