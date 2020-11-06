//
//  UserResultCell.swift
//  Mp3App
//
//  Created by Apple on 11/5/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Reusable

class UserResultCell: UITableViewCell, ViewModelBased, NibReusable {
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var viewModel: UserResultCellViewModel!
    private var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupUI() {
        selectionStyle = .none
        albumImageView.layer.cornerRadius = 25
    }
    
    func configureCell(viewModel: UserResultCellViewModel) {
        self.viewModel = viewModel
        bindViewModel()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    private func bindViewModel() {
        let input = UserResultCellViewModel.Input()
        let output = viewModel.transform(input: input)
                
        output.user
            .subscribe(onNext: { [weak self] user in
                self?.titleLabel.text = user.username
                self?.descriptionLabel.text = user.description
                guard let url = user.avatarURL else {
                    return
                }
                self?.albumImageView.setImage(stringURL: url)
            })
            .disposed(by: disposeBag)
    }
}
