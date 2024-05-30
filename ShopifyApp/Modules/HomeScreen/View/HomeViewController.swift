//
//  HomeViewController.swift
//  ShopifyApp
//
//  Created by Aya Mostafa on 26/05/2024.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var homeCollection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        

        homeCollection.delegate = self
        homeCollection.dataSource = self
    
        // Do any additional setup after loading the view.
    }

    func brandsSection() -> NSCollectionLayoutSection {
        // Define the size of each item (movie cell)
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), // Each item takes up half of the width
                                              heightDimension: .absolute(250)) // Keep the height as 250 points

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 25) // Add spacing between items
        
        // Create a group that contains two items horizontally
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), // The group takes up the full width of the section
                                               heightDimension: .absolute(250)) // Each group takes up the full height of the section
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])
        
        // Center the group within the section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15)
        section.contentInsetsReference = .layoutMargins
        section.interGroupSpacing = 10 // Add spacing between rows
        
        return section
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let brandCell = collectionView.dequeueReusableCell(withReuseIdentifier: "adsCell", for: indexPath) as! BrandsCollectionViewCell

        return brandCell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
