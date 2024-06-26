//
//  SearchTableViewController.swift
//  ShopifyApp
//
//  Created by Salma on 15/06/2024.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var productsSearchBar: UISearchBar!
    @IBOutlet weak var productsTableView: UITableView!
    var homeViewModel: HomeViewModelProtocol?
    var viewModel: SearchViewModel?
    var initialFilteredProducts: [Product] = []
    var destination: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = SearchViewModel()
        homeViewModel = HomeViewModel()
        
        if !initialFilteredProducts.isEmpty || destination == true {
            viewModel?.products = initialFilteredProducts
            viewModel?.filteredProducts = initialFilteredProducts
        } else {
            destination = false
            viewModel?.fetchProducts { success in
                if success {
                    print("Successfully fetched IDs and products:")
                    self.productsTableView.reloadData()
                } else {
                    print("Failed to fetch IDs and products.")
                }
            }
        }

        productsTableView.dataSource = self
        productsTableView.delegate = self
        productsTableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "searchedCell")
        
        productsSearchBar.delegate = self
        homeViewModel?.loadFavProducts()
        
       
        setupNavigationBar()
        
        customizeSearchBar()
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    private func customizeSearchBar() {
        productsSearchBar.tintColor = UIColor(named: "tentColor")
        
        if let textField = productsSearchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = UIColor.white
            textField.textColor = UIColor.black
            
            if let placeholderLabel = textField.value(forKey: "placeholderLabel") as? UILabel {
                placeholderLabel.textColor = UIColor.lightGray
            }
            
            if let customColor = UIColor(named: "tentColor") {
                textField.backgroundColor = customColor
            }
            
            textField.layer.cornerRadius = 10
            textField.clipsToBounds = true
        }
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.filteredProducts.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchedCell", for: indexPath) as? SearchTableViewCell else {
            return UITableViewCell()
        }
        
        if let product = viewModel?.filteredProducts[indexPath.row] {
            cell.configure(with: product)
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let products = viewModel?.filteredProducts {
            let selectedProduct = products[indexPath.row]
            let productDetailsViewModel = ProductDetailsViewModel(selectedProduct: selectedProduct)
             
            let storyboard = UIStoryboard(name: "Part3", bundle: nil)
            if let productDetailsVC = storyboard.instantiateViewController(withIdentifier: "productDetailsScreen") as? ProductDetailsViewController {
                productDetailsVC.viewModel = productDetailsViewModel
                productDetailsVC.favViewModel = homeViewModel?.getFavViewModel()
                navigationController?.pushViewController(productDetailsVC, animated: true)
            }
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.filterProducts(with: searchText)
        productsTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
