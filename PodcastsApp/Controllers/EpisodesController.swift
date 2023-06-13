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
        
        episodes = [Episode]()
    }
    
    fileprivate func fetchEpisodes() {
        print("Looking for episodes at feed url", podcasts?.feedUrl ?? "")
        guard let feedURL = podcasts?.feedUrl else {return}
        guard let url = URL(string: feedURL) else {return}
        let parser = FeedParser(URL: url)
        parser.parseAsync { result in
            print("Successfully parse feed:")
            
            switch result {
            case .success(let feed):
                
                
                switch feed {
                case let .rss(feed):
                    var episodes = [Episode]()
                    feed.items?.forEach({ feedItem in
                        let episode = Episode(feedItem: feedItem)
                        episodes.append(episode)
                        self.episodes = episodes
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    })
                    break
                case .json(_):
                    break
                default:
                    print("Found a feed")
                }
                
            case .failure(let error):
                print("Failed to parse:", error)
            }
        }
    }
    
    
    //MARK: - TableViewSetup
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! EpisodeCell
        let episode = episodes[indexPath.row]
        cell.episode = episode
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
