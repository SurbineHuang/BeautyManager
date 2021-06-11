//
//  ExpiryDateTableViewController.swift
//  BeautyManager
//
//  Created by SurbineHuang on 18/5/21.
//

import UIKit
import MJRefresh

class ExpiryDateViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var products: [Product] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.tableView.mj_header?.endRefreshing()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadExpiredProduct()
    }
    
    func loadExpiredProduct() {
        
        ProductManager.shared.getProducts { [weak self] result in
            switch result {
            
            case .success(let products):
                self?.products = products
                self?.products = products.filter { product in
                    let now = Date().timeIntervalSince1970
                    return (product.expiryDate - now) <= 30*24*60*60
                }
                
                self?.tableView.reloadData()
            case .failure(let error):
                print("===loadExpiredProduct.failure: \(error)")
            }
        }
    }
}

extension ExpiryDateViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let product: Product = self.products[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ExpiryDateTableViewCell", for: indexPath) as? ExpiryDateTableViewCell {
            
            cell.view.layer.cornerRadius = 8
            cell.view.layer.shadowOpacity = 0.09
            cell.setData(product: product)
            
            let photoImage = self.products[indexPath.row]
            let imageUrl = photoImage.photo
            let url = URL(string: imageUrl)
            cell.productImage.kf.setImage(with: url)
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "刪除") { _, _, completionHandler in
            completionHandler(true)
            ProductManager.shared.removeProduct(appleId: self.products[indexPath.row].id)
            self.products.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        deleteAction.backgroundColor = UIColor.red
        deleteAction.image = UIImage(named: "delete_32")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
