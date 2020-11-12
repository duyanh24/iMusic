//
//  LibraryDetailTableViewCell.swift
//  Mp3App
//
//  Created by Apple on 10/18/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import UIKit
import Reusable
import RxSwift

class LibraryDetailTableViewCell: UITableViewCell, ViewModelBased, NibReusable {
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var optionButton: UIButton!
    
    var viewModel: LibraryDetailCellViewModel!
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
        albumImageView.layer.cornerRadius = 5
    }
    
    func configureCell(viewModel: LibraryDetailCellViewModel) {
        self.viewModel = viewModel
        bindViewModel()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    private func bindViewModel() {
        let input = LibraryDetailCellViewModel.Input(optionButton: optionButton.rx.tap.asObservable())
        let output = viewModel.transform(input: input)
                
        output.track
            .subscribe(onNext: { [weak self] track in
                self?.titleLabel.text = track.title
                self?.descriptionLabel.text = track.description
                guard let url = track.artworkURL else {
                    return
                }
                self?.albumImageView.setImage(stringURL: url)
            })
            .disposed(by: disposeBag)
        
        output.showTrackOption.subscribe().disposed(by: disposeBag)
    }
}
