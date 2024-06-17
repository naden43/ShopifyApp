//
//  SettingsViewControllerTableViewController.swift
//  ShopifyApp
//
//  Created by Naden on 30/05/2024.
//

import UIKit

class SettingsViewControllerTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            navigateToAddressesScreen()
        }
        else if indexPath.row == 1{
            navigateToCurrencyScreen()
        }
    }
    
    func navigateToAddressesScreen(){
        
        let part2Storyboard = UIStoryboard(name: "Part2", bundle: nil)
        
        let userAddressScreen = part2Storyboard.instantiateViewController(withIdentifier: "user_addresses") as! UserAddressesViewController
        
        userAddressScreen.fromSettingsFlag = true 
        
        present(userAddressScreen, animated: true)
        
    }
   
    func navigateToCurrencyScreen(){
        
        let part2Storyboard = UIStoryboard(name: "Part2", bundle: nil)
        
        let currencyScreen = part2Storyboard.instantiateViewController(withIdentifier: "currency_screen") as! ChooseCurrencyViewController
        
        present(currencyScreen, animated: true)
        
        
    }

}
