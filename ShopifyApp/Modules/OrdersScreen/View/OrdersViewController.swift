//
//  OrdersViewController.swift
//  ShopifyApp
//
//  Created by Aya Mostafa on 19/06/2024.
//

import UIKit

class OrdersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var ordersTable: UITableView!
    var viewModel:ProfileViewModel?
    let url = Constants.EndPoint.orders
    override func viewDidLoad() {
        super.viewDidLoad()
        ordersTable.delegate = self
        ordersTable.dataSource = self
        viewModel = ProfileViewModel()
        ordersTable.register(UINib(nibName: "OrderTableViewCell", bundle: nil), forCellReuseIdentifier: "orderCell")
        
        
        viewModel?.bindToOdersViewController = { [weak self] in
            print("inside the bind closure")
            DispatchQueue.main.async {
                self?.ordersTable.reloadData()
                print("the number of orders = \(self?.viewModel?.getOrders().count ?? 0)")
            }
        }
        
        viewModel?.fetchOrders(url: url)
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.getOrders().count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Return the desired height for each cell
        return 136 // Adjust this value to set the height you want
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let orderCell = ordersTable.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as! OrderTableViewCell
        if let orders = viewModel?.getOrders() {
                   let order = orders[indexPath.row]

                   orderCell.orderNumber.text = order.confirmationNumber
                   orderCell.productsNumber.text = "\(order.lineItems?.count ?? 0)"
            orderCell.totalAmount.text = order.totalLineItemsPrice
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
               }
        return orderCell
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
