//
//  Podcast.swift
//  PodcastsApp
//
//  Created by Murat Ceyhun Korpeoglu on 8.06.2023.
//

import UIKit

class Podcast: NSObject, Decodable, NSCoding, NSSecureCoding {
    
    
    static var supportsSecureCoding: Bool {
            return true
        }
    
    func encode(with coder: NSCoder) {
        
        print("Trying to transform the Podcast into data")
        coder.encode(trackName ?? "", forKey: "trackName")
        coder.encode(artistName ?? "", forKey: "artistName")
        coder.encode(artworkUrl100 ?? "", forKey: "artworkUrl100")

    }
    
    required init?(coder: NSCoder) {
        print("Trying to turn data into the Podcast")
        
        self.trackName = coder.decodeObject(forKey: "trackName") as? String
        self.artistName = coder.decodeObject(forKey: "artistName") as? String
        self.artworkUrl100 = coder.decodeObject(forKey: "artworkUrl100") as? String


    }
    
    var trackName: String?
    var artistName: String?
    var artworkUrl100: String?
    var trackCount: Int?
    var feedUrl: String?
}
