//
//  ResultCellFooterView.swift
//  Mp3App
//
//  Created by AnhLD on 11/5/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import UIKit

class ResultCellFooterView: UIView {
    private let label = UILabel()
    private var currentSection = 0

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
        containerView.backgroundColor = Colors.purpleColor
        containerView.layer.cornerRadius = 15
        addSubview(containerView)
        
        containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 100).isActive = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Strings.more
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 11)
        containerView.addSubview(label)
        
        label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapFooter))
        containerView.addGestureRecognizer(tapRecognizer)
    }
    
    func setSection(currentSection: Int) {
        self.currentSection = currentSection
    }
    
    @objc func handleTapFooter(gestureRecognizer: UIGestureRecognizer) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: Strings.changeTabSearch), object: nil, userInfo: [Strings.index: currentSection])
    }
}
