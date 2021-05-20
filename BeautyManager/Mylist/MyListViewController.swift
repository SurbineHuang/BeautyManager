//
//  ViewController.swift
//  BeautyManager
//
//  Created by SurbineHuang on 13/5/21.
//

import UIKit

class MyListViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var products: [Product] = []
    var brands: [Brand] = []
    var types: [Type] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
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
    
//     設定模糊搜尋
//    func searchBar(_searchBar: UISearchBar, textDidChange searchText: String) {
//
//
//    }
    
}

extension MyListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let product = self.products[indexPath.row]

        let date = Date(timeIntervalSince1970: product.expiryDate)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        let expiryStr = formatter.string(from: date)
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MyListTableViewCell", for: indexPath) as? MyListTableViewCell {
            
            cell.setData(name: product.name, brand: "brand", type: "type", expiryDate: expiryStr )
            
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
        
        deleteAction.backgroundColor = UIColor.gray
        deleteAction.image = UIImage(named: "delete64*64")
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    // 右滑移動交換
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let addToChange = UIContextualAction(style: .normal, title: "來交換吧！") {
            
            (action, view, completionHandler) in
            completionHandler(true)
        }
        
        addToChange.image = UIImage(named: "exchange64*64")
        
        return UISwipeActionsConfiguration(actions: [addToChange])
    }
}

