//
//  APIService.swift
//  PodcastsApp
//
//  Created by Murat Ceyhun Korpeoglu on 9.06.2023.
//

import UIKit
import Alamofire

class APIService {
    
    // Singleton
    static let shared = APIService()
    
    func fetchPodcasts(searchText: String, completionHandler: @escaping ([Podcast])->()) {
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
