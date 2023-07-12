//
//  DownloadsController.swift
//  PodcastsApp
//
//  Created by Murat Ceyhun Korpeoglu on 8.07.2023.
//

import UIKit


class DownloadsController: UITableViewController {
    
    var episodes = UserDefaults.standard.downloadedEpisodes()
    
    
    let cellID = "cellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupObservers()
    }
    
    fileprivate func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleDownloadProgress), name: .downloadProgress, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDownloadComplete), name: .downloadComplete, object: nil)
    }
    
    @objc func handleDownloadComplete(notification: Notification) {
        guard let episodeDownloadComplete = notification.object as? APIService.EpisodeDownloadCompleteTuple else {return }
        let indexx = self.episodes.firstIndex { ($0.title == episodeDownloadComplete.episodeTitle) }
        
        
       guard let index = indexx else {return}
        
        self.episodes[index].fileUrl = episodeDownloadComplete.fileUrl
    }
    
    @objc func handleDownloadProgress(notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: Any] else {return}
        
        
        guard let progress = userInfo["progress"] as? Double else {return}
        guard let title = userInfo["title"] as? String else {return}
        print(progress, "|", title)
        
        
        // finding the index belongs to which episode.
        
         let indexx = self.episodes.firstIndex { ($0.title == title) }
        guard let index = indexx else {return}
        
        guard let cell =
            tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? EpisodeCell else {return}
        cell.progressLabel.isHidden = false
        cell.progressLabel.text = "%\(Int(progress*100))"
        if progress == 1 {
            cell.progressLabel.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        episodes = UserDefaults.standard.downloadedEpisodes()
        UIApplication.mainTabBarController()?.viewControllers?[2].tabBarItem.badgeValue = nil
        tableView.reloadData()
    }
    
    fileprivate func setupTableView() {
        tableView.register(UINib(nibName: "EpisodeCell", bundle: nil), forCellReuseIdentifier: cellID)
    }
    
    
    
    //MARK:  - UITableView

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! EpisodeCell
        cell.episode = self.episodes[indexPath.item]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = self.episodes[indexPath.item]
        
        if episode.fileUrl != nil {
            UIApplication.mainTabBarController()?.maximizePlayerDetails(episode: episode)
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            let alertController = UIAlertController(title: "Fileurl not found", message: "Use your streamURL instead ?", preferredStyle: .actionSheet)
            
            alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
                UIApplication.mainTabBarController()?.maximizePlayerDetails(episode: episode)
            }))
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .destructive))
            
            present(alertController, animated: true)
        
        }
         
       
    }
    
    
    
}
