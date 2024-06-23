//
//  OrderDetailsViewController.swift
//  ShopifyApp
//
//  Created by Aya Mostafa on 20/06/2024.
//

import UIKit

class OrderDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var priceCurrency: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var discount: UILabel!
    @IBOutlet weak var orderAddress: UILabel!
    @IBOutlet weak var itemsList: UITableView!
    @IBOutlet weak var numberOfItems: UILabel!
    @IBOutlet weak var orderDate: UILabel!
    @IBOutlet weak var orderNumber: UILabel!

    var selectedOrder : Order?
    override func viewDidLoad() {
        super.viewDidLoad()
        itemsList.delegate = self
        itemsList.dataSource = self

        guard let order = selectedOrder else {
            return
        }
        var discountRate = order.totalDiscounts
        var discountPromoCode = order.discountApplications?.description
        itemsList.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
        print("the address in ordersss  = \((order.customer?.defaultAddress?.address1)!) ")
                   self.orderNumber.text = order.confirmationNumber
                   self.totalAmount.text = order.totalLineItemsPrice
                         if let createdAtString = order.createdAt {
                             let dateFormatter = DateFormatter()
                             dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                              if let date = dateFormatter.date(from: createdAtString) {
                                  let displayFormatter = DateFormatter()
                                  displayFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                  self.orderDate.text = displayFormatter.string(from: date)
                              } else {
                                  self.orderDate.text = "N/A"
                              }
                          } else {
                              self.orderDate.text = "N/A"
                          }
                   self.numberOfItems.text = "\(order.lineItems?.count ?? 0)"
                   self.orderAddress.text = ("\((order.customer?.defaultAddress?.address1)!),\((order.customer?.defaultAddress?.city)!), \( (order.customer?.defaultAddress?.country)!)")
        self.discount.text = "\(discountRate ?? "-")%, \(discountPromoCode ?? "No promo code applied")"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handleNavigationBar()
    }
    
    
    func handleNavigationBar() {
        guard let view = self.navigationController?.visibleViewController else {
            return
        }
        view.title = "Order Details"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (selectedOrder?.lineItems?.count ?? 1) - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemCell = itemsList.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductTableViewCell
        if let items = selectedOrder?.lineItems {
            let item = items[indexPath.row]
//            print("the full Title === \(item.title)")
            let fullTitle = item.title
            var extractedTitle = fullTitle
                    if let firstRange = fullTitle?.range(of: "|") {
                        extractedTitle = String((fullTitle?[firstRange.upperBound...])!).trimmingCharacters(in: .whitespacesAndNewlines)
                        
                        // If there's a second | character, remove everything after it
                        if let secondRange = extractedTitle?.range(of: "|") {
                            extractedTitle = String((extractedTitle?[..<secondRange.lowerBound])!).trimmingCharacters(in: .whitespacesAndNewlines)
                        }
                    }
            let variantTitle = item.variantTitle ?? ""
             let components = variantTitle.split(separator: "/").map { $0.trimmingCharacters(in: .whitespaces) }
             if components.count == 2 {
                 itemCell.productSize.text = components[0]
                 itemCell.productColor.text = components[1]
             } else {
                 itemCell.productSize.text = ""
                 itemCell.productColor.text = ""
             }
            itemCell.productTitle.text = extractedTitle
            itemCell.brand.text = item.vendor
            itemCell.productPrice.text = item.price
            let imageUrl = selectedOrder?.lineItems?[indexPath.row+1].properties?[0]["value"]
            let url = URL(string: imageUrl ?? "")
            itemCell.favProductImageView.kf.setImage(with: url)
            
               }
        return itemCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Return the desired height for each cell
        return 128
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    

}
