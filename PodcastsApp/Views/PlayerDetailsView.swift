//
//  PlayerDetailsView.swift
//  PodcastsApp
//
//  Created by Murat Ceyhun Korpeoglu on 16.06.2023.
//

import UIKit

class PlayerDetailsView: UIView {
    
    var episode: Episode! {
        didSet{
            episodeImageView.sd_setImage(with: URL(string: episode.imageUrl ?? ""))
            titleLabel.text = episode.title
        }
    }
    
    @IBAction func handleDismiss(_ sender: Any) {
        removeFromSuperview()
    }
    
    @IBOutlet weak var episodeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
 
}
