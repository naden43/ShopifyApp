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
        
        var view = self.navigationController?.visibleViewController
        view?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape") , style: .plain, target: self, action: #selector(performNav))
        view?.navigationItem.rightBarButtonItems?[0].tintColor = UIColor(.black)
        view?.title = "profile"
    }
    
    @objc func performNav(){
        
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
