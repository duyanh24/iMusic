//
//  SlideTableViewCell.swift
//  Mp3App
//
//  Created by AnhLD on 10/2/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import UIKit
import Reusable
import SDWebImage

protocol SlideTableViewCellDelegate: AnyObject {
    func didEndDragging(startIndex: Int)
}

class SlideTableViewCell: UITableViewCell, NibReusable {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    private var albums = [Album]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    weak var delegate: SlideTableViewCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupData(albums: [Album], startIndex: Int){
        self.albums = albums
        pageControl.numberOfPages = albums.count
        
        collectionView.scrollToItem(at: IndexPath(item: startIndex, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
        guard let url = albums[startIndex].track?.artworkURL else {
            return
        }
        
        backgroundImageView.sd_imageTransition = .fade
        let transformer = SDImageBlurTransformer(radius: 100)
        let context: [SDWebImageContextOption: Any]? = [.imageTransformer: transformer]
        backgroundImageView.sd_setImage(with: URL(string: url), placeholderImage: nil, context: context, progress: nil) { [weak self] (_, error, _, _) in
            if error != nil {
                self?.backgroundImageView.image = nil
            }
        }
        
    }
    
    func setupCollectionView() {
        collectionView.register(cellType: SlideCollectionViewCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
    }
}

extension SlideTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as SlideCollectionViewCell
        cell.setupData(album: albums[indexPath.row])
        return cell
    }
}

extension SlideTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension SlideTableViewCell: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = scrollView.contentOffset.x / collectionView.frame.size.width
        pageControl.currentPage = Int(currentPage)
        guard let url = albums[Int(currentPage)].track?.artworkURL else {
            return
        }
        backgroundImageView.sd_imageTransition = .fade
        let transformer = SDImageBlurTransformer(radius: 50)
        let context: [SDWebImageContextOption: Any]? = [.imageTransformer: transformer]
        backgroundImageView.sd_setImage(with: URL(string: url), placeholderImage: nil, context: context, progress: nil) { [weak self] (_, error, _, _) in
            if error != nil {
                self?.backgroundImageView.image = nil
            }
        }
        delegate.didEndDragging(startIndex: Int(currentPage))
    }
}
