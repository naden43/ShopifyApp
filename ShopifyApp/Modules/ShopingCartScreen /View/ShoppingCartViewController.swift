//
//  ShoppingCartViewController.swift
//  ShopifyApp
//
//  Created by Naden on 30/05/2024.
//

import UIKit
import Kingfisher

class ShoppingCartViewController: UIViewController , UITableViewDelegate ,
                                  UITableViewDataSource {


    @IBOutlet weak var proceedToCheckOutButton: UIButton!
    @IBOutlet weak var totalTxt: UILabel!
    @IBOutlet weak var shopingCartList: UITableView!
    
    var viewModel : ShopingCartViewModel?
    var currency : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shopingCartList.delegate = self
        shopingCartList.dataSource = self
        
        viewModel = ShopingCartViewModel(network: NetworkHandler.instance)
        
        currency = viewModel?.getCurrencyType()
        
        viewModel?.bindData = { [weak self] in
            
            let apiPrice = Double(self?.viewModel?.getTotalPrice() ?? "0.0") ?? 0.0
            let price = self?.viewModel?.calcThePrice(price: apiPrice) ?? "0.0"
            self?.totalTxt.text = "\(price) \(self?.currency ?? "")"
            
            if self?.viewModel?.avaliableToCheckOut() == true {
                
                //self?.proceedToCheckOutButton.isEnabled = false
                
            }
            else{
                
            }
            self?.shopingCartList.reloadData()
        }
        
        
        let nibCell = UINib(nibName: "CustomShoppingCartCellTableViewCell", bundle: nil)

        shopingCartList.register(nibCell, forCellReuseIdentifier: "shopingCarCell")
        
        viewModel?.loadData()
        

    }
    


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel?.getProductsCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "shopingCarCell", for: indexPath) as! CustomShoppingCartCellTableViewCell
        
        let data = viewModel?.getProductByIndex(index: indexPath.row)
        
        cell.productName.text = data?.title
        cell.productDescription.text = data?.vendor
        cell.itemCount.text = String(data?.quantity ?? 0)
        
        let apiPrice = Double(data?.price ?? "0.0") ?? 0.0
        let price = viewModel?.calcThePrice(price: apiPrice) ?? "0.0"
        cell.productPrice.text = "\(price) \(currency ?? "")"
        
        cell.plusAction = {
            
            
            if ((data?.quantity ?? 0 ) + 1) > self.viewModel?.allowedProductAmount(varientId: Int(data?.variantId ?? 0)) ?? 0 {
                
                var alert = UIAlertController(title: "exceed amount", message: "You cannot increase the amount :( ", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
                self.present(alert, animated: true)
                
            }
            else {
                cell.itemCount.text = String((Int(cell.itemCount.text ?? "0") ?? 0) + 1)

                self.viewModel?.increaseTheQuantityOfProduct(index: indexPath.row)
                
            }
            
        }
        
        cell.minusAction = {
            
            if ((Int(cell.itemCount.text ?? "0") ?? 0) - 1) == 0 {
                
                let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete this product :(", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
                    
                    let varientId = self.viewModel?.getProductByIndex(index: indexPath.row).variantId
                    
                    self.viewModel?.deleteTheProductAmount(varientId: Int(varientId ?? 0))
                    self.viewModel?.deleteTheProductFromShopingCart(index: indexPath.row)
                    
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                
                self.present(alert, animated: true)
            }
            else{
                cell.itemCount.text = String((Int(cell.itemCount.text ?? "0") ?? 0) - 1)
                
                self.viewModel?.decrementTheQuantityOfProduct(index: indexPath.row)

            }
        }
        
        let url = URL(string: viewModel?.getImageByIndex(index: indexPath.row) ?? "")
        
        //if let amount = viewModel?.getProductAmount(index: indexPath.row) {
            
        if viewModel?.productAmountAvaliable(index: indexPath.row) == false {
                
                cell.productImage.image = UIImage(named: "Sold_out")
                
        }
        else {
                cell.productImage.kf.setImage(with: url)
        }
            
        //}
        /*else{
            
            cell.productImage.kf.setImage(with: url)

        }*/
        
        
        return cell
    }
        
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let varientId = viewModel?.getProductByIndex(index: indexPath.row).variantId
            
            viewModel?.deleteTheProductAmount(varientId: Int(varientId ?? 0))
            viewModel?.deleteTheProductFromShopingCart(index: indexPath.row)
            
        }
    }
    


    @IBAction func navToCheckOut(_ sender: Any) {
        
        if viewModel?.avaliableToCheckOut() == true {
            
        }
        else {
            let alert = UIAlertController(title: "Error", message: "The product maybe Sold out of stock or you are exceed the allowed amount , Just Swipe it to remove or decrement your amount :)", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
            present(alert, animated: true)
        }
    }
}
