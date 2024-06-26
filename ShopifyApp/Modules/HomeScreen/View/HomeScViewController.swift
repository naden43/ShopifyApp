//
//  HomeScViewController.swift
//  ShopifyApp
//
//  Created by Aya Mostafa on 02/06/2024.
//

import UIKit
import Kingfisher
import Reachability

class HomeScViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    let reachability = try! Reachability()
    @IBOutlet weak var adsControl: UIPageControl!
    @IBOutlet weak var brandsCollection: UICollectionView!
    var brandName : String?
    var viewModel : HomeViewModelProtocol?
    var arrAdsPhotos = [UIImage(named: "ad1")!,UIImage(named: "ad2")!,UIImage(named: "ad3")!]
    var timer : Timer?
    var currentCellIndex = 0
    let activityIndicator = UIActivityIndicatorView(style: .large)
    override func viewDidLoad() {
        super.viewDidLoad()
        brandsCollection.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        
//        UserDefaultsManager.shared.saveCustomer(id: 7877044240550, note: "979195199654,979195232422")
        
        
        
        print("update")
        
        
        viewModel = HomeViewModel()
        brandsCollection.delegate = self
        brandsCollection.dataSource = self
        adsControl.numberOfPages = arrAdsPhotos.count
        
        //Compositional layout
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            switch sectionIndex {
            case 0:
                return self.adsSectionLayout()
            case 1:
                return self.brandsSectionLayout()
            default:
                return nil
            }
        }
        brandsCollection.collectionViewLayout = layout
        
        startTimer()
        viewModel?.bindToHomeViewController = { [weak self] in
           // print("inside the bind closure")
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.brandsCollection.reloadData()
            }
        }
        
        viewModel?.bindPriceRules = { [weak self] in
            self?.brandsCollection.reloadData()
        }
        
        if viewModel?.checkForCustomerOrGuest() == false {
            print("here")
            navigateToChooseModeScreen()
        }
        
        
        
        viewModel?.fetchCurrencyDataAndStore(currencyType: viewModel?.getCurrencyType() ?? "EGP")
        
        self.activityIndicator.center = self.view.center
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let url = Constants.EndPoint.brands
        viewModel?.fetchBands(url: url)
        viewModel?.getPriceRules()
        handleNavigationBar()
    }
    
    func navigateToChooseModeScreen() {
        
        let part3Storyboard = UIStoryboard(name: "Part3", bundle: nil)
        
        let chooseModeScreen = part3Storyboard.instantiateViewController(withIdentifier: "choose_screen")
        
        present(chooseModeScreen, animated: false)
    }
    
    
    func handleNavigationBar() {
        guard let view = self.navigationController?.visibleViewController else {
            return
        }
        
        let searchButton = UIBarButtonItem(image: UIImage(named: "searcc.svg"), style: .plain, target: self, action: #selector(searchButton))
        let cartButton = UIBarButtonItem(image: UIImage(systemName: "cart"), style: .plain, target: self, action: #selector(cartBtn))
        let heartButton = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(heartBtn))
        
        searchButton.tintColor = UIColor(ciColor: .black)
        cartButton.tintColor = UIColor(ciColor: .black)
        heartButton.tintColor = UIColor(ciColor: .black)
        
        view.navigationItem.leftBarButtonItem = searchButton
        view.navigationItem.rightBarButtonItems = [heartButton, cartButton]
        view.title = ""
    }
    
    func startTimer () {
        timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(moveToNextIndex), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func moveToNextIndex () {
        if currentCellIndex < arrAdsPhotos.count - 1{
            currentCellIndex += 1
        }else {
            currentCellIndex = 0
        }
    
        brandsCollection.scrollToItem(at: IndexPath(item: currentCellIndex, section: 0), at: .centeredHorizontally, animated: true)
        adsControl.currentPage = currentCellIndex
    }
    
    @objc func addTapped(){
        
        print("perform")
    }
    
    @objc func cartBtn(){
        
        if viewModel?.checkIfUserAvaliable() == true {
            
            switch reachability.connection {
                
                case .unavailable:
                    let alert = UIAlertController(title: "network", message: "You are not connected to the network check you internet  ", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                    /*alert.addAction(UIAlertAction(title: "Login\\Register", style: .cancel, handler: { action in
                        
                        let part3Storyboard = UIStoryboard(name: "Part3", bundle: nil)
                        
                        let chooseScreen = part3Storyboard.instantiateViewController(withIdentifier: "choose_screen")
                    
                        self.present(chooseScreen, animated: true)
                    
                    }))*/
                
                    present(alert, animated: true)
                
                case .wifi , .cellular:
                    let shopingScreen = UIStoryboard(name: "Part2", bundle: nil).instantiateViewController(withIdentifier: "shoping-cart") as! ShoppingCartViewController
                    navigationController?.pushViewController(shopingScreen, animated: true)
                
            }
            
            
        }
        else {
            
            let alert = UIAlertController(title: "Guest", message: "You are not a user please login or reguster first ", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel ))
            alert.addAction(UIAlertAction(title: "Login \\ Register", style: .default, handler: { action in
                
                let part3Storyboard = UIStoryboard(name: "Part3", bundle: nil)
                
                let chooseScreen = part3Storyboard.instantiateViewController(withIdentifier: "choose_screen")
            
                self.present(chooseScreen, animated: true)
            
            }))
            present(alert, animated: true)
        }
        
        
    }
    
    @objc func heartBtn(){
        
        if viewModel?.checkIfUserAvaliable() == true {
            
            switch reachability.connection {
                
                case .unavailable:
                
                    let alert = UIAlertController(title: "network", message: "You are not   connected to the network check you internet  ", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                    alert.addAction(UIAlertAction(title: "Login\\Register", style: .cancel, handler: { action in
                    
                    let part3Storyboard = UIStoryboard(name: "Part3", bundle: nil)
                    
                    let chooseScreen = part3Storyboard.instantiateViewController(withIdentifier: "choose_screen")
                    
                    self.present(chooseScreen, animated: true)
                    
                }))
                
                present(alert, animated: true)
                
            case .wifi , .cellular :
                let storyboard = UIStoryboard(name: "Part3", bundle: nil)
                if let favProductsVC = storyboard.instantiateViewController(withIdentifier: "favProductsScreen") as? FavProductsViewController {
                    navigationController?.pushViewController(favProductsVC, animated: true)
                }
                
                print("perform")
            }
        }
        else {
            let alert = UIAlertController(title: "Guest", message: "You are not a user please login or reguster first ", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            alert.addAction(UIAlertAction(title: "Login \\ Register", style: .default, handler: { action in
                
                let part3Storyboard = UIStoryboard(name: "Part3", bundle: nil)
                
                let chooseScreen = part3Storyboard.instantiateViewController(withIdentifier: "choose_screen")
            
                self.present(chooseScreen, animated: true)
            
            }))
            present(alert, animated: true)
        }
    }
    
    @objc func searchButton() {
        print("Search button tapped")
        print("Navigation controller: \(navigationController)")
        let storyboard = UIStoryboard(name: "Part3", bundle: nil)
        if let searchProductsVC = storyboard.instantiateViewController(withIdentifier: "searchProductsScreen") as? SearchViewController {
            print("Before navigation push")
            navigationController?.pushViewController(searchProductsVC, animated: true)
        } else {
            print("Failed to instantiate SearchViewController from storyboard")
        }
        print("After navigation logic")
    }

    
    
    func getUniqueBrands() -> [SmartCollection] {
        guard let brands = viewModel?.getBrands() else {
            return []
        }

    //    print("All Brands Count: \(brands.count)")
        let uniqueBrands = brands.filter{!$0.handle.contains("-1")}
     //   print("Filtered Brands Count: \(uniqueBrands.count)")
       // print("All Brands Count: \(brands.count)")

        //print("Filtered Brands Count: \(uniqueBrands.count)")
        return uniqueBrands
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let uniqueBrands = getUniqueBrands()
        if section == 0 {
            return arrAdsPhotos.count
            
        }else{
            return uniqueBrands.count
        }
    }
    

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let brandCell = brandsCollection.dequeueReusableCell(withReuseIdentifier: "brandsCell", for: indexPath) as! BrandCollectionViewCell
         let adsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "adsCell", for: indexPath) as! AdsCollectionViewCell
         let brands = getUniqueBrands()
        if(indexPath.section == 0){
            adsCell.adsImage.image = arrAdsPhotos[indexPath.row]
            
            return adsCell
        }else {
            brandCell.layer.cornerRadius = 20
            //brandCell.brandName.text = brands[indexPath.row].title
            //brandCell.viewContainer.layer.cornerRadius = 15
            brandCell.brandImg.layer.cornerRadius = 20
            var brandIMG = brands[indexPath.row].image.src
            let imageUrl = URL(string: brandIMG)
            brandCell.brandImg.kf.setImage(with: imageUrl)
            self.brandName = brands[indexPath.row].title
            // Add shadow
            brandCell.layer.shadowColor = UIColor.orange.cgColor
            brandCell.layer.shadowOffset = CGSize(width: 0, height: 2)
            brandCell.layer.shadowRadius = 4
            brandCell.layer.shadowOpacity = 0.2
            brandCell.layer.masksToBounds = false
            return brandCell
        }
    }



    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            if UserDefaultsManager.shared.getCustomer().id != nil {
                
                let textToCopy = viewModel?.getPriceRuleByIndex(index: indexPath.row)
                
                let alertController = UIAlertController(title: nil, message: "get your coupon", preferredStyle: .actionSheet)
                
                let copyAction = UIAlertAction(title: "Copy", style: .default) { (_) in
                    UIPasteboard.general.string = textToCopy
                }
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                alertController.addAction(copyAction)
                alertController.addAction(cancelAction)
                present(alertController, animated: true, completion: nil)
                
            }
            else {
                
                let alert = UIAlertController(title: "Guest", message: "You are not a user please login or reguster first ", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                alert.addAction(UIAlertAction(title: "Login \\ Register", style: .default, handler: { action in
                    
                    let part3Storyboard = UIStoryboard(name: "Part3", bundle: nil)
                    
                    let chooseScreen = part3Storyboard.instantiateViewController(withIdentifier: "choose_screen")
                
                    self.present(chooseScreen, animated: true)
                
                }))
                present(alert, animated: true)
                
            }
        }
        else {
            let brands = getUniqueBrands()
            let selectedBrandId = brands[indexPath.row].id
            //let selectedBrandName = brands[indexPath.row].title
            let storyboard = UIStoryboard(name: "Part1", bundle: nil)
            
            let backItem = UIBarButtonItem()
            backItem.title = brands[indexPath.row].title
            self.navigationItem.backBarButtonItem = backItem
            
            
            if let productVC = storyboard.instantiateViewController(withIdentifier: "productBrandScreen") as? ProductsViewController {
                productVC.brandId = selectedBrandId
                productVC.brandName = brands[indexPath.row].title
                navigationController?.pushViewController(productVC, animated: true)
            }
        }
    }

    
    func adsSectionLayout() -> NSCollectionLayoutSection{

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1)
        , heightDimension: .absolute(222))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize
        , subitems: [item])
            group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8
            , bottom: 0, trailing: 8)

        let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0
            , bottom: 0, trailing: 0)
            section.orthogonalScrollingBehavior = .continuous
        // Animation
        section.visibleItemsInvalidationHandler = { (items, offset, environment) in
             items.forEach { item in
             let distanceFromCenter = abs((item.frame.midX - offset.x) - environment.container.contentSize.width / 2.0)
             let minScale: CGFloat = 0.8
             let maxScale: CGFloat = 1.0
             let scale = max(maxScale - (distanceFromCenter / environment.container.contentSize.width), minScale)
             item.transform = CGAffineTransform(scaleX: scale, y: scale)
             }
        }
        return section
    }

    func brandsSectionLayout() -> NSCollectionLayoutSection {
        // Define the size of each item (movie cell)
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), // Each item takes up half of the width
                                              heightDimension: .fractionalHeight(1)) // Keep the height as 250 points

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16) // Add spacing between items

        // Create a group that contains two items horizontally
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), // The group takes up the full width of the section
                                               heightDimension: .fractionalHeight(0.3)) // Each group takes up the full height of the section
        

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item ])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0
        , bottom: 0, trailing: 0)
        // Center the group within the section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 10, trailing: 16)
        section.contentInsetsReference = .layoutMargins
        section.interGroupSpacing = 10 // Add spacing between rows

        return section
    }


    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            startTimer()
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        startTimer()
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
