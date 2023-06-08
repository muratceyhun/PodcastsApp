//
//  MainTabBarController.swift
//  PodcastsApp
//
//  Created by Murat Ceyhun Korpeoglu on 6.06.2023.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
    }
    
    //MARK: - Setup Functions
    fileprivate func setupViewControllers() {
        tabBar.tintColor = .purple
        viewControllers = [generateNavController(with: PodcastsSearchController(), title: "Search", imageName: "search"),
                           generateNavController(with: ViewController(), title: "Favorites", imageName: "favorites"),
                           
                           generateNavController(with: ViewController(), title: "Downloads", imageName: "downloads")
        ]
    }
    
    //MARK: - Helper Functions
    fileprivate func generateNavController(with rootViewController: UIViewController, title: String, imageName: String) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        rootViewController.navigationItem.title = title
        navController.navigationBar.prefersLargeTitles = true
        navController.tabBarItem.image = UIImage(named: imageName)
        
        return navController
    }
}
