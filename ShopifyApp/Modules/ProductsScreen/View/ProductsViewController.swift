//
//  ProductsViewController.swift
//  ShopifyApp
//
//  Created by Aya Mostafa on 02/06/2024.
//

import UIKit

class ProductsViewController: UIViewController {
    @IBOutlet weak var productCollection: UICollectionView!
    var brandId : Int?
    var brandName : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        print("The Brand id = \(self.brandId ?? 301445349542)")
        // Do any additional setup after loading the view.
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
