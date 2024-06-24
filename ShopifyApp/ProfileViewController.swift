//
//  ProfileViewController.swift
//  ShopifyApp
//
//  Created by Naden on 31/05/2024.
//

import UIKit
import Network
import Reachability

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, OrderTableViewCellDelegate {
    
    //let monitor = NWPathMonitor()
    //let queue = DispatchQueue(label: "network monitoring")
    @IBOutlet weak var customerNameTxt: UILabel!
    
    @IBOutlet weak var moreOrders: UIButton!
    @IBOutlet weak var userModeView: UIView!
    @IBOutlet weak var noInternetMode: UIView!
    @IBOutlet weak var guestModeView: UIView!
    
    @IBOutlet weak var wishList: UITableView!
    @IBOutlet weak var ordersList: UITableView!
    
    var viewModel: ProfileViewModel?
    let url = Constants.EndPoint.orders
    let reachability = try! Reachability()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ordersList.delegate = self
        wishList.delegate = self
        ordersList.dataSource = self
        wishList.dataSource = self
        
        viewModel = ProfileViewModel()
        
        viewModel?.bindCustomerName = { [weak self] name in
            
            self?.customerNameTxt.text = name
        }
        
        wishList.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
        
       ordersList.register(UINib(nibName: "OrderTableViewCell", bundle: nil), forCellReuseIdentifier: "orderCell")
        
        
        /*monitor.pathUpdateHandler = { [weak self] path in
        
//
        
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                print("enter here ")
                if path.status == .satisfied {
                    print("Network is available")
                    
                    if self?.viewModel?.checkIfUserAvaliable() == true {
                        self?.noInternetMode.isHidden = true
                        self?.userModeView.isHidden = false
                        self?.guestModeView.isHidden = true
                    } else {
                        self?.noInternetMode.isHidden = true
                        self?.userModeView.isHidden = true
                        self?.guestModeView.isHidden = false
                    }
                } else  {
                    print(path.status)
                    self?.noInternetMode.isHidden = false
                    self?.userModeView.isHidden = true
                    self?.guestModeView.isHidden = true
                }
            }
        }*/
        
        
        //wishList.rowHeight = UITableView.automaticDimension
        //wishList.estimatedRowHeight = 150
        
        viewModel?.bindFavourites = {
            self.wishList.reloadData()
        }
        
        viewModel?.bindToOdersViewController = { [weak self] in
            print("inside the bind closure")
            DispatchQueue.main.async {
                self?.ordersList.reloadData()
                print("the number of orders = \(self?.viewModel?.getOrders().count ?? 0)")
            }
        }
        viewModel?.fetchOrders(url: url)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print(UserDefaultsManager.shared.getCustomer())
        if self.viewModel?.checkIfUserAvaliable() == true {
            
            viewModel?.fetchCustomer()
            viewModel?.fetchFavourites()
            self.noInternetMode.isHidden = true
            self.userModeView.isHidden = false
            self.guestModeView.isHidden = true
        } else {
            self.noInternetMode.isHidden = true
            self.userModeView.isHidden = true
            self.guestModeView.isHidden = false
        }

        
        
        let view = self.navigationController?.visibleViewController
            
            
            view?.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "gearshape") , style: .plain, target: self, action: #selector(performNavToSettings)) , UIBarButtonItem(image: UIImage(systemName: "cart") , style: .plain, target: self, action: #selector(performNavToCart))]
            
            for item in view?.navigationItem.rightBarButtonItems ?? [] {
                item.tintColor = UIColor(.black)
            }
        view?.navigationItem.leftBarButtonItems = []
           view?.title = "profile"
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == wishList {
                return viewModel?.getFavCount() ?? 0
            } else if tableView == ordersList {
                let totalOrders = viewModel?.getOrders().count ?? 0
                return min(totalOrders, 4) // Return up to 4 items, or all items if less than 4
            } else {
                return 0
            }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == wishList {
            return 114
        }
        else {
            return 114
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        if tableView == wishList {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as? ProductTableViewCell else {
                        return UITableViewCell()
                    }
                    
                    let product = viewModel?.getFavProductByIndex(index: indexPath.row)
                    
                    cell.productTitle.text = product?.title
                    // cell.productBrand.text = product?.vendor // Uncomment if needed
            let price = viewModel?.convertPriceByCurrency(price: Double(product?.price ?? "0.0") ?? 0.0)
                    cell.productPrice.text = price
            cell.priceCurrency.text = viewModel?.getCurrencyType()
                    
                    if let imageUrlString = viewModel?.getImageByIndex(index: indexPath.row),
                       let imageUrl = URL(string: imageUrlString) {
                        print("here")
                        cell.favProductImageView.kf.setImage(with: imageUrl)
                    } else {
                        cell.favProductImageView.image = nil
                    }
                    
                    // Add border to the cell
                  
            return cell
            
        }else if tableView == ordersList {
            let orderCell = ordersList.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as! OrderTableViewCell
                   if let orders = viewModel?.getOrders() {
                       let order = orders[indexPath.row]

                       let price = viewModel?.convertPriceByCurrency(price: Double(order.totalLineItemsPrice ?? "0.0") ?? 0.0)

                       orderCell.orderNumber.text = order.confirmationNumber
                       orderCell.productsNumber.text = "\(order.lineItems?.count ?? 0)"
                       orderCell.totalAmount.text = price
                       
                       

                       // Configure date formatting
                       if let createdAtString = order.createdAt {
                           let dateFormatter = DateFormatter()
                           dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                           if let date = dateFormatter.date(from: createdAtString) {
                               let displayFormatter = DateFormatter()
                               displayFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                               orderCell.orderDate.text = displayFormatter.string(from: date)
                           } else {
                               orderCell.orderDate.text = "N/A"
                           }
                       } else {
                           orderCell.orderDate.text = "N/A"
                       }

                       orderCell.delegate = self
                   }
                   return orderCell
        }
        else {
            
            return UITableViewCell()
        }
        
    }
    
    // MARK: - Actions
    
    @IBAction func moreWishProducts(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Part3", bundle: nil)
        if let favScreen = storyboard.instantiateViewController(withIdentifier: "favProductsScreen") as? FavProductsViewController {
             navigationController?.pushViewController(favScreen, animated: true)
         }
    }
    
    @IBAction func moreOrders(_ sender: Any) {
        print("perform")
        // Handle action

       let storyboard = UIStoryboard(name: "Part1", bundle: nil)
       if let ordersVC = storyboard.instantiateViewController(withIdentifier: "ordersScreen") as? OrdersViewController {
            navigationController?.pushViewController(ordersVC, animated: true)
        }
        
        print("pressss orderrrrr moreeeee")
    }
    
    // MARK: - Navigation
    
    @objc func performNavToCart() {
        
        if viewModel?.checkIfUserAvaliable() == true {
            let reachability = try! Reachability()

            switch reachability.connection {
                
                case .unavailable:
                    let alert = UIAlertController(title: "network", message: "You are not connected to the network check you internet  ", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                
                    present(alert, animated: true)
                
                case .wifi , .cellular:
                    let shopingScreen = UIStoryboard(name: "Part2", bundle: nil).instantiateViewController(withIdentifier: "shoping-cart") as! ShoppingCartViewController
                    navigationController?.pushViewController(shopingScreen, animated: true)
                
            }
            
        }
        else {
            
            let alert = UIAlertController(title: "Guest", message: "You are not a user please login or reguster first ", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            
            present(alert, animated: true)
        }
        
        
       
    }
    
    @objc func performNavToSettings() {
       
        if viewModel?.checkIfUserAvaliable() == true {
            let reachability = try! Reachability()

            switch reachability.connection {
                
                case .unavailable:
                    let alert = UIAlertController(title: "network", message: "You are not connected to the network check you internet  ", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                
                    present(alert, animated: true)
                
                case .wifi , .cellular:
                    let settingsScreen = UIStoryboard(name: "Part2", bundle: nil).instantiateViewController(withIdentifier: "Settings") as! SettingsViewControllerTableViewController
                    navigationController?.pushViewController(settingsScreen, animated: true)
                
            }
            
        }
        else {
            
            let alert = UIAlertController(title: "Guest", message: "You are not a user please login or reguster first ", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            
            present(alert, animated: true)
        }
        
    }
    
    func didTapDetailsButton(on cell: OrderTableViewCell) {
        print("the details button clicked !!!!")
        guard let indexPath = ordersList.indexPath(for: cell) else { return }
        let order = viewModel?.getOrders()[indexPath.row]
        
        let backItem = UIBarButtonItem()
        self.navigationItem.backBarButtonItem = backItem
        self.navigationItem.title = "Order Details"
        self.navigationItem.backBarButtonItem?.tintColor = .black
                
        let storyboard = UIStoryboard(name: "Part1", bundle: nil)
        if let orderDetailsVC = storyboard.instantiateViewController(withIdentifier: "orderdetails") as? OrderDetailsViewController {
            orderDetailsVC.selectedOrder = order
            navigationController?.pushViewController(orderDetailsVC, animated: true)
        }
    }
    
    @IBAction func navigateToLogin(_ sender: Any) {
        let part3Storyboard = UIStoryboard(name: "Part3", bundle: nil)
        
        let loginScreen = part3Storyboard.instantiateViewController(withIdentifier: "loginScreen")
    
        present(loginScreen, animated: true)
        
        
    }
    
    @IBAction func navigateToRegister(_ sender: Any) {
        
        let part3Storyboard = UIStoryboard(name: "Part3", bundle: nil)
        
        let signUpScreen = part3Storyboard.instantiateViewController(withIdentifier: "signUp_screen")
    
        present(signUpScreen, animated: true)
    }
    
    deinit {
        //monitor.cancel()
    }
}
