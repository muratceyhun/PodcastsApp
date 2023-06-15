//
//  APIService.swift
//  PodcastsApp
//
//  Created by Murat Ceyhun Korpeoglu on 9.06.2023.
//

import UIKit
import Alamofire
import FeedKit

class APIService {
    
    // Singleton
    static let shared = APIService()
    
    
    func fetchEpisodes(feedUrl: String, completionHandler: @escaping ([Episode]) -> ()) {
        let secureFeedUrl = feedUrl.contains("https") ? feedUrl : feedUrl.replacingOccurrences(of: "http", with: "https")
        guard let url = URL(string: secureFeedUrl) else {return}
        let parser = FeedParser(URL: url)
        parser.parseAsync { result in
            print("Successfully parse feed:")
            
            switch result {
            case .success(let feed):
                
                switch feed {
                case let .rss(feed):
                    
                    let episodes = feed.toEpisode()
                    completionHandler(episodes)
//                    self.episodes = feed.toEpisode()
//                    DispatchQueue.main.async {
//                        self.tableView.reloadData()
//                    }
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
    
    func fetchPodcasts(searchText: String, completionHandler: @escaping ([Podcast]) -> ()) {
        let baseURL = "https://itunes.apple.com/search"
        let parameters = ["term": searchText, "media": "podcast"]
        
        AF.request(baseURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { dataResponse in
            if let error = dataResponse.error {
                print("ERROR: \(error)")
                return
            }
            
            guard let data = dataResponse.data else {return}
            
            do {
                let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
//                self.dummyPodcats = searchResult.results
//                self.tableView.reloadData()
                completionHandler(searchResult.results)
            } catch let decodeErr {
                print("ERROR: ", decodeErr)
            }
        
            struct SearchResult: Decodable {
                let resultCount: Int
                let results: [Podcast]
            }
        }
    }
}
