//
//  ViewController.swift
//  BeautyManager
//
//  Created by SurbineHuang on 13/5/21.
//

import UIKit

class MyListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var products: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//
    
//    }
//
    func loadProducts() {

        
    }
}

extension MyListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

//        let product = self.products[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MyListTableViewCell", for: indexPath) as? MyListTableViewCell {
            
//            cell.setData(product: product.product, brand: product.brand, type: product.type)
            
            return cell
        }
        return UITableViewCell()
    }
    
    // 左滑刪除
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "刪除") {
            
            (action, view, completionHandler) in
//            self.products.remove(at: indexPath.row)
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
