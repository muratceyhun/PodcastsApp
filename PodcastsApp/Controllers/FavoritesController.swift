//
//  FavoritesController.swift
//  PodcastsApp
//
//  Created by Murat Ceyhun Korpeoglu on 5.07.2023.
//

import UIKit

class FavoritesController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    fileprivate let cellID = "cellID"
    
    
    var favoritePodcasts = UserDefaults.standard.savedPodcasts()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoritePodcasts = UserDefaults.standard.savedPodcasts()
        collectionView.reloadData()
        UIApplication.mainTabBarController()?.viewControllers?[1].tabBarItem.badgeValue = nil
    }
    
    fileprivate func setupCollectionView() {
        collectionView.register(FavoritePodcastCell.self, forCellWithReuseIdentifier: cellID)
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        collectionView.addGestureRecognizer(gesture)
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        print("-------")
        
        let location = gesture.location(in: collectionView)
        guard let selectedIndexPath = collectionView.indexPathForItem(at: location) else {return}
        print(selectedIndexPath)
        
        let alertController = UIAlertController(title: "Remove Podcast? ", message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "YES", style: .destructive, handler: { _ in
            self.favoritePodcasts.remove(at: selectedIndexPath.item)
            self.collectionView.deleteItems(at: [selectedIndexPath])
        }))
        alertController.addAction(UIAlertAction(title: "CANCEL", style: .default))
        present(alertController, animated: true)
    }
    
  
    
    
    //MARK: - UICollectionView Delegate and Spacing Methods.
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoritePodcasts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! FavoritePodcastCell
        cell.podcasts = favoritePodcasts[indexPath.item]
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let episodesController = EpisodeController()
        episodesController.podcasts = self.favoritePodcasts[indexPath.item]
        navigationController?.pushViewController(episodesController, animated: true)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3*16) / 2
        return .init(width: width , height: width + 46)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        16

    }
 
     
}




