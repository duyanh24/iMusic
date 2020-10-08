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

class SlideTableViewCell: UITableViewCell, NibReusable {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    private var albums = [Album]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupData(albums: [Album]){
        self.albums = albums
        pageControl.numberOfPages = albums.count
    }
    
    private func setupUI() {
        self.selectionStyle = .none
        collectionView.layer.cornerRadius = 5
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
        let paddingTop: CGFloat = 20.0
        let paddingLeft: CGFloat = 20.0
        let width = containerView.frame.size.width - paddingLeft * 2
        let height = containerView.frame.size.height - paddingTop * 2
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension SlideTableViewCell: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = scrollView.contentOffset.x / collectionView.frame.size.width
        pageControl.currentPage = Int(currentPage)
    }
}
