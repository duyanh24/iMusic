//
//  ResultHeaderView.swift
//  Mp3App
//
//  Created by AnhLD on 11/5/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import UIKit

class ResultCellHeaderView: UIView {
    private let label = UILabel()

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
        containerView.backgroundColor = .white
        addSubview(containerView)
        
        containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        containerView.addSubview(label)
        
        label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        label.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).isActive = true
    }
    
    func setTitle(title: String) {
        label.text = title
    }
}
