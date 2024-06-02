//
//  HomeScViewController.swift
//  ShopifyApp
//
//  Created by Aya Mostafa on 02/06/2024.
//

import UIKit

class HomeScViewController: UIViewController {

    @IBOutlet weak var brandsCollection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handleNavigationBar()
    }
    
    
    func handleNavigationBar() {
        guard let view = self.navigationController?.visibleViewController else {
            return
        }
        
        let searchButton = UIBarButtonItem(image: UIImage(named: "searcc.svg"), style: .plain, target: self, action: #selector(addTapped))
        let cartButton = UIBarButtonItem(image: UIImage(systemName: "cart"), style: .plain, target: self, action: #selector(cartBtn))
        let heartButton = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(heartBtn))
        
        searchButton.tintColor = UIColor(ciColor: .black)
        cartButton.tintColor = UIColor(ciColor: .black)
        heartButton.tintColor = UIColor(ciColor: .black)
        
        view.navigationItem.leftBarButtonItem = searchButton
        view.navigationItem.rightBarButtonItems = [heartButton, cartButton] // Assign array of buttons
    }
    
    
    @objc func addTapped(){
        
        print("perform")
    }
    
    @objc func cartBtn(){
        
        print("perform")
    }
    
    @objc func heartBtn(){
        
        print("perform")
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
