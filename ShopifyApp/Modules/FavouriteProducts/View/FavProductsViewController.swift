//
//  FavProductsViewController.swift
//  ShopifyApp
//
//  Created by Salma on 14/06/2024.
//

import UIKit

class FavProductsViewController: UIViewController {

    @IBOutlet weak var favProductsTableView: UITableView!
    var viewModel : FavouriteProductsViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = FavouriteProductsViewModel()
        viewModel?.loadData()
    }
    


}
