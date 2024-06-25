//
//  FavProductsViewController.swift
//  ShopifyApp
//
//  Created by Salma on 14/06/2024.
//

/*import UIKit
import Kingfisher
import Reachability

class FavProductsViewController: UIViewController {

    @IBOutlet weak var replacedImage: UITableView!
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

//
//  FavProductsViewController.swift
//  ShopifyApp
//
//  Created by Salma on 14/06/2024.
//

import UIKit
import Kingfisher
import Reachability

class FavProductsViewController: UIViewController {

    @IBOutlet weak var favProductsTableView: UITableView!
    @IBOutlet weak var replacedImage: UIImageView!
  
    
    var viewModel: FavouriteProductsViewModel?
    let reachability = try! Reachability()
    let loadingIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupTableViewConstraints()
        
        favProductsTableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
        
        viewModel = FavouriteProductsViewModel()
        
        favProductsTableView.dataSource = self
        favProductsTableView.delegate = self
        
        startLoadingIndicator()
        
        reachability.whenReachable = { _ in
            self.loadData()
        }
        
        reachability.whenUnreachable = { _ in
            self.showNoConnectionImage()
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
        setupNavigationBar()
    }
    
    private func setupViews() {
        replacedImage.image = UIImage(named: "noWifi")
        replacedImage.isHidden = true
        
        replacedImage.image = UIImage(named: "noFavourite")
        replacedImage.isHidden = true
        
        loadingIndicator.center = view.center
        view.addSubview(loadingIndicator)
    }
    
    private func setupTableViewConstraints() {
        favProductsTableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func startLoadingIndicator() {
        loadingIndicator.startAnimating()
        favProductsTableView.isHidden = true
        replacedImage.isHidden = true
        replacedImage.isHidden = true
    }
    
    private func stopLoadingIndicator() {
        loadingIndicator.stopAnimating()
        favProductsTableView.isHidden = false
    }
    
    private func showNoConnectionImage() {
        stopLoadingIndicator()
        replacedImage.isHidden = false
        favProductsTableView.isHidden = true
    }
    
    private func showNoFavouritesImage() {
        stopLoadingIndicator()
        replacedImage.isHidden = false
        favProductsTableView.isHidden = true
    }
    
    private func loadData() {
        viewModel?.loadData {
            DispatchQueue.main.async {
                self.stopLoadingIndicator()
                if self.viewModel?.getProductsCount() == 0 {
                    self.showNoFavouritesImage()
                } else {
                    self.favProductsTableView.reloadData()
                }
            }
        }
    }
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.title = ""
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
            /*cell.productSize.text = viewModel.convertPriceByCurrency(price: Double(product?.price ?? "0.0") ?? 0.0)
            cell.priceCurrency.text = viewModel.getCurrencyType()
            cell.productColor.isHidden = true
            cell.colorText.text = ""
            cell.sizeText.text = "Price:"
            cell.sizeText.textColor = UIColor.lightGray
            if let imageUrlString = viewModel.getImageByIndex(index: indexPath.row),
               let imageUrl = URL(string: imageUrlString) {
                cell.favProductImageView.kf.setImage(with: imageUrl)
            } else {
                cell.favProductImageView.image = nil
            }*/
            
            
            let price = viewModel.convertPriceByCurrency(price: Double(product?.price ?? "0.0") ?? 0.0)
                    cell.productPrice.text = price
            cell.priceCurrency.text = viewModel.getCurrencyType()
                    
                    if let imageUrlString = viewModel.getImageByIndex(index: indexPath.row),
                       let imageUrl = URL(string: imageUrlString) {
                        print("here")
                        cell.favProductImageView.kf.setImage(with: imageUrl)
                    } else {
                        cell.favProductImageView.image = nil
                    }
                    
            cell.productColor.isHidden = true
            cell.colorText.isHidden = true
            cell.productSize.isHidden = true
            cell.sizeText.isHidden = true
            
            
            
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
                            if self.viewModel?.getProductsCount() == 0 {
                                self.showNoFavouritesImage()
                            }
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


