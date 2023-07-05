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
        
        
    }
    
    @objc func minimizePlayerDetails() {
        maximizedTopAnchorConstraint.isActive = false
        bottomAnchorConstraint.constant = view.frame.height
         minimizedTopAnchorConstraint.isActive = true
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.view.layoutIfNeeded()
            self.tabBar.isHidden = false
            self.playerDetailsView.maximizedStackView.alpha = 0
            self.playerDetailsView.miniPlayerView.alpha = 1
        }
    }
    
    func maximizePlayerDetails(episode: Episode?) {
        minimizedTopAnchorConstraint.isActive = false
        maximizedTopAnchorConstraint.isActive = true
        maximizedTopAnchorConstraint.constant = 0
        bottomAnchorConstraint.constant = 0
        
        if episode != nil {
            playerDetailsView.episode = episode
        }
        
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.view.layoutIfNeeded()
//            self.tabBar.transform = CGAffineTransform(translationX: 0, y: 100 )
            self.tabBar.isHidden = true
            self.playerDetailsView.maximizedStackView.alpha = 1
            self.playerDetailsView.miniPlayerView.alpha = 0
            
            
        }
    }
    
    
    //MARK: - Setup Functions
    let playerDetailsView = PlayerDetailsView.initFromNib()
    
    var maximizedTopAnchorConstraint: NSLayoutConstraint!
    var minimizedTopAnchorConstraint: NSLayoutConstraint!
    var bottomAnchorConstraint: NSLayoutConstraint!

    
    fileprivate func setupPlayerDetailsView() {
         
        view.insertSubview(playerDetailsView, belowSubview: tabBar)
        
        playerDetailsView.translatesAutoresizingMaskIntoConstraints = false
        
        maximizedTopAnchorConstraint = playerDetailsView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        maximizedTopAnchorConstraint.isActive = true
        
        bottomAnchorConstraint = playerDetailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        bottomAnchorConstraint.isActive = true
        

        minimizedTopAnchorConstraint =  playerDetailsView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        //        minimizedTopAnchorConstraint.isActive = true
        //        playerDetailsView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        playerDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        playerDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
    
    //MARK: - Setup Functions
    fileprivate func setupViewControllers() {
        tabBar.backgroundColor = .lightGray
        tabBar.tintColor = .purple
        
        let layout = UICollectionViewFlowLayout()
        let favoritesController = FavoritesController(collectionViewLayout: layout)
        viewControllers = [
            generateNavController(with: favoritesController, title: "Favorites", imageName: "favorites"), generateNavController(with: PodcastsSearchController(), title: "Search", imageName: "search"), generateNavController(with: ViewController(), title: "Downloads", imageName: "downloads")
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
