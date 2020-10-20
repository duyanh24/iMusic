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
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topContentStrackView: UIStackView!
    
    private var heightOfTopView: CGFloat!
    
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
        heightOfTopView = topContentStrackView.frame.size.height
        setupScrollView()
        
    }
    
    func setupScrollView() {
        scrollView.delegate = self
        scrollView.frame = CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height - heightOfTopView)
        scrollView.contentSize = CGSize(width: containerView.frame.width * CGFloat(2), height: containerView.frame.height - heightOfTopView)
        scrollView.isPagingEnabled = true
         
        let playPage = PlayPage(frame: CGRect(x: containerView.frame.width, y: 0, width: containerView.frame.width, height: containerView.frame.height - heightOfTopView))
        let inforPage = InforPage(frame: CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height - heightOfTopView))
        scrollView.addSubview(inforPage)
        scrollView.addSubview(playPage)
        scrollView.contentOffset.x = containerView.frame.width
        
    }
}

extension PlayerView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y != 0 {
            scrollView.contentOffset.y = 0
        }
        if scrollView.contentOffset.x < 0 {
            scrollView.contentOffset.x = 0
        }
        if scrollView.contentOffset.x > containerView.frame.width {
            scrollView.contentOffset.x = containerView.frame.width
        }
    }
}
