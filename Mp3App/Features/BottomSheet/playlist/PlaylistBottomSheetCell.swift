//
//  PlaylistBottomSheetCell.swift
//  Mp3App
//
//  Created by AnhLD on 11/12/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import UIKit
import Reusable
import RxSwift

class PlaylistBottomSheetCell: UITableViewCell, NibReusable {
    @IBOutlet weak var playlistLabel: UILabel!
    @IBOutlet weak var playlistImageView: UIImageView!
    
    var viewModel: PlaylistBottomSheetCellViewModel!
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
    
    func configureCell(viewModel: PlaylistBottomSheetCellViewModel) {
        self.viewModel = viewModel
        bindViewModel()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    private func bindViewModel() {
        let input = PlaylistBottomSheetCellViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.playlistName.subscribe(onNext: { [weak self] (playlist) in
            self?.playlistLabel.text = playlist
        }).disposed(by: disposeBag)
    }
}
