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
    
    var viewModel: SearchViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = SearchViewModel()
        viewModel?.fetchProducts { success in
            if success {
                print("Successfully fetched IDs and products:")
                self.productsTableView.reloadData()
            } else {
                print("Failed to fetch IDs and products.")
            }
        }
        productsTableView.dataSource = self
        productsTableView.delegate = self
        productsTableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "searchedCell")
        
        productsSearchBar.delegate = self
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
        return 350.0
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

