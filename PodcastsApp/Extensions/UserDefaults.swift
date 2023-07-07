//
//  UserDefaults.swift
//  PodcastsApp
//
//  Created by Murat Ceyhun Korpeoglu on 7.07.2023.
//

import Foundation


extension UserDefaults {
    
    static let podcastKey = "podcastKey"
    
    func savedPodcasts() -> [Podcast] {
        
        guard let savedPodcastsData = UserDefaults.standard.data(forKey: UserDefaults.podcastKey) else {return []}
        var listDummy = [Podcast]()
        do {
            let savedPodcasts = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPodcastsData) as? [Podcast]
            guard let savePodcast = savedPodcasts else {return []}
            listDummy = savePodcast
        } catch let err2 {
            print("ERROR", err2)
        }
        let listOfPodcast = listDummy
        return listOfPodcast
    }
}
