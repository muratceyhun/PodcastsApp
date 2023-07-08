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
        UIApplication.mainTabBarController()?.maximizePlayerDetails(episode: episode)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
}
