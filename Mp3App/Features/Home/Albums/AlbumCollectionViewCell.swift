//
//  AlbumCollectionViewCell.swift
//  Mp3App
//
//  Created by Apple on 10/6/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa

class AlbumCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var albumTitleLabel: UILabel!
    
    var viewModel: AlbumCollectionViewCellViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        // Initialization code
    }
    
    private func setupUI() {
        albumImageView.layer.cornerRadius = 5
    }
    
    func configureCell(viewModel: AlbumCollectionViewCellViewModel) {
        self.viewModel = viewModel
        bindViewModel()
    }

    private func bindViewModel() {
        let input = AlbumCollectionViewCellViewModel.Input()
        let output = viewModel.transform(input: input)
                
        output.album
            .drive(onNext: { [weak self] album in
                // show data album
            })
            .disposed(by: disposeBag)
    }
}
