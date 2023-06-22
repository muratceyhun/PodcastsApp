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
        setupPlayerDetailsView()
        
        perform(#selector(maximizePlayerDetails), with: nil, afterDelay: 1)
        
    }
    
    @objc func minimizePlayerDetails() {
        maximizedTopAnchorConstraint.isActive = false
        minimizedTopAnchorConstraint.isActive = true
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func maximizePlayerDetails() {
        minimizedTopAnchorConstraint.isActive = false
        maximizedTopAnchorConstraint.constant = 0
        maximizedTopAnchorConstraint.isActive = true
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    var maximizedTopAnchorConstraint: NSLayoutConstraint!
    var minimizedTopAnchorConstraint: NSLayoutConstraint!
    
    
    fileprivate func setupPlayerDetailsView() {
        let playerDetailsView = PlayerDetailsView.initFromNib()
        playerDetailsView.backgroundColor = .red
        //        playerDetailsView.frame = view.frame
        //        view.addSubview(playerDetailsView)
        view.insertSubview(playerDetailsView, belowSubview: tabBar)
        
        playerDetailsView.translatesAutoresizingMaskIntoConstraints = false
        
        maximizedTopAnchorConstraint = playerDetailsView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
                maximizedTopAnchorConstraint.isActive = true
        
        
        minimizedTopAnchorConstraint =  playerDetailsView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        //        minimizedTopAnchorConstraint.isActive = true
        //        playerDetailsView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        playerDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        playerDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerDetailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    //MARK: - Setup Functions
    fileprivate func setupViewControllers() {
        tabBar.backgroundColor = .lightGray
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
