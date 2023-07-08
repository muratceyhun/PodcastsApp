//
//  UserDefaults.swift
//  PodcastsApp
//
//  Created by Murat Ceyhun Korpeoglu on 7.07.2023.
//

import Foundation


extension UserDefaults {
    
    static let podcastKey = "podcastKey"
    static let downloadKey = "downloadKey"
    
    func downloadEpisode(episode: Episode) {
        
        do {
            var downloadedEpisodes = downloadedEpisodes()
            downloadedEpisodes.append(episode)
            let data = try JSONEncoder().encode(downloadedEpisodes)
            UserDefaults.standard.set(data, forKey: UserDefaults.downloadKey)
        } catch let encodeError {
            print("ERROR:", encodeError)
        }
        
    }
    
    
    func downloadedEpisodes() -> [Episode] {
        
        guard let data = UserDefaults.standard.data(forKey: UserDefaults.downloadKey) else {return []}
        do {
            let episodes = try JSONDecoder().decode([Episode].self , from: data)
            return episodes

        } catch let decodeError {
            print("ERROR:", decodeError)
        }
        
        return []
    }
    

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
