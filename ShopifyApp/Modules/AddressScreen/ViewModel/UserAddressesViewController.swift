//
//  UserAddressesViewController.swift
//  ShopifyApp
//
//  Created by Naden on 30/05/2024.
//

import UIKit

class UserAddressesViewController: UIViewController  , UITableViewDelegate , UITableViewDataSource  {
  
    

    @IBOutlet weak var userAddressesList: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userAddressesList.delegate = self
        userAddressesList.dataSource = self
        
        let nibAddressCell = UINib(nibName: "CustomAddreesCell", bundle: nil)
        
        userAddressesList.register(nibAddressCell, forCellReuseIdentifier: "addressCell")

    }
    
    @IBAction func addAddress(_ sender: Any) {
        
        let part2Storyboard = UIStoryboard(name: "Part2", bundle: nil)
        
        let addAddressScreen  = part2Storyboard.instantiateViewController(withIdentifier: "add_address") as! AddAddressInfoViewController
        
        present(addAddressScreen, animated: true)
        
    }
    
    @IBAction func backToSetting(_ sender: Any) {
        
        self.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath)
        
        
        
        
        return cell
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
