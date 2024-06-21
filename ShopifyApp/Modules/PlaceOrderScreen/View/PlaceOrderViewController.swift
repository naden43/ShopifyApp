//
//  PlaceOrderViewController.swift
//  ShopifyApp
//
//  Created by Naden on 30/05/2024.
//

import UIKit
import PassKit
import Reachability

class PlaceOrderViewController: UIViewController {

    @IBOutlet weak var finalTotalMoney: UILabel!
    @IBOutlet weak var discountMoney: UILabel!
    @IBOutlet weak var coupon: UITextField!
    @IBOutlet weak var totalMoney: UILabel!
    
    var viewModel:PlaceOrderViewModel?
    var paymentMethod = "cash"
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

        viewModel?.bindDiscaountCouponError = {[weak self] in
            
            let alert = UIAlertController(title: nil, message: "wrong or expired coupon try anothr one ", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
            self?.present(alert, animated: true)
            
            self?.coupon.text = nil
            
        }
        viewModel?.loadData()
    }
    
    @IBAction func backToPaymentMethod(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func checkCoupon(_ sender: Any) {
     
        let reachability = try! Reachability()
        
        switch reachability.connection {
            
        case .wifi , .cellular :
            let couponTxt = coupon.text
            
            if couponTxt == "" {
                
                let alert = UIAlertController(title: "Coupon", message: "enter the coupon first", preferredStyle: .actionSheet)
                
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                
                present(alert, animated: true)
            }
            else {
                
                viewModel?.createDiscountIfAvaliable(coupon: couponTxt ?? "")
            }
        case .unavailable:
            let alert = UIAlertController(title: nil ,  message: "Check your network first !", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
        
        
        
    }


    @IBAction func placeOrderAction(_ sender: Any) {
        
        if paymentMethod == "cash" {
            
            // place order in api 
            
            
        }
        else {
            if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: [.amex, .masterCard, .visa]) {
                // Create a payment request
                let paymentRequest = PKPaymentRequest()
                paymentRequest.merchantIdentifier = "merchant.itiTeam4" // Replace with your merchant identifier
                paymentRequest.supportedNetworks = [.amex, .masterCard, .visa] // Supported payment networks
                paymentRequest.merchantCapabilities = .capability3DS // Merchant capabilities
                paymentRequest.countryCode = "US" // Country code
                paymentRequest.currencyCode = viewModel?.getCurrency() ?? "USD" // Currency code
                
                // Example of getting total money from viewModel
                let totalMoney = viewModel?.getTotalMoney() ?? 0.0
                
                // Create a payment summary item with a properly formatted amount
                let totalAmount = NSDecimalNumber(decimal: Decimal(totalMoney))
                let paymentSummaryItem = PKPaymentSummaryItem(label: "Total payment price", amount: totalAmount, type: .final)
                
                paymentRequest.paymentSummaryItems = [paymentSummaryItem]
                
                // Create a payment authorization view controller
                let paymentAuthorizationVC = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
                paymentAuthorizationVC?.delegate = self
                
                if let viewController = paymentAuthorizationVC {
                    present(viewController, animated: true, completion: nil)
                } else {
                    // Handle error presenting payment authorization view controller
                    print("Failed to create payment authorization view controller")
                }
            } else {
                // Apple Pay is not available
                print("Apple Pay is not available")
            }

            
        }
        
    }
}

extension PlaceOrderViewController : PKPaymentAuthorizationViewControllerDelegate {
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
        // place order in api

    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        // Mock success response
        let paymentResult = PKPaymentAuthorizationResult(status: .success, errors: nil)
        completion(paymentResult)
    }
}

