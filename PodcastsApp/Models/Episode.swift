//
//  Episode.swift
//  PodcastsApp
//
//  Created by Murat Ceyhun Korpeoglu on 13.06.2023.
//

import Foundation
import FeedKit


struct Episode {
    let title: String
    let pubDate: Date
    let description: String
    var imageUrl: String?
    let author: String?
    
    init(feedItem: RSSFeedItem) {
        self.title = feedItem.title ?? ""
        self.pubDate = feedItem.pubDate ?? Date()
        self.description = feedItem.description ?? ""
        self.imageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href ?? ""
        self.author = feedItem.iTunes?.iTunesAuthor ?? ""
    }
}
