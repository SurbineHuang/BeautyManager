//
//  ViewController.swift
//  BeautyManager
//
//  Created by SurbineHuang on 13/5/21.
//

import Kingfisher
import MJRefresh
import UIKit
import UserNotifications

class MyListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var addTapped: UIButton!
    
    var products: [Product] = []
    var brands: [Brand] = []
    var types: [Type] = []
    var filteredProducts: [Product] = []
    var isSearching = false
    var didShowExpiredWarning = false

    var didSignIn: Bool {
        let appleId = UserDefaults.standard.value(forKey: "appleId")
        if appleId == nil {
            print("AppleID in userDefault is nil")
            return false
        } else {
            print("AppleID in userDefault is not nil")
            return true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self
        self.addTapped.layer.shadowOpacity = 0.1

        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.tableView.mj_header?.endRefreshing()
            self.loadProducts()
        })

        self.setNotification()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        self.view.addGestureRecognizer(tapGesture)
    }

    override func viewWillAppear(_ animated: Bool) {
        
        if self.didSignIn {
            self.loadBrands()
            self.loadTypes()
            self.loadProducts()
        } else {
            self.showSignInViewController()
        }
    }
    
    @objc func viewTapped() {
        self.view.endEditing(true)
    }

    func setNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Hello~"
        content.subtitle = "是不是很久沒來開 APP 了"
        content.body = "快來看看有什麼東西快過期了吧！"
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: "ProductReminder", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
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

                weakSelf.products = products
                
                self?.products = products.filter { (product) -> Bool in
                    return product.status == "normal"
                }
                
                weakSelf.tableView.reloadData()

                if !weakSelf.didShowExpiredWarning {
                    self?.showExpiredWarningAlert(products: products)
                }
                
            case .failure(let error):
                
                print("loadProducts.failure: \(error)")
            }
        }
    }

    func loadBrands() {
        
        ProductManager.shared.getBrands { [weak self] result in
            switch result {
            case .success(let brands):

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
            cell.backView.layer.cornerRadius = 8
            cell.backView.layer.shadowOpacity = 0.09

            let brand = ProductManager.shared.getBrandName(by: product.brandId)
            let type = ProductManager.shared.getTypeName(by: product.typeId)
            
            cell.setData(name: product.name, photoUrlString: product.photo, brand: brand, type: type, expiryDate: expiryStr)

            let photoImage = self.products[indexPath.row]

            let imageUrl = photoImage.photo
            let url = URL(string: imageUrl)
            cell.productImageView.kf.setImage(with: url)

            return cell
        }
        return UITableViewCell()
    }

    // 左滑刪除
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "刪除") { _, _, completionHandler in
            completionHandler(true)

            ProductManager.shared.removeProduct(appleId: self.products[indexPath.row].id)
            self.products.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }

        deleteAction.backgroundColor = UIColor.lightGray
        deleteAction.image = UIImage(named: "delete_32")

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    // 右滑移動交換
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let addToChange = UIContextualAction(style: .normal, title: "不用了！") { _, _, completionHandler in
            completionHandler(true)
            
            ProductManager.shared.changeProductStatus(appleId: self.products[indexPath.row].id)
            
            self.products.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }

        addToChange.backgroundColor = UIColor.lightGray
        addToChange.image = UIImage(named: "exchange32*32")

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

            let filteredArrayByName = self.products.filter { product -> Bool in
                product.name.contains(searchText)
            }

            self.filteredProducts.append(contentsOf: filteredArrayByName)
        }

        self.tableView.reloadData()
    }
}

extension MyListViewController: UIAlertViewDelegate {
    
    func showExpiredWarningAlert(products: [Product]) {
        
        // 檢查每個產品的過期時間, 將即將過期的產品名稱, 組成一個字串
        var willExpiredProductNames = ""

        products.forEach { (product) in
            let now = Date().timeIntervalSince1970
            let oneDaySeconds: Double = (24 * 60 * 60)
            let willExpired = (product.expiryDate - now) <= (oneDaySeconds * 30)
            if willExpired {
                willExpiredProductNames.append(product.name)
                willExpiredProductNames.append("\n")
            }
        }

        // 建立提示框
        let alertController = UIAlertController(title: "快看什麼東西要到期了！",
                                                message: willExpiredProductNames,
                                                preferredStyle: .alert)
        // 建立確認按鈕
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)

        alertController.addAction(okAction)

        // 顯示提示框
        self.present(alertController, animated: true, completion: nil)

        self.didShowExpiredWarning = true
        
        /*
         * NOTE: Title 有圖片的 Alert
        // Create the image NSTextAttachment
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named: "attention")

        let attributedTitle = NSAttributedString(attachment: imageAttachment)

        let alertController = UIAlertController(
            title: "", // This gets overridden below.
            message: "倒數30天就到期囉！\nP1\nP2\nP3\n1\n1\n1\n1\n1\n1\n1\n1\n1\n1\n1\n1\n1\n1\n1\n1\n1\n1\n1\n1\n1\n1\n1\n1\n1",
            preferredStyle: .alert
        )

        let okAction = UIAlertAction(title: "OK", style: .cancel) { _ -> Void in
        }
        alertController.addAction(okAction)

        // override title
        alertController.setValue(attributedTitle, forKey: "attributedTitle")

        self.present(alertController, animated: true, completion: nil)
        */
    }
}
