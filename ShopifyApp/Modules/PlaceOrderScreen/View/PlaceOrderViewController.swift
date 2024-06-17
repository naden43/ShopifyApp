//
//  PlaceOrderViewController.swift
//  ShopifyApp
//
//  Created by Naden on 30/05/2024.
//

import UIKit
import PassKit

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
        
        if paymentMethod == "cash" {
            
            // place order in api 
            
            
        }
        else {
            if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: [.amex, .masterCard, .visa]) {
                
                print("enter here ")
                        // Create a payment request
                        let paymentRequest = PKPaymentRequest()
                        paymentRequest.merchantIdentifier = "merchant.itiTeam4" // Replace with your merchant identifier
                        paymentRequest.supportedNetworks = [.amex, .masterCard, .visa] // Supported payment networks
                        paymentRequest.merchantCapabilities = .capability3DS // Merchant capabilities
                        paymentRequest.countryCode = "US" // Country code
                paymentRequest.currencyCode = viewModel?.getCurrency() ?? "USD" // Currency code
                        paymentRequest.paymentSummaryItems = [
                            PKPaymentSummaryItem(label: "Total payment price ", amount: NSDecimalNumber(decimal: Decimal(viewModel?.getTotalMoney() ?? 0.0)), type: .final)
                        ]
                        
                        // Create a payment authorization view controller
                        let paymentAuthorizationVC = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
                        paymentAuthorizationVC?.delegate = self
                        
                        if let viewController = paymentAuthorizationVC {
                            print("enter here 2 ")
                            present(viewController, animated: true, completion: nil)
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

