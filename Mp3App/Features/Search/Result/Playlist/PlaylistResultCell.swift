//
//  PlaylistResultCell.swift
//  Mp3App
//
//  Created by Apple on 11/5/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Reusable

class PlaylistResultCell: UITableViewCell, ViewModelBased, NibReusable {
    @IBOutlet weak var playlistImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var viewModel: PlaylistResultCellViewModel!
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
        playlistImageView.layer.cornerRadius = 5
    }
    
    func configureCell(viewModel: PlaylistResultCellViewModel) {
        self.viewModel = viewModel
        bindViewModel()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    private func bindViewModel() {
        let input = PlaylistResultCellViewModel.Input()
        let output = viewModel.transform(input: input)
                
        output.playlist
            .subscribe(onNext: { [weak self] playlist in
                self?.titleLabel.text = playlist.title
                self?.descriptionLabel.text = playlist.user?.username
                guard let url = playlist.user?.avatarURL else {
                    return
                }
                self?.playlistImageView.setImage(stringURL: url)
            })
            .disposed(by: disposeBag)
    }
}
