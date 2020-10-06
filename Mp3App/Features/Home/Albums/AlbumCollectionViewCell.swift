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

class AlbumCollectionViewCell: UICollectionViewCell, NibReusable {
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var albumTitleLabel: UILabel!
    
    var viewModel: AlbumCollectionViewCellViewModel!
    private let disposeBag = DisposeBag()
    
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
                self?.albumTitleLabel.text = album.track?.title
                guard let url = album.track?.artworkURL else {
                    return
                }
                let imgMediumUrl = Converter.convertLargeImgtoCrop(imgUrl: url)
                self?.albumImageView.sd_imageTransition = .fade
                self?.albumImageView.sd_setImage(with: URL(string: imgMediumUrl))
            })
            .disposed(by: disposeBag)
    }
}
