//
//  ChooseCurrencyViewController.swift
//  ShopifyApp
//
//  Created by Naden on 13/06/2024.
//

import UIKit

class ChooseCurrencyViewController: UIViewController {

    
    @IBOutlet weak var usdButton: UIButton!
    @IBOutlet weak var egpButton: UIButton!
    var egpFlag = false
    var usdFlag = false
    var viewModel :ChooseCurrencyViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = ChooseCurrencyViewModel()
        
        if let selectedCurrency = viewModel?.getTheSelectedCurrency() {
            
            if selectedCurrency == "EGP" {
                egpFlag = true
                
                egpButton.setImage(UIImage(systemName: "circle.fill")
                                   , for: .normal)

            }
            else{
                usdFlag = true
                usdButton.setImage(UIImage(systemName: "circle.fill")
                                   , for: .normal)
            }
            
        }
        
        

    }
    
    @IBAction func selectUSDButton(_ sender: Any) {
        usdFlag = !usdFlag
        egpFlag = !usdFlag
        print(usdFlag)
        if usdFlag == true {
            print("here enter ")
            //usdButton.imageView?.image = UIImage(systemName: "circle.fill")
            usdButton.setImage(UIImage(systemName: "circle.fill")
                               , for: .normal)
            egpButton.setImage(UIImage(systemName: "circle")
                               , for: .normal)
            //egpButton.imageView?.image = UIImage(systemName: "circle")

        }
        else {
            
            egpButton.setImage(UIImage(systemName: "circle.fill")
                               , for: .normal)
            usdButton.setImage(UIImage(systemName: "circle")
                               , for: .normal)

        }
        
        
    }
    
    
    @IBAction func selectEgyptButton(_ sender: Any) {
        
        egpFlag = !egpFlag
        usdFlag = !egpFlag
        
        if egpFlag == true {
            egpButton.setImage(UIImage(systemName: "circle.fill")
                               , for: .normal)
            usdButton.setImage(UIImage(systemName: "circle")
                               , for: .normal)

        }
        else {
            
            usdButton.setImage(UIImage(systemName: "circle.fill")
                               , for: .normal)
            egpButton.setImage(UIImage(systemName: "circle")
                               , for: .normal)

        }
        
        
    }
    
    
    override func viewDidDisappear (_ animated: Bool) {
        
        if egpFlag == true {
            viewModel?.fetchCurrencyDataAndStore(currencyType: "EGP")
        }
        else
        {
            viewModel?.fetchCurrencyDataAndStore(currencyType: "USD")
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
