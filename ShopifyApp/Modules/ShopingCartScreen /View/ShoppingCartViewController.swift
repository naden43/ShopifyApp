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


    @IBOutlet weak var totalTxt: UILabel!
    @IBOutlet weak var shopingCartList: UITableView!
    
    var viewModel : ShopingCartViewModel?
    var currency = "LE"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shopingCartList.delegate = self
        shopingCartList.dataSource = self
        
        viewModel = ShopingCartViewModel(network: NetworkHandler.instance)
        
        viewModel?.bindData = { [weak self] in
            
            self?.totalTxt.text = "\(self?.viewModel?.getTotalPrice() ?? "") \(self?.currency ?? "")"
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
        cell.productPrice.text = "\(data?.price ?? "")\(currency)"
        
        let url = URL(string: viewModel?.getImageByIndex(index: indexPath.row) ?? "")
        cell.productImage.kf.setImage(with: url)
        
        return cell
    }
  

    @IBAction func navToCheckOut(_ sender: Any) {
    }
}
