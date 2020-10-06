//
//  ChartTableViewCell.swift
//  Mp3App
//
//  Created by AnhLD on 10/6/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa
import SDWebImage

class ChartTableViewCell: UITableViewCell, NibReusable {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var singerLabel: UILabel!
    
    var viewModel: ChartTableViewCellViewModel!
    let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setupUI()
    }
    
    private func setupUI() {
        self.selectionStyle = .none
        albumImageView.layer.cornerRadius = 5
    }
    
    func configureCell(viewModel: ChartTableViewCellViewModel) {
        self.viewModel = viewModel
        binViewModel()
    }
    
    private func binViewModel() {
        let input = ChartTableViewCellViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.dataSource.drive(onNext: { [weak self] (album) in
            self?.albumLabel.text = album.track?.title
            self?.singerLabel.text = album.track?.user?.userName
            guard let url = album.track?.artworkURL else {
                return
            }
            self?.albumImageView.sd_imageTransition = .fade
            self?.albumImageView.sd_setImage(with: URL(string: url))
        }).disposed(by: disposeBag)
        
        output.rank.drive(onNext: { [weak self] (rank) in
            self?.rankLabel.text = "0\(rank)"
        }).disposed(by: disposeBag)
    }
}
