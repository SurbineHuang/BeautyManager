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
//    func loadProducts() {
//
//
//    }
}

extension MyListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

//        let product = self.products[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MyListTableViewCell", for: indexPath) as? MyListTableViewCell {
            
//            cell.setData(product: product.product, brand: product.brand, type: product.type)
            
            return cell
        }
        return UITableViewCell()
    }
}
