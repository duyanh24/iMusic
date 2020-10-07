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

class AlbumCollectionViewCell: UICollectionViewCell, ViewModelBased, NibReusable {
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var albumTitleLabel: UILabel!
    
    var viewModel: AlbumCollectionViewCellViewModel!
    private var disposeBag = DisposeBag()
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    private func bindViewModel() {
        let input = AlbumCollectionViewCellViewModel.Input()
        let output = viewModel.transform(input: input)
                
        output.album
            .drive(onNext: { [weak self] album in
                // show data album
                self?.albumTitleLabel.text = album.track?.title
                guard let url = album.track?.artworkURL else {
                    return
                }
                let imageMediumURL = Converter.changeImageURLSize(imgURL: url, originalSize: .large, desireSize: .medium)
                self?.albumImageView.setImage(stringURL: imageMediumURL)
            })
            .disposed(by: disposeBag)
    }
}
