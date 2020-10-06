//
//  HeaderOfChartCellUIView.swift
//  Mp3App
//
//  Created by AnhLD on 10/6/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import UIKit

class HeaderOfChartCellUIView: UIView {

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    private func setupView() {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor(red: 35/255, green: 26/255, blue: 49/255, alpha: 1)
        self.addSubview(containerView)
        
        containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Strings.chart
        label.textColor = .white
        containerView.addSubview(label)
        
        label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        label.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).isActive = true
        
//        let path = UIBezierPath(roundedRect: containerView.bounds,
//                                byRoundingCorners: [.topLeft, .topRight],
//                                cornerRadii: CGSize(width: 5, height:  5))
//        let maskLayer = CAShapeLayer()
//        maskLayer.path = path.cgPath
//        containerView.layer.mask = maskLayer
    }
}
