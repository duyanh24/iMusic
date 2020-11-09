//
//  SearchHistoryHeaderCell.swift
//  Mp3App
//
//  Created by AnhLD on 11/9/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchHistoryHeaderCell: UIView {
    private let disposeBag = DisposeBag()
    
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
        
        containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = Strings.history
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        containerView.addSubview(label)
        
        label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0).isActive = true
        label.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).isActive = true
        
        let buton = UIButton()
        buton.translatesAutoresizingMaskIntoConstraints = false
        buton.setTitleColor(Colors.purpleColor, for: .normal)
        buton.setTitle(Strings.delete, for: .normal)
        buton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        containerView.addSubview(buton)
        
        buton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        buton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0).isActive = true
        buton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0).isActive = true
        buton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        buton.rx.tap.subscribe(onNext: { _ in
            NotificationCenter.default.post(name: Notification.Name(rawValue: Strings.deleteSearchHistory), object: nil, userInfo: nil)
        }).disposed(by: disposeBag)
    }
}
