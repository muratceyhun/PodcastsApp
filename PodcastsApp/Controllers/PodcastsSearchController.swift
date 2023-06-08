//
//  PodcastsSearchController.swift
//  PodcastsApp
//
//  Created by Murat Ceyhun Korpeoglu on 8.06.2023.
//

import UIKit

class PodcastsSearchController: UITableViewController, UISearchBarDelegate {
    
    let cellID = "cellID"
    
    let dummyPodcats = [Podcast(name: "MCK", artistName: "Murat Ceyhun korpeoglu"),
                               Podcast(name: "HK", artistName: "Hanife Korpeoglu")
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
        print(searchText)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyPodcats.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let podcast = dummyPodcats[indexPath.item]
        cell.textLabel?.numberOfLines = -1
        cell.textLabel?.text = "\(podcast.name)\n\(podcast.artistName)"
        cell.imageView?.image = UIImage(named: "appicon")

        return cell
    }
}
