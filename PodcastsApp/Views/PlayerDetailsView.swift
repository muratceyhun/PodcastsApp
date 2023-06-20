//
//  PlayerDetailsView.swift
//  PodcastsApp
//
//  Created by Murat Ceyhun Korpeoglu on 16.06.2023.
//

import UIKit
import AVKit

class PlayerDetailsView: UIView {
    
    var episode: Episode! {
        didSet{
            episodeImageView.sd_setImage(with: URL(string: episode.imageUrl ?? ""))
            titleLabel.text = episode.title
            authorLabel.text = episode.author
            playEpisode()
        }
    }
    
    fileprivate func playEpisode() {
        print("Trying to play episode at url:", episode.streamUrl ?? "")
        
        guard let url = URL(string: episode.streamUrl ?? "") else {return}
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    
    fileprivate func observePlayerCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { time in
         
            self.currentTimeLabel.text = time.toDisplayString()
            
            let durationTime = self.player.currentItem?.duration
            self.durationLabel.text = durationTime?.toDisplayString()
            self.updateCurrentSlide()
        }
    }
    
    fileprivate func updateCurrentSlide() {
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? .zero)
        let percentage = currentTimeSeconds / durationSeconds
        self.currentTimeSlider.value = Float(percentage)
        
    }
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        observePlayerCurrentTime()
        
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]

        player.addBoundaryTimeObserver(forTimes: times, queue: .main) {
            print("EPİSODE STARTED PLAYING ")
            self.enlargeEpisodeImageView()
        }
        
        
    }
    
    
    
    //MARK: - IB Actions and Outlets
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    
    @IBOutlet weak var durationLabel: UILabel!
    
    
    @IBOutlet weak var currentTimeSlider: UISlider!
    
    
    
    @IBAction func handleDismiss(_ sender: Any) {
        removeFromSuperview()
        player.pause()
    }
    
    
    fileprivate func enlargeEpisodeImageView() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1) {
            self.episodeImageView.transform = .identity
        }
    }
    
    fileprivate func shrinkEpisodeImageView() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1) {
            self.episodeImageView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }
    }
    
    
    
    
    @IBOutlet weak var episodeImageView: UIImageView! {
        didSet {
            episodeImageView.layer.cornerRadius = 16
            let scale: CGFloat = 0.7
            episodeImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.numberOfLines = 2
        }
    }
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton! {
        didSet {
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            playPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        }
    }
    
    @objc func handlePlayPause() {
        
//        player.timeControlStatus == .paused ? player.play() : player.pause()
        
        if player.timeControlStatus == .paused {
            player.play()
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            self.enlargeEpisodeImageView()
        } else {
            player.pause()
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
            self.shrinkEpisodeImageView()

        }
    }
    
    
 
}
