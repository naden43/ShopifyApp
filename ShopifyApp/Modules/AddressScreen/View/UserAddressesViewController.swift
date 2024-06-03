//
//  UserAddressesViewController.swift
//  ShopifyApp
//
//  Created by Naden on 02/06/2024.
//

import UIKit

class UserAddressesViewController: UIViewController  , UITableViewDelegate , UITableViewDataSource{
    
    

    @IBOutlet weak var userAddressesList: UITableView!
    
    var viewModel : UserAddressesViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = UserAddressesViewModel(network: NetworkHandler.instance)
        
        
        userAddressesList.delegate = self
        userAddressesList.dataSource = self
        
        let nibFile = UINib(nibName: "CustomAddreesCell", bundle: nil)
        
        userAddressesList.register(nibFile, forCellReuseIdentifier: "cell")
        
        viewModel?.bindAddresses = {
            self.userAddressesList.reloadData()
        }

        viewModel?.loadData()
    }
    

    @IBAction func backToSettings(_ sender: Any) {
        
        dismiss(animated: true)
    }
    
    @IBAction func navToAddAddress(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Part2", bundle: nil)
        
        let addAddressScreen = storyboard.instantiateViewController(withIdentifier: "add_address") as! AddAddressInfoViewController
        
        present(addAddressScreen, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getAddresesCount() ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomAddreesCell
        
        let address = viewModel?.getAddressByIndex(index: indexPath.row)
        
        cell.cityTxt.text = (address?.city) ?? ""
        cell.countryTxt.text = (address?.country) ?? ""
        return cell
    }
    
    
}
