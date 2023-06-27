//
//  UIApplication.swift
//  PodcastsApp
//
//  Created by Murat Ceyhun Korpeoglu on 27.06.2023.
//

import UIKit

extension UIApplication {
    static func mainTabBarController() -> MainTabBarController? {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first
    
        return keyWindow?.rootViewController as? MainTabBarController
    }
}
