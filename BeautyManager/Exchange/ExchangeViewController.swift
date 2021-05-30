//
//  ExchangeViewController.swift
//  BeautyManager
//
//  Created by SurbineHuang on 25/5/21.
//

import UIKit

class ExchangeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
}

extension ExchangeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ExchangeTableViewCell", for: indexPath) as? ExchangeTableViewCell {
            cell.view.layer.cornerRadius = 30.0
            cell.view.layer.shadowOpacity = 0.2

            return cell
        }
        return UITableViewCell()
    }
}
