//
//  PlaylistTableViewCell.swift
//  Mp3App
//
//  Created by AnhLD on 10/13/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import UIKit
import Reusable
import RxSwift

class PlaylistTableViewCell: UITableViewCell, NibReusable {
    @IBOutlet weak var playlistImageView: UIImageView!
    @IBOutlet weak var playlistLabel: UILabel!
    
    var viewModel: PlaylistTableViewCellViewModel!
    private var disposeBag = DisposeBag()
    
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
        playlistImageView.layer.cornerRadius = 5
        selectionStyle = .none
    }
    
    func configureCell(viewModel: PlaylistTableViewCellViewModel) {
        self.viewModel = viewModel
        bindViewModel()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    private func bindViewModel() {
        let input = PlaylistTableViewCellViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.playlist.subscribe(onNext: { [weak self] (playlist) in
            self?.playlistLabel.text = playlist
        }).disposed(by: disposeBag)
    }
}
