//
//  FavProductsViewController.swift
//  ShopifyApp
//
//  Created by Salma on 14/06/2024.
//

import UIKit
import Kingfisher

class FavProductsViewController: UIViewController {

    @IBOutlet weak var favProductsTableView: UITableView!
    var viewModel: FavouriteProductsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        favProductsTableView.register(UINib(nibName: "OrdersTableViewCell", bundle: nil), forCellReuseIdentifier: "favProductCell")
        
        viewModel = FavouriteProductsViewModel()
        
        favProductsTableView.dataSource = self
        favProductsTableView.delegate = self
        

        setupTableViewConstraints()
        
        viewModel?.loadData {
            DispatchQueue.main.async {
                self.favProductsTableView.reloadData()
            }
        }
    }
    
    private func setupTableViewConstraints() {
        favProductsTableView.translatesAutoresizingMaskIntoConstraints = false
        
//        NSLayoutConstraint.activate([
//            favProductsTableView.topAnchor.constraint(equalTo: view.topAnchor),
//            favProductsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            favProductsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
//            favProductsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
//        ])
    }
}

extension FavProductsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("table view size \(viewModel?.getProductsCount())")
        return viewModel?.getProductsCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "favProductCell", for: indexPath) as? FavouriteProductsTableViewCell else {
            return UITableViewCell()
        }
        
        if let viewModel = viewModel {
            let product = viewModel.favProducts?.lineItems?[indexPath.row + 1]
            
            cell.productTitle.text = product?.title
//            cell.productBrand.text = product?.vendor
            cell.productPrice.text = product?.price
            
            if let imageUrlString = viewModel.getImageByIndex(index: indexPath.row),
               let imageUrl = URL(string: imageUrlString) {
                cell.favProductImageView.kf.setImage(with: imageUrl)
            } else {
                cell.favProductImageView.image = nil
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel?.deleteFavProductFromFavDraftOrder(index: indexPath.row) { success in
                if success {
                    DispatchQueue.main.async {
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                    }
                } else {
                  
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle row selection if needed
    }
}


