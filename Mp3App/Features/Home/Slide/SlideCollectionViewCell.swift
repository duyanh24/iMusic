//
//  SlideCollectionViewCell.swift
//  Mp3App
//
//  Created by AnhLD on 10/5/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import UIKit
import SDWebImage
import Reusable

class SlideCollectionViewCell: UICollectionViewCell, NibReusable {

    @IBOutlet weak var slideGradientImageView: GradientImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        slideGradientImageView.layer.cornerRadius = 5
    }
    
    func setupData(album: Album) {
        titleLabel.text = album.track?.title
        guard let url = album.track?.artworkURL else {
            return
        }
        let imageCropURL = Converter.changeImageURLSize(imgURL: url, desireSize: .crop)
        slideGradientImageView.setImage(stringURL: imageCropURL)
    }
}
