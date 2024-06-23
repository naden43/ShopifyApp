//
//  FavProductsViewController.swift
//  ShopifyApp
//
//  Created by Salma on 14/06/2024.
//
/*
import UIKit
import Kingfisher

class FavProductsViewController: UIViewController {

    @IBOutlet weak var favProductsTableView: UITableView!
    var viewModel: FavouriteProductsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        favProductsTableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
        
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
    }
}

extension FavProductsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getProductsCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as? ProductTableViewCell else {
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
            let alert = UIAlertController(title: "Confirm Deletion", message: "Are you sure you want to delete this product from your favorites?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                self.viewModel?.deleteFavProductFromFavDraftOrder(index: indexPath.row) { success in
                    if success {
                        DispatchQueue.main.async {
                            tableView.deleteRows(at: [indexPath], with: .automatic)
                        }
                    } else {
                    }
                }
            }))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let lineItem = viewModel?.favProducts?.lineItems?[indexPath.row + 1],
              let productId = lineItem.productId else {
            return
        }
        
        viewModel?.getProductById(productId: Int(productId)) { product in
            guard let productResponse = product else {
                return
            }
            
            let productDetailsViewModel = ProductDetailsViewModel(selectedProduct: productResponse.product)
            
            let storyboard = UIStoryboard(name: "Part3", bundle: nil)
            if let productDetailsVC = storyboard.instantiateViewController(withIdentifier: "productDetailsScreen") as? ProductDetailsViewController {
                productDetailsVC.viewModel = productDetailsViewModel
                productDetailsVC.favViewModel = self.viewModel
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(productDetailsVC, animated: true)
                }
            }
        }
    }
}
*/

import UIKit
import Kingfisher

class FavProductsViewController: UIViewController {

    @IBOutlet weak var favProductsTableView: UITableView!
    var viewModel: FavouriteProductsViewModel?
    var remainingFavorites: [LineItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        favProductsTableView.register(UINib(nibName: "OrdersTableViewCell", bundle: nil), forCellReuseIdentifier: "favProductCell")
        
        viewModel = FavouriteProductsViewModel()
        
        favProductsTableView.dataSource = self
        favProductsTableView.delegate = self

        setupTableViewConstraints()
        
        viewModel?.loadData {
            DispatchQueue.main.async {
                self.remainingFavorites = self.viewModel?.getTheRemainingOfFavourites() ?? []
                self.favProductsTableView.reloadData()
            }
        }
    }
    
    private func setupTableViewConstraints() {
        favProductsTableView.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension FavProductsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return remainingFavorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as? ProductTableViewCell else {
            return UITableViewCell()
        }
        
        let product = remainingFavorites[indexPath.row]
        
        cell.productTitle.text = product.title
        cell.productPrice.text = product.price
        
        if let imageUrlString = product.properties?.first?["value"],
           let imageUrl = URL(string: imageUrlString) {
            cell.favProductImageView.kf.setImage(with: imageUrl)
        } else {
            cell.favProductImageView.image = nil
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Confirm Deletion", message: "Are you sure you want to delete this product from your favorites?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                self.viewModel?.deleteFavProductFromFavDraftOrder(index: indexPath.row) { success in
                    if success {
                        DispatchQueue.main.async {
                            self.remainingFavorites.remove(at: indexPath.row)
                            tableView.deleteRows(at: [indexPath], with: .automatic)
                        }
                    }
                }
            }))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let productId = remainingFavorites[indexPath.row].productId else {
            return
        }
        
        viewModel?.getProductById(productId: Int(productId)) { product in
            guard let productResponse = product else {
                return
            }
            
            let productDetailsViewModel = ProductDetailsViewModel(selectedProduct: productResponse.product)
            
            let storyboard = UIStoryboard(name: "Part3", bundle: nil)
            if let productDetailsVC = storyboard.instantiateViewController(withIdentifier: "productDetailsScreen") as? ProductDetailsViewController {
                productDetailsVC.viewModel = productDetailsViewModel
                productDetailsVC.favViewModel = self.viewModel
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(productDetailsVC, animated: true)
                }
            }
        }
    }
}


