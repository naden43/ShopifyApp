//
//  PlaceOrderViewController.swift
//  ShopifyApp
//
//  Created by Naden on 30/05/2024.
//

import UIKit
import PassKit
import Reachability
import Lottie

class PlaceOrderViewController: UIViewController {

    @IBOutlet weak var finalTotalMoney: UILabel!
    @IBOutlet weak var discountMoney: UILabel!
    @IBOutlet weak var coupon: UITextField!
    @IBOutlet weak var totalMoney: UILabel!
    var selectedAdd : Address?
    var allDiscounts : [DiscountCode]?
    var viewModel:PlaceOrderViewModel?
    var cartViewModel:ShopingCartViewModel?
    var addrressViewModel : UserAddressesViewModel?
    var paymentMethod = "cash"
    let animationView = LottieAnimationView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = PlaceOrderViewModel()
        cartViewModel = ShopingCartViewModel(network: NetworkHandler.instance)
        addrressViewModel = UserAddressesViewModel(network: NetworkHandler.instance)
        viewModel?.bindData = {[weak self] in
            
            self?.totalMoney.text =  self?.viewModel?.getTotalPrice()
            self?.finalTotalMoney.text =  self?.viewModel?.getTotalPrice()

        }
        
        viewModel?.bindEditCartAlert = {
            
            let alert = UIAlertController(title: "shopping cart ", message: "some of products in shopping cart are soldout handle your shopping cart and come back again ", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            self.present(alert, animated: true)
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
        cartViewModel?.loadData()
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
    
    private func navigateToHome() {
        print("Navigating to home...")
        
        let part1Storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let homeScreen = part1Storyboard.instantiateViewController(withIdentifier: "naviagtion")
    
        present(homeScreen, animated: true)
    }
//    func navigateToHome() {
//        // Access root navigation controller from Main.storyboard
//        guard let navigationController = navigationController else {
//            print("Navigation controller is nil")
//            return
//        }
//
//        // Print all view controllers in the navigation stack for debugging
//        print("Navigation stack view controllers:")
//        for viewController in navigationController.viewControllers {
//            print("- \(viewController)")
//        }
//
//        // Attempt to find and navigate to HomeViewController
//        for viewController in navigationController.viewControllers {
//            if let homeVC = viewController as? HomeScViewController {
//                navigationController.popToViewController(homeVC, animated: true)
//                return
//            }
//        }
//        print("HomeViewController not found in the navigation stack")
//    }
    
    func playLottieAnimation() {
        animationView.animation = LottieAnimation.named("Animation")
        
        animationView.contentMode = .scaleToFill
        animationView.animationSpeed = 1.0
        
        animationView.play()
        view.addSubview(animationView)
        }


    @IBAction func placeOrderAction(_ sender: Any) {
        guard let discountRate = viewModel?.getDiscountRate() else {
            print("No discount rate available")
            return
        }
        
        let discountCode = DiscountCode(code: coupon.text ?? "-", amount: "\(discountRate)", type: "Percentage")
        allDiscounts?.append(discountCode)
        print("inside view controller the discount ==== \(discountRate)")
    
        var items = viewModel?.getAllProductsFromDraftOrder()
        print("all products in cart are : \(items?.count)")
        let customerId = viewModel?.getCustomerID() ?? 0
        let financialStatus = paymentMethod == "cash" ? "pending" : "paid"
        
        if paymentMethod == "cash" {
            viewModel?.placeOrder(lineItems: items ?? [], customerId: customerId, financialStatus: financialStatus, discount_codes: allDiscounts ?? [])
                            self.playLottieAnimation()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                self.navigateToHome()
                            }
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
        var items = viewModel?.getAllProductsFromDraftOrder()
        viewModel?.placeOrder(lineItems: items ?? [], customerId: viewModel?.getCustomerID() ?? 7876947378342, financialStatus: "paid", discount_codes: allDiscounts ?? [])
        navigateToHome()
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        // Mock success response
        let paymentResult = PKPaymentAuthorizationResult(status: .success, errors: nil)
        completion(paymentResult)
    }
    

}

