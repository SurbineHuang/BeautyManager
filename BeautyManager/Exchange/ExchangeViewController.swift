//
//  ExchangeViewController.swift
//  BeautyManager
//
//  Created by SurbineHuang on 25/5/21.
//

import UIKit
import Kingfisher
import MJRefresh

enum ExchangeType: Int {
    case myItem = 0
    case finished = 1
}

class ExchangeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var currentType: ExchangeType = .myItem     // Default is myItem
    var products: [Product] = []
    let myId = UserDefaults.standard.string(forKey: "appleId")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.tableView.mj_header?.endRefreshing()
            self.loadProducts()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.loadProducts()
    }
    
    @IBAction func mySegmentedAction(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == ExchangeType.myItem.rawValue {
            self.currentType = .myItem
            
        } else if sender.selectedSegmentIndex == ExchangeType.finished.rawValue {
            self.currentType = .finished
        }
        
        self.loadProducts()
    }
    
    func loadProducts() {
        
        ProductManager.shared.getProducts { [weak self] result in
            
            // NOTE: 確保 self 存在, 遇到 weak self 時, 就寫下面這段 guard let
            // =============================
            guard let weakSelf = self else {
                return
            }
            // =============================
            
            switch result {
            case .success(let products):
                
                switch weakSelf.currentType {
                
                case .myItem:
                    weakSelf.products = products.filter { (product) -> Bool in
                        
                        let isExchanging = (product.status == "pending")
                        let isMyItem = (product.ownerId == weakSelf.myId)
                        return isExchanging && isMyItem
                        
//                        let isExchanging = (product.status == "exchanging")
//                        return isExchanging
                    }
                    
                case .finished:
                    weakSelf.products = products.filter { (product) -> Bool in
                        
                        let isFinished = (product.status == "finished")
                        let isMyItem = (product.ownerId == weakSelf.myId)
                        return isFinished && isMyItem
                        
//                        let isFinished = (product.status == "finished")
//                        return isFinished
                    }
                }
                
                weakSelf.tableView.reloadData()
                
            case .failure(let error):
                
                print("ExchangeViewController loadProducts.failure: \(error)")
            }
        }
    }
}

extension ExchangeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let product: Product = self.products[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ExchangeTableViewCell", for: indexPath) as? ExchangeTableViewCell {
            cell.view.layer.cornerRadius = 8.0
            cell.view.layer.shadowOpacity = 0.09
            
            let date = Date(timeIntervalSince1970: product.expiryDate)
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy.MM.dd"
            let expiryStr = formatter.string(from: date)
            
            cell.setData(name: product.name, expiryDate: expiryStr)
            
            let photoImage = self.products[indexPath.row]
            let imageUrl = photoImage.photo
            let url = URL(string: imageUrl)
            cell.productImageView.kf.setImage(with: url)
            
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
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if self.currentType == .finished {
            return nil
        }
        
        let addToChange = UIContextualAction(style: .normal, title: "處理完了！") { _, _, completionHandler in
            completionHandler(true)
            
            ProductManager.shared.changeProductStatusToFinish(appleId: self.products[indexPath.row].id)
            
            self.products.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }

        addToChange.backgroundColor = UIColor.lightGray
//        addToChange.image = UIImage(named: "exchange_32")

        return UISwipeActionsConfiguration(actions: [addToChange])
    }
}
