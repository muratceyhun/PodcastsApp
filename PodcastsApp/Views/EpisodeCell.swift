//
//  EpisodeCell.swift
//  PodcastsApp
//
//  Created by Murat Ceyhun Korpeoglu on 14.06.2023.
//

import UIKit
import SDWebImage

class EpisodeCell: UITableViewCell {
    
    var episode: Episode! {
        didSet {
            let url = URL(string: episode.imageUrl ?? "")
            episodeImageView.sd_setImage(with:url)
            titleLabel.text = episode.title
            descriptionLabel.text = episode.description
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            pubDateLabel.text = dateFormatter.string(from: episode.pubDate)
            
        }
    }

    @IBOutlet weak var episodeImageView: UIImageView!
    @IBOutlet weak var pubDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.numberOfLines = 2
        }
    }
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.numberOfLines = 2
        }
    }
    
}
