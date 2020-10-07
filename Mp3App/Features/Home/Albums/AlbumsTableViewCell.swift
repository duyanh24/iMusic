//
//  AlbumsTableViewCell.swift
//  Mp3App
//
//  Created by Apple on 10/6/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa
import RxDataSources

typealias AlbumSectionModel = SectionModel<String, Album>

class AlbumsTableViewCell: UITableViewCell, ViewModelBased, NibReusable {
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<AlbumSectionModel>(
        configureCell: { _, collectionView, indexPath, album in
            let cell = collectionView.dequeueReusableCell(for: indexPath) as AlbumCollectionViewCell
            let albumCollectionViewCellViewModel = AlbumCollectionViewCellViewModel(album: album)
            cell.configureCell(viewModel: albumCollectionViewCellViewModel)
            return cell
    })
    
    let contentOffsetChange = PublishSubject<CGPoint>()
    var viewModel: AlbumsTableViewCellViewModel!
    private var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func configureCell(viewModel: AlbumsTableViewCellViewModel) {
        self.viewModel = viewModel
        bindViewModel()
    }
    
    private func setupUI() {
        selectionStyle = .none
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.contentInset.left = 20
        collectionView.contentInset.right = 20
        collectionView.register(cellType: AlbumCollectionViewCell.self)
        collectionView.delegate = self
    }
    
    private func bindViewModel() {
        let input = AlbumsTableViewCellViewModel.Input()
        
        let output = viewModel.transform(input: input)
        
        output.dataSource
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.homeSectionType
            .drive(onNext: { [weak self] type in
                guard let self = self else { return }
                self.headerTitleLabel.text = type.title
            })
            .disposed(by: disposeBag)
        
        output.contentOffset
            .drive(onNext: { [weak self] contentOffset in
                self?.collectionView.setContentOffset(contentOffset, animated: false)
            }).disposed(by: disposeBag)
    }
}

extension AlbumsTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let titleHeight: CGFloat = 60
        let headerHeight: CGFloat = 65
        let height = contentView.frame.size.height - headerHeight
        let width = height - titleHeight
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension AlbumsTableViewCell: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = collectionView.contentOffset
        contentOffsetChange.onNext(contentOffset)
    }
}
