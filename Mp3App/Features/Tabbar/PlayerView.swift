//
//  PlayerView.swift
//  Mp3App
//
//  Created by AnhLD on 10/19/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import UIKit

class PlayerView: UIView {
    @IBOutlet var containerUIView: UIView!
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)
        containerUIView.fixInView(self)
        setupUI()
    }
    
    private func setupUI() {
        trackImageView.layer.cornerRadius = trackImageView.frame.size.height / 2
        //setupScrollView()
    }
    
    func setupScrollView() {
        scrollView.frame = CGRect(x: 0, y: 0, width: containerUIView.frame.width, height: containerUIView.frame.height - 100)
        scrollView.contentSize = CGSize(width: containerUIView.frame.width * CGFloat(2), height: containerUIView.frame.height - 100)
        scrollView.isPagingEnabled = true
        
        let playPage = Bundle.main.loadNibNamed("PlayPage", owner: self, options: nil)?.first as! PlayPage
        let inforPage = Bundle.main.loadNibNamed("InforPage", owner: self, options: nil)?.first as! InforPage
        
        playPage.frame = CGRect(x: containerUIView.frame.width * CGFloat(1), y: 0, width: containerUIView.frame.width, height: containerUIView.frame.height - 100)
        inforPage.frame = CGRect(x: containerUIView.frame.width * CGFloat(2), y: 0, width: containerUIView.frame.width, height: containerUIView.frame.height - 100)
        scrollView.addSubview(playPage)
        scrollView.addSubview(inforPage)
    }
}

extension UIView {
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}
