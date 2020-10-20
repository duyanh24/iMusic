//
//  PlayerView.swift
//  Mp3App
//
//  Created by AnhLD on 10/19/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import UIKit
import Reusable

class PlayerView: UIView, NibOwnerLoadable {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topContentStackView: UIStackView!
    @IBOutlet weak var audioPlayerView: AudioPlayerView!
    @IBOutlet weak var trackInformationView: TrackInformationView!
    
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
        trackImageView.layer.cornerRadius = trackImageView.frame.size.height / 2
        setupScrollView()
    }
    
    private func setupScrollView() {
        scrollView.layoutIfNeeded()
        let contentOffset = CGPoint(x: frame.width, y: 0.0)
        scrollView.setContentOffset(contentOffset, animated: false)
    }
    
    func isScrollEnabled(value: Bool) {
        scrollView.isScrollEnabled = value
    }
}
