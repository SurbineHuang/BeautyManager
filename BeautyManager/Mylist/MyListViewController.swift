//
//  ViewController.swift
//  BeautyManager
//
//  Created by SurbineHuang on 13/5/21.
//

import UIKit
import MJRefresh

class MyListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var products: [Product] = []
    var brands: [Brand] = []
    var types: [Type] = []
    var filteredProducts: [Product] = []
    
    var isSearching = false
    
    
    
    // Array init 的三種方式
//    let stringArray = Array<String>()
//    let stringArray2 = [String]()
//    let stringArray3: [String] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate =  self
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.tableView.mj_header?.endRefreshing()
            self.loadProducts()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {

        self.loadProducts()
        self.loadBrands()
        self.loadTypes()
    }

    func loadProducts() {

        ProductManager.shared.getProducts { [weak self] result in
            switch result {

            case .success(let products):
                
                print("======\(products)")
                self?.products = products
                self?.tableView.reloadData()

            case .failure(let error):

                print("loadProducts.failure: \(error)")
            }
        }
    }
    
    func loadBrands() {
        
        ProductManager.shared.getBrands { [weak self] result in
            switch result {
            
            case .success(let brands):
                
                print("======\(brands)")
                self?.brands = brands
                self?.tableView.reloadData()
                
            case .failure(let error):
                
                print("loadBrands.failure: \(error)")
            }
        }
    }
    
    func loadTypes() {
        
        ProductManager.shared.getTypes { [weak self] result in
            switch result {
            
            case .success(let types):
                
                print("======\(types)")
                self?.types = types
                self?.tableView.reloadData()
                
            case .failure(let error):
                
                print("loadTypes.failure: \(error)")
            }
        }
    }
}

extension MyListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching {
            return filteredProducts.count
        } else {
            return products.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Computed property
        var product: Product {
            if isSearching {
                return self.filteredProducts[indexPath.row]
            } else {
                return self.products[indexPath.row]
            }
        }
     
        let date = Date(timeIntervalSince1970: product.expiryDate)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        let expiryStr = formatter.string(from: date)
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MyListTableViewCell", for: indexPath) as? MyListTableViewCell {
            
            cell.backView.layer.cornerRadius = 30.0
            cell.backView.layer.shadowOpacity = 0.2
            cell.setData(name: product.name, brand: "brand", type: "type", expiryDate: expiryStr)
            
            return cell
        }
        return UITableViewCell()
    }
    
    // 左滑刪除
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "刪除") {
            
            (action, view, completionHandler) in
            self.products.remove(at: indexPath.row)
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = UIColor.lightGray
        deleteAction.image = UIImage(named: "delete(2)64*64")
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    // 右滑移動交換
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let addToChange = UIContextualAction(style: .normal, title: "來交換吧！") {
            
            (action, view, completionHandler) in
            completionHandler(true)
        }
        
        addToChange.backgroundColor = UIColor.lightGray
        addToChange.image = UIImage(named: "exchange64*64")
        
        return UISwipeActionsConfiguration(actions: [addToChange])
    }
}

extension MyListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        print("searchText \(searchText)")
        
        if searchText == "" {
            
            self.isSearching = false
            
        } else {
            
            self.isSearching = true
            
            self.filteredProducts = []
            
            let filteredArrayByName = self.products.filter { (product) -> Bool in
                product.name.contains(searchText)
            }
            
            self.filteredProducts.append(contentsOf: filteredArrayByName)
            
            // TODO: Waiting for brand struct changed
            /*
            let filteredArrayByBrand = self.brands.filter { (brand) -> Bool in
                brand.name.contains(searchText)
            }
            self.filteredProducts.append(contentsOf: filteredArrayByBrand)
             */
        }
        
        self.tableView.reloadData()
    }
}
