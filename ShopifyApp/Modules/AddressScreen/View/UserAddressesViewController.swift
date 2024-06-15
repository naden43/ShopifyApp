//
//  UserAddressesViewController.swift
//  ShopifyApp
//
//  Created by Naden on 02/06/2024.
//

import UIKit

class UserAddressesViewController: UIViewController  , UITableViewDelegate , UITableViewDataSource{
    
    
    @IBOutlet weak var proceedToChecoutButton: UIButton!
    
    @IBOutlet weak var userAddressesList: UITableView!
    
    var fromSettingsFlag = false
    
    var viewModel : UserAddressesViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if fromSettingsFlag == true {
            
            proceedToChecoutButton.isHidden = true
        }
        
        viewModel = UserAddressesViewModel(network: NetworkHandler.instance)
        
        
        userAddressesList.delegate = self
        userAddressesList.dataSource = self
        
        let nibFile = UINib(nibName: "CustomAddreesCell", bundle: nil)
        
        userAddressesList.register(nibFile, forCellReuseIdentifier: "cell")
        
        viewModel?.bindAddresses = {
            self.userAddressesList.reloadData()
        }
        
        viewModel?.faildDeletion = {
            
            let alert = UIAlertController(title: "Delete", message: "You Cannot Delete the defualt Address", preferredStyle: .actionSheet)
            
            self.present(alert, animated: true, completion: nil)
               
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                DispatchQueue.main.async {
                    alert.dismiss(animated: true, completion: nil)
                }
            }
            
        }

        
        viewModel?.setDefaultResult = { message in
            
            let alert = UIAlertController(title: "Set Default Address ", message: message, preferredStyle: .actionSheet)
            
            self.present(alert, animated: true, completion: nil)
               
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                DispatchQueue.main.async {
                    alert.dismiss(animated: true, completion: nil)
                }
            }
            
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel?.loadData()
        userAddressesList.reloadData()

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
        
        cell.contentViewOfCell.layer.borderWidth = 0.0

        if address?.default == true {
            print(address?.city)
            cell.contentViewOfCell.layer.borderWidth = 3.0
            cell.contentViewOfCell.layer.borderColor = UIColor.gray.cgColor
        }
        
        cell.cityTxt.text = (address?.city) ?? ""
        cell.countryTxt.text = (address?.country) ?? ""
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Part2", bundle: nil)
        
        let addAddressScreen = storyboard.instantiateViewController(withIdentifier: "add_address") as! AddAddressInfoViewController
        
        viewModel?.selectedAddress = viewModel?.getAddressByIndex(index: indexPath.row)
        addAddressScreen.allAddressesScreenViewModel = viewModel
        
        present(addAddressScreen, animated: true)
        
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, view, complition in
            
            let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete the Address", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive , handler: { action in
                self.viewModel?.deleteAddress(index: indexPath.row)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            self.present(alert, animated: true)
            
        }
        
        
        let setDefualt = UIContextualAction(style: .normal, title: "Default") { action, view, complition in
        
                self.viewModel?.setAsDefaultAddress(index: indexPath.row)
        }
        
        
        
    
        
        let configration = UISwipeActionsConfiguration(actions: [deleteAction , setDefualt])
        
        return configration
        
    }
    
    
    @IBAction func proceedToChecoutAction(_ sender: Any) {
        
        let part2Storyboard = UIStoryboard(name: "Part2", bundle: nil)
        
        let paymentOptionsScreen = part2Storyboard.instantiateViewController(withIdentifier: "payment_screen") as! PaymentOptionsViewController
        
        
        present(paymentOptionsScreen, animated: true)
    }
    
}
