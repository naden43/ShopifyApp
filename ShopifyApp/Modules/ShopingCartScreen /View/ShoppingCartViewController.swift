//
//  ShoppingCartViewController.swift
//  ShopifyApp
//
//  Created by Naden on 30/05/2024.
//

import UIKit
import Kingfisher
import Reachability

class ShoppingCartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var emptyShoppingCart: UIImageView!
    
    @IBOutlet weak var proceedToCheckOutButton: UIButton!
    @IBOutlet weak var totalTxt: UILabel!
    @IBOutlet weak var shopingCartList: UITableView!
    var favViewModel: FavouriteProductsViewModel?
    var homeViewModel: HomeViewModelProtocol?

    var viewModel: ShopingCartViewModel?
    var currency: String?
    
    let activityIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        shopingCartList.delegate = self
        shopingCartList.dataSource = self
        
        viewModel = ShopingCartViewModel(network: NetworkHandler.instance)
        homeViewModel = HomeViewModel()
        
        currency = viewModel?.getCurrencyType()
        
        viewModel?.bindData = { [weak self] in
            self?.activityIndicator.stopAnimating()

            
            if self?.viewModel?.getProductsCount() == 0 {
                
                self?.totalTxt.text = "0.0 \(self?.currency ?? "")"
                
                self?.emptyShoppingCart.image = UIImage(named: "emptyShoppingCart")
            }
            else {
                let apiPrice = Double(self?.viewModel?.getTotalPrice() ?? "0.0") ?? 0.0
                let price = self?.viewModel?.calcThePrice(price: apiPrice) ?? "0.0"
                self?.totalTxt.text = "\(price) \(self?.currency ?? "")"
                
                self?.emptyShoppingCart.image = nil

            }
            self?.shopingCartList.reloadData()
        }
        
        let nibCell = UINib(nibName: "CustomShoppingCartCellTableViewCell", bundle: nil)
        shopingCartList.register(nibCell, forCellReuseIdentifier: "shopingCarCell")
        
        self.activityIndicator.center = self.view.center
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
        
        viewModel?.loadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getProductsCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shopingCarCell", for: indexPath) as! CustomShoppingCartCellTableViewCell
        let data = viewModel?.getProductByIndex(index: indexPath.row)
        
        cell.productName.text = data?.title
        cell.productDescription.text = data?.vendor
        cell.itemCount.text = String(data?.quantity ?? 0)
        
        let apiPrice = Double(data?.price ?? "0.0") ?? 0.0
        let price = viewModel?.calcThePrice(price: apiPrice) ?? "0.0"
        cell.productPrice.text = "\(price) \(currency ?? "")"
        
        print(viewModel?.produtsAmount)
        
        cell.plusAction = {
            
            let reachability = try! Reachability()
            
            switch reachability.connection {
                
                case .wifi , .cellular :
                
                    if ((data?.quantity ?? 0) + 1) > self.viewModel?.allowedProductAmount(varientId: Int(data?.variantId ?? 0)) ?? 0 {
                        let alert = UIAlertController(title: "Exceed Amount", message: "You cannot increase the amount.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
                        self.present(alert, animated: true)
                    } else {
                        cell.itemCount.text = String((Int(cell.itemCount.text ?? "0") ?? 0) + 1)
                    
                        self.activityIndicator.center = self.view.center
                        self.view.addSubview(self.activityIndicator)
                        self.activityIndicator.startAnimating()

                    
                        self.viewModel?.increaseTheQuantityOfProduct(index: indexPath.row)
                    }
                
                
                case .unavailable :
                    let alert = UIAlertController(title: nil ,  message: "Check your network first !", preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                
            
            }
            
        }
        
        cell.minusAction = {
            
            let reachability = try! Reachability()
            
            switch reachability.connection {
                
            case .wifi , .cellular :
                
                if ((Int(cell.itemCount.text ?? "0") ?? 0) - 1) == 0 {
                    let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete this product?", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
                        
                        self.activityIndicator.center = self.view.center
                        self.view.addSubview(self.activityIndicator)
                        self.activityIndicator.startAnimating()
                        
                        let variantId = self.viewModel?.getProductByIndex(index: indexPath.row).variantId
                        self.viewModel?.deleteTheProductAmount(varientId: Int(variantId ?? 0))
                        self.viewModel?.deleteTheProductFromShopingCart(index: indexPath.row)
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                    self.present(alert, animated: true)
                } else {
                    cell.itemCount.text = String((Int(cell.itemCount.text ?? "0") ?? 0) - 1)
                    
                    self.activityIndicator.center = self.view.center
                    self.view.addSubview(self.activityIndicator)
                    self.activityIndicator.startAnimating()
                    
                    self.viewModel?.decrementTheQuantityOfProduct(index: indexPath.row)
                }
                
            case .unavailable :
                let alert = UIAlertController(title: nil ,  message: "Check your network first !", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
        }
        
        let url = URL(string: viewModel?.getImageByIndex(index: indexPath.row) ?? "")
        if viewModel?.productAmountAvaliable(index: indexPath.row) == false {
            cell.productImage.image = UIImage(named: "Sold_out")
        } else {
            cell.productImage.kf.setImage(with: url)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let reachability = try! Reachability()
            
            switch reachability.connection {
                
            case .wifi , .cellular :
                
                let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete this product?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
                    
                    self.activityIndicator.center = self.view.center
                    self.view.addSubview(self.activityIndicator)
                    self.activityIndicator.startAnimating()
                    
                    let variantId = self.viewModel?.getProductByIndex(index: indexPath.row).variantId
                    self.viewModel?.deleteTheProductAmount(varientId: Int(variantId ?? 0))
                    self.viewModel?.deleteTheProductFromShopingCart(index: indexPath.row)
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                self.present(alert, animated: true)
                
            case .unavailable :
                let alert = UIAlertController(title: nil ,  message: "Check your network first !", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
                
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let lineItem = viewModel?.getProductByIndex(index: indexPath.row),
              let productId = lineItem.productId else {
            return
        }
        
        viewModel?.getProductById(productId: Int(productId)) { productResponse in
            guard let product = productResponse?.product else {
                // Handle error (e.g., show an error message to the user)
                return
            }
            
            let productDetailsViewModel = ProductDetailsViewModel(selectedProduct: product)
            let storyboard = UIStoryboard(name: "Part3", bundle: nil)
            if let productDetailsVC = storyboard.instantiateViewController(withIdentifier: "productDetailsScreen") as? ProductDetailsViewController {
                productDetailsVC.viewModel = productDetailsViewModel
                productDetailsVC.favViewModel = self.homeViewModel?.getFavViewModel()
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(productDetailsVC, animated: true)
                }
            }
        }
    }
    
    @IBAction func navToCheckOut(_ sender: Any) {
        
        let reachability = try! Reachability()
        
        switch reachability.connection {
            
        case .wifi , .cellular :
            if viewModel?.avaliableToCheckOut() == true {
                
                if viewModel?.getProductsCount() == 0 {
                    
                    let alert = UIAlertController(title: nil, message: "Empty Shoppig cart", preferredStyle: .actionSheet)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                    present(alert, animated: true)
                }
                else {
                    let part2Storyboard = UIStoryboard(name: "Part2", bundle: nil)
                    let userAddressScreen = part2Storyboard.instantiateViewController(withIdentifier: "user_addresses") as! UserAddressesViewController
                    present(userAddressScreen, animated: true)
                }
            } else {
                let alert = UIAlertController(title: "Error", message: "The product may be sold out or you have exceeded the allowed amount. Swipe to remove or decrement your amount.", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
                present(alert, animated: true)
            }
            
            
        case .unavailable:
            let alert = UIAlertController(title: nil ,  message: "Check your network first !", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
}
