//
//  ProfileViewController.swift
//  ShopifyApp
//
//  Created by Naden on 31/05/2024.
//

import UIKit
import Network
import Reachability

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
        
        wishList.register(UINib(nibName: "OrdersTableViewCell", bundle: nil), forCellReuseIdentifier: "favProductCell")
        
       // ordersList.register(UINib(nibName: "OrdersTableViewCell", bundle: nil), forCellReuseIdentifier: "orderCell")
        
        
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
            
        }
        else {
            return  0
        }
    }
    
    /*func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == wishList {
            return 150
        }
        else {
            return 150
        }
    }*/
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        if tableView == wishList {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "favProductCell", for: indexPath) as? FavouriteProductsTableViewCell else {
                        return UITableViewCell()
                    }
                    
                    let product = viewModel?.getFavProductByIndex(index: indexPath.row)
                    
                    cell.productTitle.text = product?.title
                    // cell.productBrand.text = product?.vendor // Uncomment if needed
                    cell.productPrice.text = product?.price
                    
                    if let imageUrlString = viewModel?.getImageByIndex(index: indexPath.row),
                       let imageUrl = URL(string: imageUrlString) {
                        print("here")
                        cell.favProductImageView.kf.setImage(with: imageUrl)
                    } else {
                        cell.favProductImageView.image = nil
                    }
                    
                    // Add border to the cell
                    cell.layer.borderWidth = 1.0
                    cell.layer.borderColor = UIColor.lightGray.cgColor
            return cell
            
        }
        else {
            
            return UITableViewCell()
        }
        
        
        
        // Configure and return cells
//        let orderCell = ordersList.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as! OrdersTableViewCell
//        if let orders = viewModel?.getOrders() {
//                    let order = orders[indexPath.row]
//                    print("The number of orders = \(orders.count)")
//
//
//                    orderCell.orderNumber.text = order.confirmationNumber
//
//
//                    orderCell.productsNumber.text = "\(order.lineItems?.count ?? 0)"
//
//                    if let date = order.createdAt {
//                        let dateFormatter = DateFormatter()
//                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                        orderCell.orderDate.text = dateFormatter.string(from: date)
//                    } else {
//                        orderCell.orderDate.text = "N/A"
//                    }
//                }
//        return orderCell
          
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
