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
        setupUI()
    }
    
    private func setupUI() {
        diskImageView.layer.cornerRadius = diskImageView.frame.size.height / 2
    }
    
    func setupDiskImage(url: String) {
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
