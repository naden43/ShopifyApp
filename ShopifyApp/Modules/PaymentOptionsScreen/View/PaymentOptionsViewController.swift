//
//  PaymentOptionsViewController.swift
//  ShopifyApp
//
//  Created by Naden on 30/05/2024.
//

import UIKit
import PassKit
import Reachability

class PaymentOptionsViewController: UIViewController {

    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cashButton: UIButton!
    @IBOutlet weak var applePayButton: UIButton!
    var cashFlag = false
    var appleFlag = false
    var selectedAddress : Address?
    override func viewDidLoad() {
        super.viewDidLoad()

        if cashFlag == false  && appleFlag == false {
            confirmButton.isEnabled = false
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

    @IBAction func backToAddressScreen(_ sender: Any) {
        
        self.dismiss(animated: true)
        
    }
    
    
    @IBAction func applePayButton(_ sender: Any) {
     
        appleFlag = !appleFlag
        cashFlag = !appleFlag
        
        confirmButton.isEnabled = true
        
        if appleFlag == true {
            applePayButton.setImage(UIImage(systemName: "circle.fill")
                               , for: .normal)
            cashButton.setImage(UIImage(systemName: "circle"), for: .normal)
            
        }
        else {
            applePayButton.setImage(UIImage(systemName: "circle"), for: .normal)
            cashButton.setImage(UIImage(systemName: "circle.fill"), for: .normal)

        }

        
    }
    
    func navigateToContinueCheckout(){
        
        
        let reachability = try! Reachability()
        
        switch reachability.connection {
            
        case .wifi , .cellular :
            let part2Storyboard = UIStoryboard(name: "Part2", bundle: nil)
            
            let placeOrderScreen = part2Storyboard.instantiateViewController(withIdentifier: "place_order") as! PlaceOrderViewController
            placeOrderScreen.selectedAdd = selectedAddress
            
            if cashFlag == true{
                placeOrderScreen.paymentMethod = "cash"
                
            }
            else
            {
                placeOrderScreen.paymentMethod = "applePay"
            }
            present(placeOrderScreen, animated: true)
            
        case .unavailable:
            let alert = UIAlertController(title: nil ,  message: "Check your network first !", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
        
        
    }
    
    @IBAction func checkout(_ sender: Any) {
        
         navigateToContinueCheckout()
        
    }
    
    @IBAction func cashButton(_ sender: Any) {
        
        cashFlag = !cashFlag
        appleFlag = !cashFlag
        
        confirmButton.isEnabled = true
        
        if cashFlag == true {
            cashButton.setImage(UIImage(systemName: "circle.fill")
                               , for: .normal)
            applePayButton.setImage(UIImage(systemName: "circle"), for: .normal)

            
        }
        else {
            cashButton.setImage(UIImage(systemName: "circle"), for: .normal)
            applePayButton.setImage(UIImage(systemName: "circle.fill"), for: .normal)

        }

    }
}











