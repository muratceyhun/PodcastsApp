//
//  RssFeed.swift
//  PodcastsApp
//
//  Created by Murat Ceyhun Korpeoglu on 15.06.2023.
//

import FeedKit


extension RSSFeed {
    func toEpisode() -> [Episode] {
        
        
        let imageUrl = iTunes?.iTunesImage?.attributes?.href
        var episodes = [Episode]()
        
        items?.forEach({ feedItem in
            var episode = Episode(feedItem: feedItem)
//            if episode.imageUrl == nil {
                episode.imageUrl = imageUrl
//            }
            episodes.append(episode)
        })
        
        return episodes
        
    }
}
