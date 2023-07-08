//
//  EpisodesController.swift
//  PodcastsApp
//
//  Created by Murat Ceyhun Korpeoglu on 11.06.2023.
//

import UIKit
import FeedKit

class EpisodeController: UITableViewController {
    
    var episodes = [Episode]()
    
    fileprivate let cellID = "cellID"
    
    var podcasts: Podcast? {
        didSet {
            navigationItem.title = podcasts?.trackName
            fetchEpisodes()        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        tableView.register(EpisodeCell.self, forCellReuseIdentifier: cellID)
        tableView.register(UINib(nibName: "EpisodeCell", bundle: nil), forCellReuseIdentifier: cellID)
        setupNavBarButton()
    }
    
    fileprivate func setupNavBarButton() {
        
        let savedPodcasts = UserDefaults.standard.savedPodcasts()
        
        let hasFavorited = savedPodcasts.firstIndex(where: { $0.trackName == self.podcasts?.trackName && $0.artistName == self.podcasts?.artistName && $0.artworkUrl100 == self.podcasts?.artworkUrl100
        }) != nil
        
        
        if hasFavorited {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "heart"), style: .plain, target: self, action: nil)
        } else {
            navigationItem.rightBarButtonItems = [
                UIBarButtonItem(title: "Favorite", style: .plain, target: self, action: #selector(handleSaveFavorite)),
//                UIBarButtonItem(title: "Fetch", style: .plain, target: self, action: #selector(handleFetch))
            ]
            
        }
   
    }
    
    let favPodcastKey = "podcastKey"
    
    
    @objc func handleFetch() {
        
        guard let data = UserDefaults.standard.data(forKey: favPodcastKey) else {return}
    
        do {
            let savedPodcasts = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Podcast]
            savedPodcasts?.forEach({ p in
                print(p.trackName ?? "", "|", p.artistName ?? "")
            })
            
        } catch let err1 {
            print("ERROR:", err1)
        }
    }
    
    @objc func handleSaveFavorite() {
        guard let podcast = podcasts else {return}

        let favPodcasts = UserDefaults.standard.savedPodcasts()
        var listOfPodcast = favPodcasts
        listOfPodcast.append(podcast)
//         Transform podcast into data...
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: listOfPodcast, requiringSecureCoding: false)
            UserDefaults.standard.set(data, forKey: favPodcastKey)
        } catch let getFavError {
            print("ERROR:", getFavError)
        }
        
        showBadgeHighlight()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "heart"), style: .plain, target: self, action: nil)
    }
    
    fileprivate func showBadgeHighlight() {
        UIApplication.mainTabBarController()?.viewControllers?[1].tabBarItem.badgeValue = "New  "
    }
    
    fileprivate func fetchEpisodes() {
        print("Looking for episodes at feed url", podcasts?.feedUrl ?? "")
        guard let feedUrl = podcasts?.feedUrl else {return}
        APIService.shared.fetchEpisodes(feedUrl: feedUrl) { episodes in
            self.episodes = episodes
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    //MARK: - TableViewSetup
    
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let context = UIContextualAction(style: .normal, title: "Download") { _, _, _ in
            UIApplication.mainTabBarController()?.viewControllers?[2].tabBarItem.badgeValue = "NEW"
            let episode = self.episodes[indexPath.item]
            UserDefaults.standard.downloadEpisode(episode: episode )
            
            // download the episode using Alamofire libr.
            
            APIService.shared.downloadEpisodes(episode: episode)
        }
        let swipeAction = UISwipeActionsConfiguration(actions: [context])
        return swipeAction
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.color = .darkGray
        activityIndicatorView.startAnimating()
        return activityIndicatorView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return episodes.isEmpty ? view.frame.midY : 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! EpisodeCell
        let episode = episodes[indexPath.row]
        cell.episode = episode
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let episode = self.episodes[indexPath.row]
        
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        let mainTabBarController = keyWindow?.rootViewController as? MainTabBarController
        mainTabBarController?.maximizePlayerDetails(episode: episode)

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
