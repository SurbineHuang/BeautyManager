//
//  ProductViewController.swift
//  BeautyManager
//
//  Created by SurbineHuang on 14/5/21.
//

import UIKit
import Firebase

class ProductViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var brandTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var expiryTextField: UITextField!
    @IBOutlet weak var openedTextField: UITextField!
    @IBOutlet weak var periodTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    let datePicker: UIDatePicker = UIDatePicker()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dateFormatter.dateFormat = "yyyy.MM.dd"
        
        // 設定 datePicker 功能及外觀
        self.datePicker.datePickerMode = .date
        self.datePicker.locale = NSLocale(
            localeIdentifier: "zh_TW") as Locale
        
        self.datePicker.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        self.datePicker.preferredDatePickerStyle = .wheels
        
        // 設定 textField 外觀
        self.expiryTextField.backgroundColor = .clear
        self.expiryTextField.borderStyle = .none
        self.expiryTextField.inputView = self.datePicker
        
        self.openedTextField.backgroundColor = .clear
        self.openedTextField.borderStyle = .none
        self.openedTextField.inputView = self.datePicker
        
        self.periodTextField.backgroundColor = .clear
        self.periodTextField.borderStyle = .none
        self.periodTextField.inputView = self.datePicker
        
        // 設定空白處點選結束
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        self.view.addGestureRecognizer(tapGesture)
        
        // 設定 nameTextField
        self.nameTextField.delegate = self
        
        self.nameTextField.clearButtonMode = .whileEditing
        self.typeTextField.clearButtonMode = .whileEditing
        self.brandTextField.clearButtonMode = .whileEditing
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        
        if self.expiryTextField.isFirstResponder {
            self.expiryTextField.text = self.dateFormatter.string(from: datePicker.date)
            
        } else if self.openedTextField.isFirstResponder {
            self.openedTextField.text = self.dateFormatter.string(from: datePicker.date)
            
        } else if self.periodTextField.isFirstResponder {
            self.periodTextField.text = self.dateFormatter.string(from: datePicker.date)
        }
    }
    
    @objc func viewTapped() {
        self.view.endEditing(true)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addTapped(_ sender: Any) {
        
        guard let name = self.nameTextField.text, !name.isEmpty else {
            print("Error: product is empty")
            return
        }
        
        guard let brand = self.brandTextField.text, !brand.isEmpty else {
            print("Error: brand is empty")
            return
        }
        
        guard let type = self.typeTextField.text, !type.isEmpty else {
            print("Error: type is empty")
            return
        }
        
        guard let expiryDateStr = self.expiryTextField.text else {
            print("Error: expiryDate text is nil")
            return
        }
    
        guard let expiryDate = self.dateFormatter.date(from: expiryDateStr) else {
            print("Error: expiryDate can not parse to date")
            return
        }
        
        guard let openedDateStr = self.openedTextField.text else {
            print("Error: openedDate text is nil")
            return
        }
    
        guard let openedDate = self.dateFormatter.date(from: openedDateStr) else {
            print("Error: openedDate can not parse to date")
            return
        }
        
        guard let periodAfterOpeningStr = self.periodTextField.text else {
            print("Error: periodAfterOpening text is nil")
            return
        }
    
        guard let periodAfterOpening = self.dateFormatter.date(from: periodAfterOpeningStr) else {
            print("Error: periodAfterOpening can not parse to date")
            return
        }
        
        ProductManager.shared.addProduct(name: name,
                                         expiryDate: expiryDate.timeIntervalSince1970,
                                         openedDate: openedDate.timeIntervalSince1970,
                                         periodAfterOpening: periodAfterOpening.timeIntervalSince1970)
        
//        ProductManager.shared.addBrand(brand: brand)
//        ProductManager.shared.addType(type: type)
//        
        self.dismiss(animated: true, completion: nil)
    }
}
