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
            miniEpisodeImageView.sd_setImage(with: URL(string: episode.imageUrl ?? ""))
            miniTitleLabel.text = episode.title
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
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            
            self?.currentTimeLabel.text = time.toDisplayString()
            
            let durationTime = self?.player.currentItem?.duration
            self?.durationLabel.text = durationTime?.toDisplayString()
            self?.updateCurrentSlide()
        }
    }
    
    fileprivate func updateCurrentSlide() {
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? .zero)
        let percentage = currentTimeSeconds / durationSeconds
        self.currentTimeSlider.value = Float(percentage)
        
    }
    
    
    var panGesture: UIPanGestureRecognizer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximize)))
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
        observePlayerCurrentTime()
        
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            print("EPİSODE STARTED PLAYING ")
            self?.enlargeEpisodeImageView()
        }
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        if gesture.state == .changed {
            handlePanChanged(gesture: gesture)
        } else if gesture.state == .ended {
            handlePanEnded(gesture: gesture)
        }
    }
    
    func handlePanChanged(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        self.transform = CGAffineTransform(translationX: 0, y: translation.y)
        self.miniPlayerView.alpha = 1 + translation.y / 300
        self.maximizedStackView.alpha = -translation.y / 300
    }
    
    func handlePanEnded(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        let velocity = gesture.velocity(in: self.superview)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1) {
            self.transform = .identity
            
            if translation.y < -300 || velocity.y < -500 {
                let keyWindow = UIApplication.shared.connectedScenes
                    .filter({$0.activationState == .foregroundActive})
                    .compactMap({$0 as? UIWindowScene})
                    .first?.windows
                    .filter({$0.isKeyWindow}).first
                let mainTabBarController = keyWindow?.rootViewController as? MainTabBarController
                mainTabBarController?.maximizePlayerDetails(episode: nil)
                gesture.isEnabled = false
            } else {
                self.miniPlayerView.alpha = 1
                self.maximizedStackView.alpha = 0
            }
        }
    }
    
    @objc func handleTapMaximize() {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        let mainTabBarController = keyWindow?.rootViewController as? MainTabBarController
        mainTabBarController?.maximizePlayerDetails(episode: nil)
        panGesture.isEnabled = false
    }
    
    
    static func initFromNib() -> PlayerDetailsView {
        Bundle.main.loadNibNamed("PlayerDetailsView", owner: self)?.first as! PlayerDetailsView
    }
    
    
    
    //MARK: - IB Actions and Outlets
    
    
    @IBOutlet weak var miniEpisodeImageView: UIImageView!
    
    
    @IBOutlet weak var miniTitleLabel: UILabel!
    
    @IBOutlet weak var miniPlayPauseButton: UIButton! {
        didSet {
            miniPlayPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var miniFastForwardButton: UIButton! {
        didSet {
            miniFastForwardButton.addTarget(self, action: #selector(miniFastForward), for: .touchUpInside)
        }
    }
    
    @objc func miniFastForward () {
        seekToCurrentTime(delta: 15)
    }
    
    
    
    
    
    
    
    @IBOutlet weak var miniPlayerView: UIView!
    
    
    @IBOutlet weak var maximizedStackView: UIStackView!
    
    
    @IBAction func handleCurrentTimeSliderChange(_ sender: Any) {
        print("It shows", currentTimeSlider.value)
        
        let percentage = currentTimeSlider.value
        guard let duration = player.currentItem?.duration else {return}
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeInSeconds = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: Int32(NSEC_PER_SEC))
        
        player.seek(to: seekTime)
    }
    
    @IBAction func handleRewind(_ sender: Any) {
        seekToCurrentTime(delta: -15)
    }
    
    @IBAction func handleFastForward(_ sender: Any) {
        seekToCurrentTime(delta: 15)
    }
    
    fileprivate func seekToCurrentTime(delta: Int64) {
        let fifteenSeconds = CMTimeMake(value: delta, timescale: 1)
        let seekTime = CMTimeAdd(player.currentTime(), fifteenSeconds)
        player.seek(to: seekTime)
    }
    
    @IBAction func handleVolumeChange(_ sender: UISlider) {
        
        player.volume = sender.value
    }
    
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    
    @IBOutlet weak var durationLabel: UILabel!
    
    
    @IBOutlet weak var currentTimeSlider: UISlider!
    
    
    
    @IBAction func handleDismiss(_ sender: Any) {
        //        removeFromSuperview()
        
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        let mainTabBarController = keyWindow?.rootViewController as? MainTabBarController
        mainTabBarController?.minimizePlayerDetails()
        panGesture.isEnabled = true
        
        
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
            miniPlayPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            self.enlargeEpisodeImageView()
        } else {
            player.pause()
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
            miniPlayPauseButton.setImage(UIImage(named: "play"), for: .normal)
            
            self.shrinkEpisodeImageView()
            
        }
    }
    
    
    
}
