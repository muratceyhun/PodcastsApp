//
//  String.swift
//  PodcastsApp
//
//  Created by Murat Ceyhun Korpeoglu on 15.06.2023.
//

import Foundation


extension String {
    
    func toSecureHTTPS() -> String{
        
        return self.contains("https") ? self : self.replacingOccurrences(of: "http", with: "https")
    }
}
