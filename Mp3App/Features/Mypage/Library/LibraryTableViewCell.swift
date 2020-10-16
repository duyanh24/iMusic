//
//  InterestedTableViewCell.swift
//  Mp3App
//
//  Created by AnhLD on 10/13/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import UIKit
import Reusable
import RxSwift

class LibraryTableViewCell: UITableViewCell, ViewModelBased, NibReusable {
    @IBOutlet weak var libraryLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    private var disposeBag = DisposeBag()
    var viewModel: LibraryTableViewCellViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupUI() {
        selectionStyle = .none
        containerView.layer.cornerRadius = 5
        containerView.layer.shadowColor = UIColor.gray.cgColor
        containerView.layer.shadowOpacity = 10
        containerView.layer.shadowOffset = .zero
        containerView.layer.shadowRadius = 1
    }
    
    func configureCell(viewModel: LibraryTableViewCellViewModel) {
        self.viewModel = viewModel
        bindViewModel()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    private func bindViewModel() {
        let input = LibraryTableViewCellViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.libraryTitle.subscribe(onNext: { [weak self] (libraryTitle) in
            self?.libraryLabel.text = libraryTitle
        }).disposed(by: disposeBag)
    }
}
