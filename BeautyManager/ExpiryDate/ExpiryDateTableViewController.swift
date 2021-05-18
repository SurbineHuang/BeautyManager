//
//  ExpiryDateTableViewController.swift
//  BeautyManager
//
//  Created by SurbineHuang on 18/5/21.
//

import UIKit

class ExpiryDateTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }


}
extension ExpiryDateTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
    }
    
    

}
