//
//  AboutUsViewController.swift
//  ShopifyApp
//
//  Created by Naden on 19/06/2024.
//

import UIKit

class AboutUsViewController: UIViewController {
    @IBOutlet weak var image2: UIImageView!
    
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image1: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        image1.layer.cornerRadius = image1.frame.width/2
        image2.layer.cornerRadius = image2.frame.width/2
        image3.layer.cornerRadius = image3.frame.width/2


    }
    
    @IBAction func backButton(_ sender: Any) {
        
        dismiss(animated: true)
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
