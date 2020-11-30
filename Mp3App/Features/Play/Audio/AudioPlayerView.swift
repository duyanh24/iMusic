//
//  PlayPage.swift
//  Mp3App
//
//  Created by AnhLD on 10/19/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import UIKit
import Reusable

class AudioPlayerView: UIView, NibOwnerLoadable {
    @IBOutlet weak var diskImageView: UIImageView!
       
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        loadNibContent()
    }
    
    func setCornerRadius() {
        diskImageView.layer.cornerRadius = diskImageView.bounds.size.height / 2
    }
    
    func setupDiskImage(url: String?) {
        guard let url = url else {
            diskImageView.image = Asset.playerIconCdcoverSmallNormal.image
            return
        }
        let imageCropURL = Converter.changeImageURLSize(imgURL: url, desireSize: .crop)
        diskImageView.setImage(stringURL: imageCropURL)
    }
    
    func rotateImageView() {
        diskImageView.rotate()
    }
    
    func stopRotateImageView() {
        diskImageView.stopRotating()
    }
}
