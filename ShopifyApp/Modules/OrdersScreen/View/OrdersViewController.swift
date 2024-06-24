//
//  OrdersViewController.swift
//  ShopifyApp
//
//  Created by Aya Mostafa on 19/06/2024.
//

import UIKit

class OrdersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, OrderTableViewCellDelegate {

    
    @IBOutlet weak var noOrdertxt: UILabel!
    @IBOutlet weak var emptyOrderImg: UIImageView!
    @IBOutlet weak var ordersTable: UITableView!
    var viewModel:ProfileViewModel?
    let url = Constants.EndPoint.orders
    let activityIndicator = UIActivityIndicatorView(style: .large)
    override func viewDidLoad() {
        super.viewDidLoad()
        ordersTable.delegate = self
        ordersTable.dataSource = self

        viewModel = ProfileViewModel()
        ordersTable.register(UINib(nibName: "OrderTableViewCell", bundle: nil), forCellReuseIdentifier: "orderCell")
        
        
        viewModel?.bindToOdersViewController = { [weak self] in
            print("inside the bind closure")
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.ordersTable.reloadData()
                self?.updateEmptyOrderView()
                print("the number of orders = \(self?.viewModel?.getOrders().count ?? 0)")
            }
        }
        
        viewModel?.fetchOrders(url: url)
        self.activityIndicator.center = self.view.center
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleNavigationBar()
        updateEmptyOrderView()
    }
    
    
    func handleNavigationBar() {
        guard let view = self.navigationController?.visibleViewController else {
            return
        }
        view.title = " "
    }
    
    func updateEmptyOrderView() {
        let hasOrders = !(viewModel?.getOrders().isEmpty ?? true)
        noOrdertxt.isHidden = hasOrders
        emptyOrderImg.isHidden = hasOrders
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.getOrders().count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Return the desired height for each cell
        return 114
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let orderCell = ordersTable.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as! OrderTableViewCell
        if let orders = viewModel?.getOrders() {
            let order = orders[indexPath.row]

                   orderCell.orderNumber.text = order.confirmationNumber
                   orderCell.productsNumber.text = "\((order.lineItems?.count ?? 0) - 1)"
            let price = viewModel?.convertPriceByCurrency(price: Double(order.totalLineItemsPrice ?? "0.0") ?? 0.0)
            orderCell.totalAmount.text = price
            orderCell.currencyTxt.text = viewModel?.getCurrencyType()
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
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
           cell.contentView.layer.cornerRadius = 30
           cell.contentView.layer.masksToBounds = true
           
           cell.layer.shadowColor = UIColor.orange.cgColor
           cell.layer.shadowOffset = CGSize(width: 0, height: 2)
           cell.layer.shadowRadius = 4
           cell.layer.shadowOpacity = 0.2
           cell.layer.masksToBounds = false
    }
    
    func didTapDetailsButton(on cell: OrderTableViewCell) {
        print("the details button clicked !!!!")
        guard let indexPath = ordersTable.indexPath(for: cell) else { return }
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
