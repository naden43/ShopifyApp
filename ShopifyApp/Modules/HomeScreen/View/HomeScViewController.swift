//
//  HomeScViewController.swift
//  ShopifyApp
//
//  Created by Aya Mostafa on 02/06/2024.
//

import UIKit
import Kingfisher
class HomeScViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var brandsCollection: UICollectionView!
    var brandName : String?
    var viewModel : HomeViewModelProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        print("update")
        let url = Constants.baseUrl + Constants.EndPoint.brands
        viewModel = HomeViewModel()
        brandsCollection.delegate = self
        brandsCollection.dataSource = self
        viewModel?.bindToHomeViewController = { [weak self] in
            print("inside the bind closure")
            DispatchQueue.main.async {
                self?.brandsCollection.reloadData()
            }
        }
        viewModel?.fetchBands(url: url)
        // Do any additional setup after loading the view.
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handleNavigationBar()
    }
    
    
    func handleNavigationBar() {
        guard let view = self.navigationController?.visibleViewController else {
            return
        }
        
        let searchButton = UIBarButtonItem(image: UIImage(named: "searcc.svg"), style: .plain, target: self, action: #selector(addTapped))
        let cartButton = UIBarButtonItem(image: UIImage(systemName: "cart"), style: .plain, target: self, action: #selector(cartBtn))
        let heartButton = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(heartBtn))
        
        searchButton.tintColor = UIColor(ciColor: .black)
        cartButton.tintColor = UIColor(ciColor: .black)
        heartButton.tintColor = UIColor(ciColor: .black)
        
        view.navigationItem.leftBarButtonItem = searchButton
        view.navigationItem.rightBarButtonItems = [heartButton, cartButton] // Assign array of buttons
    }
    
    
    @objc func addTapped(){
        
        print("perform")
    }
    
    @objc func cartBtn(){
        
        print("perform")
    }
    
    @objc func heartBtn(){
        
        print("perform")
    }
    
    
    func getUniqueBrands() -> [SmartCollection] {
        guard let brands = viewModel?.getBrands() else {
            return []
        }
        print("All Brands Count: \(brands.count)")
        let uniqueBrands = brands.filter{!$0.handle.contains("-1")}
        print("Filtered Brands Count: \(uniqueBrands.count)")
        return uniqueBrands
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let uniqueBrands = getUniqueBrands()
        return uniqueBrands.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let brandCell = brandsCollection.dequeueReusableCell(withReuseIdentifier: "brandsCell", for: indexPath) as! BrandCollectionViewCell
        let brands = getUniqueBrands()
        brandCell.layer.cornerRadius = 20
        brandCell.brandName.text = brands[indexPath.row].title
        brandCell.viewContainer.layer.cornerRadius = 15
        brandCell.brandImg.layer.cornerRadius = 50
        var brandIMG = brands[indexPath.row].image.src
        let imageUrl = URL(string: brandIMG)
        brandCell.brandImg.kf.setImage(with: imageUrl)
        self.brandName = brands[indexPath.row].title
        return brandCell
    }



    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let brands = getUniqueBrands()
        let selectedBrandId = brands[indexPath.row].id
        let selectedBrandName = brands[indexPath.row].title
        let storyboard = UIStoryboard(name: "Part1", bundle: nil)
        
        let backItem = UIBarButtonItem()
            backItem.title = selectedBrandName
            self.navigationItem.backBarButtonItem = backItem
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
