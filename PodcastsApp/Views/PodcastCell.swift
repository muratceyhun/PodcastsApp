//
//  PodcastCell.swift
//  PodcastsApp
//
//  Created by Murat Ceyhun Korpeoglu on 11.06.2023.
//

import UIKit
import SDWebImage

class PodcastCell: UITableViewCell {
    
    @IBOutlet weak var podcastImageView: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var episodeCountLabel: UILabel!
    
    
    var podcast: Podcast! {
        didSet {
            trackNameLabel.text = podcast.trackName
            artistNameLabel.text = podcast.artistName
            episodeCountLabel.text = "\(podcast.trackCount ?? .zero) Episodes"
            podcastImageView.sd_setImage(with: URL(string: podcast.artworkUrl100 ?? ""))
        }
    }
    
}
