//
//  ExchangeViewController.swift
//  BeautyManager
//
//  Created by SurbineHuang on 25/5/21.
//

import UIKit

class ExchangeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var products: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    
    @IBAction func mySegmentedAction(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            
        }
    }
}

extension ExchangeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ExchangeTableViewCell", for: indexPath) as? ExchangeTableViewCell {
            cell.view.layer.cornerRadius = 8.0
            cell.view.layer.shadowOpacity = 0.1

            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "刪除") { _, _, completionHandler in
            completionHandler(true)
//            ProductManager.shared.removeProduct(documentID: self.products[indexPath.row].id)
//            self.products.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        deleteAction.backgroundColor = UIColor.lightGray
        deleteAction.image = UIImage(named: "delete(3)32*32")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
