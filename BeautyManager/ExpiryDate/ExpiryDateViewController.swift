//
//  ExpiryDateTableViewController.swift
//  BeautyManager
//
//  Created by SurbineHuang on 18/5/21.
//

import UIKit

class ExpiryDateViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
   
    var products: [Product] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
}
extension ExpiryDateViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ExpiryDateTableViewCell", for: indexPath) as? ExpiryDateTableViewCell {
            cell.view.layer.cornerRadius = 30.0
            cell.view.layer.shadowOpacity = 0.2
            cell.setData()

            return cell
        }
        return UITableViewCell()
    }

    // swiftlint:disable closure_parameter_position
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "刪除") { _, _, completionHandler in
            completionHandler(true)
            self.products.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }

        deleteAction.backgroundColor = UIColor.lightGray
        deleteAction.image = UIImage(named: "delete(3)32*32")

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    // swiftlint:enable closure_parameter_position
    
}
