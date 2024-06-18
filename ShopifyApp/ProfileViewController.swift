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
    
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "network monitoring")
    
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
        }
        
        monitor.start(queue: queue)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let view = self.navigationController?.visibleViewController
            
            
            view?.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "gearshape") , style: .plain, target: self, action: #selector(performNavToSettings)) , UIBarButtonItem(image: UIImage(systemName: "cart") , style: .plain, target: self, action: #selector(performNavToCart))]
            
            for item in view?.navigationItem.rightBarButtonItems ?? [] {
                item.tintColor = UIColor(.black)
            }
           view?.title = "profile"
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == ordersList ? 0 : 0 // Adjust as per your actual logic
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure and return cells
        return UITableViewCell()
    }
    
    // MARK: - Actions
    
    @IBAction func moreWishProducts(_ sender: Any) {
        // Handle action
    }
    
    @IBAction func moreOrders(_ sender: Any) {
        // Handle action
    }
    
    // MARK: - Navigation
    
    @objc func performNavToCart() {
        
        if viewModel?.checkIfUserAvaliable() == true {
            
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
        
    }
    
    @IBAction func navigateToRegister(_ sender: Any) {
        
    }
    
    deinit {
        monitor.cancel()
    }
}
