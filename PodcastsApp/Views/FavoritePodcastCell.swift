//
//  FavoritePodcastCell.swift
//  PodcastsApp
//
//  Created by Murat Ceyhun Korpeoglu on 5.07.2023.
//

import UIKit


class FavoritePodcastCell: UICollectionViewCell {
    
    
    var podcasts: Podcast! {
        didSet {
            nameLabel.text = podcasts?.trackName
            artistNameLabel.text = podcasts?.artistName
            imageView.sd_setImage(with: URL(string: podcasts?.artworkUrl100 ?? ""))
            imageView.layer.cornerRadius = 16
            imageView.clipsToBounds = true
        }
    }
    
    let imageView = UIImageView(image: UIImage(named: "appicon"))
    let nameLabel = UILabel()
    let artistNameLabel = UILabel()
    
    fileprivate func stylizeUI() {
        nameLabel.text = "Podcast Name"
        nameLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        artistNameLabel.text = "Artist Name"
        artistNameLabel.textColor = .lightGray
        artistNameLabel.font = UIFont.systemFont(ofSize: 13)
    }
    
    fileprivate func setupViews() {
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        let stackView = UIStackView(arrangedSubviews: [imageView, nameLabel, artistNameLabel])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor ).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        stylizeUI()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
