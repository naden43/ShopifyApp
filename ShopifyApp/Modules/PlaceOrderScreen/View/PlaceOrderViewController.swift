//
//  PlaceOrderViewController.swift
//  ShopifyApp
//
//  Created by Naden on 30/05/2024.
//

import UIKit

class PlaceOrderViewController: UIViewController {

    @IBOutlet weak var finalTotalMoney: UILabel!
    @IBOutlet weak var discountMoney: UILabel!
    @IBOutlet weak var coupon: UITextField!
    @IBOutlet weak var totalMoney: UILabel!
    
    var viewModel:PlaceOrderViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = PlaceOrderViewModel()
        
        viewModel?.bindData = {[weak self] in
            
            self?.totalMoney.text =  self?.viewModel?.getTotalPrice()
            self?.finalTotalMoney.text =  self?.viewModel?.getTotalPrice()
            

            
        }
        
        viewModel?.bindDiscount = { [weak self] in
            
            self?.discountMoney.text = self?.viewModel?.getSavedMoney()
            self?.finalTotalMoney.text = self?.viewModel?.getPriceAfterApplayDiscount()
            
        }

        viewModel?.loadData()
    }
    
    @IBAction func backToPaymentMethod(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func checkCoupon(_ sender: Any) {
        
        let couponTxt = coupon.text
        
        if couponTxt == "" {
            
            let alert = UIAlertController(title: "Coupon", message: "enter the coupon first", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            
            present(alert, animated: true)
        }
        else {
            
            viewModel?.createDiscountIfAvaliable(coupon: couponTxt ?? "")
        }
        
    }


    @IBAction func placeOrderAction(_ sender: Any) {
    }
}
