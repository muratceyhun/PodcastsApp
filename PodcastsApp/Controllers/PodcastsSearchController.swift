//
//  PodcastsSearchController.swift
//  PodcastsApp
//
//  Created by Murat Ceyhun Korpeoglu on 8.06.2023.
//

import UIKit
import Alamofire

class PodcastsSearchController: UITableViewController, UISearchBarDelegate {
    
    let cellID = "cellID"
    
    var dummyPodcats = [Podcast(trackName: "MCK", artistName: "Murat Ceyhun korpeoglu"),
                               Podcast(trackName: "HK", artistName: "Hanife Korpeoglu")
    ]
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupTableView()
    }
    
    //MARK: - setupTableView
    fileprivate func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }
    //MARK: - setupSearchBar
    fileprivate func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let url = "https://itunes.apple.com/search"
        let parameters = ["term": searchText]
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { dataResponse in
            if let error = dataResponse.error {
                print("ERROR: \(error)")
                return
            }
            
            guard let data = dataResponse.data else {return}
            
            do {
                let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                self.dummyPodcats = searchResult.results
                self.tableView.reloadData()
            } catch let decodeErr {
                print("ERROR: ", decodeErr)
            }
        
            struct SearchResult: Decodable {
                let resultCount: Int
                let results: [Podcast]
            }
        }
 
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyPodcats.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let podcast = dummyPodcats[indexPath.item]
        cell.textLabel?.numberOfLines = -1
        cell.textLabel?.text = "\(podcast.trackName ?? "")\n\(podcast.artistName ?? "")"
        cell.imageView?.image = UIImage(named: "appicon")

        return cell
    }
}
