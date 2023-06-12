//
//  EpisodesController.swift
//  PodcastsApp
//
//  Created by Murat Ceyhun Korpeoglu on 11.06.2023.
//

import UIKit

class EpisodeController: UITableViewController {
    
    
    var episodes = [Episode]()
    
    struct Episode {
        let title: String?
    }
    
    
    fileprivate let cellID = "cellID"
    
    var podcasts: Podcast? {
        didSet {
            navigationItem.title = podcasts?.trackName
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        episodes = [ Episode(title: "First Episode"),
                     Episode(title: "Second Episode"),
                     Episode(title: "Third Episode")
        ]
    }
    
    
    //MARK: - TableViewSetup
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let episode = episodes[indexPath.row]
        cell.textLabel?.text = episode.title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 120
//    }
}
