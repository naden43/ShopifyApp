//
//  ProfileViewController.swift
//  ShopifyApp
//
//  Created by Naden on 31/05/2024.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        
        let view = self.navigationController?.visibleViewController
        
        
        view?.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "gearshape") , style: .plain, target: self, action: #selector(performNavToSettings)) , UIBarButtonItem(image: UIImage(systemName: "cart") , style: .plain, target: self, action: #selector(performNavToCart))]
        
        for item in view?.navigationItem.rightBarButtonItems ?? [] {
             
            item.tintColor = UIColor(.black)
        }
       view?.title = "profile"
    }
    
    @objc func performNavToCart(){
        
        print("perform")
    }
    
    @objc func performNavToSettings(){
        
        let part2Storyboard = UIStoryboard(name: "Part2", bundle: nil)
        
        let settingsScreen = part2Storyboard.instantiateViewController(withIdentifier: "Settings") as! SettingsViewControllerTableViewController
        
       // present(settingsScreen, animated: true)
        
        navigationController?.navigationBar.tintColor = .black
        self.navigationController?.pushViewController(settingsScreen, animated: true)
        
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
